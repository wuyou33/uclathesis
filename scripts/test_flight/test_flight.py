import time
import argparse
import logging
import csv
from threading import Thread
import os.path

import cflib
from cflib.crazyflie import Crazyflie
from cfclient.utils.logconfigreader import LogConfig
from cfclient.utils.logconfigreader import LogVariable

from config import *



class TestFlight:
    def __init__(self):
        self.crazyflie = Crazyflie()
        cflib.crtp.init_drivers()

        self.crazyflie.open_link(crazyradio)
        # Set up the callback when connected
        self.crazyflie.connectSetupFinished.add_callback(
            self.connectSetupFinished)

    def connectSetupFinished(self, linkURI):
        # Configure the logger to log accelerometer values and start recording.
 
        # The logging variables are added one after another to the logging
        # configuration. Then the configuration is used to create a log packet
        # which is cached on the Crazyflie. If the log packet is None, the
        # program exits. Otherwise the logging packet receives a callback when
        # it receives data, which prints the data from the logging packet's
        # data dictionary as logging info.

        # # Set accelerometer logging config
        # accel_log_conf = LogConfig("Accel", 10)

        # accel_log_conf.addVariable(LogVariable("acc.x", "float"))
        # accel_log_conf.addVariable(LogVariable("acc.y", "float"))
        # accel_log_conf.addVariable(LogVariable("acc.z", "float"))

        
        # # Now that the connection is established, start logging
        # self.accel_log = self.crazyflie.log.create_log_packet(accel_log_conf)

 
        # if self.accel_log is not None:
        #     self.accel_log.dataReceived.add_callback(self.log_accel_data)
        #     self.accel_log.start()
        # else:
        #     print("acc.x/y/z not found in log TOC")


        # Call the requested thrust profile. 
        # Start a separate thread to run test.
        # Do not hijack the calling thread!
        if args.thrust_profile == 'increasing_step':
            Thread(target=self.increasing_step).start()
        if args.thrust_profile == 'hover':
            Thread(target=self.hover).start()
        if args.thrust_profile == 'prbs':
            Thread(target=self.prbs).start()

    def log_accel_data(self, data):
        logging.info("Accelerometer: x=%.2f, y=%.2f, z=%.2f" %
                        (data["acc.x"], data["acc.y"], data["acc.z"]))


    # THRUST PROFILES
    def increasing_step(self):
        thrust = step_min_thrust
        ts = 1.0/command_freq
        step = 0
        logging.info('Thrust: %i', thrust)


        while thrust <= step_max_thrust:
            self.crazyflie.commander.send_setpoint(
                0, 0, 0, thrust)
            time.sleep(ts)
            step += 1
            if step == step_thrust_hold_time*command_freq:
                thrust += step_thrust_increment
                step = 0
                logging.info('Thrust: %i', thrust)

        self.crazyflie.commander.send_setpoint(0,0,0,0)
        # Make sure that the last packet leaves before the link is closed
        # since the message queue is not flushed before closing
        time.sleep(0.1)
        self.crazyflie.close_link()


    def hover(self):
        ts = 1.0/command_freq
        step = 0

        # Check to see if the thrust has been specified from the command line
        try:
            thrust = args.motor
        except:
            thrust = hover_thrust

        while step*ts <= hover_time:
            self.crazyflie.commander.send_setpoint(
                0, 0, 0, thrust)
            time.sleep(ts)
            step += 1

        self.crazyflie.commander.send_setpoint(0,0,0,0)
        # Make sure that the last packet leaves before the link is closed
        # since the message queue is not flushed before closing
        time.sleep(0.1)
        self.crazyflie.close_link()


    def prbs(self):
        u1 = []
        u2 = []
        u3 = []

        pitch = []
        roll = []
        yaw_rate = []
        thrust = []

        prbs_pitch = []
        prbs_roll = []
        prbs_yaw_rate = []
        prbs_thrust = []

        # Check to see if the thrust has been specified from the command line
        try:
            thrust = args.motor
        except:
            thrust = prbs_hover_thrust

        # Make sure an input file was supplied. If so, read it. Otherwise, exit
        try:
            with open(args.file, 'rb') as f:
                reader = csv.reader(f)
                for row in reader:
                    u1.append(int(row[0]))
                    u2.append(int(row[1]))
                    u3.append(int(row[2]))
        except:
            logging.error('PRBS sequence requires an input file be specified.')
            SystemExit

        prbs_sequence_length = len(u1)

        ts = 1.0/command_freq
        step = 0


        # build a pretest hover profile
        for i in range(prbs_pretest_hover_time*command_freq):
            pitch.append(0)
            roll.append(0)
            yaw_rate.append(0)
            thrust.append(prbs_hover_thrust)
            step += 1

        # build prbs input profile
        for i in range(prbs_sequence_length):
            for j in range(prbs_scaling_factor):
                prbs_pitch.append(u1[i]*prbs_max_pitch)
                prbs_roll.append(u2[i]*prbs_max_roll)
                prbs_yaw_rate.append(u3[i]*prbs_max_yaw_rate)
                prbs_thrust.append(prbs_hover_thrust + 1000)
                step += 1

        # append prbs profile to end of pretest hover profile
        pitch.extend(prbs_pitch)
        roll.extend(prbs_roll)
        yaw_rate.extend(prbs_yaw_rate)
        thrust.extend(prbs_thrust)

        ts = 1.0/command_freq
        step = 0

        while step < len(pitch):
            self.crazyflie.commander.send_setpoint(
                roll[step], 
                pitch[step], 
                yaw_rate[step], 
                thrust[step])
            time.sleep(ts)
            step += 1

        self.crazyflie.commander.send_setpoint(0,0,0,0)
        # Make sure that the last packet leaves before the link is closed
        # since the message queue is not flushed before closing
        time.sleep(0.1)
        self.crazyflie.close_link()






if __name__ == '__main__':
    # Set up command line argument parsing
    parser = argparse.ArgumentParser(
        description='Execute a variety of test flights with the Bitcraze Crazyflie.')
    parser.add_argument('thrust_profile', metavar='thrust_profile', type=str,
        help='Thrust profile to for the test flight. Available options are: increasing_step, hover, prbs')
    parser.add_argument('-f', '--file', type=str,
        help='CSV file containing the input sequence for the test flight. Required when the thrust_profile is prbs.')
    parser.add_argument('-m', '--motor', type=int, help='Base motor speed used during the flight test.')
    args = parser.parse_args()

    # Make sure the args are valid
    if args.thrust_profile not in ['increasing_step', 'hover', 'prbs']:
        print 'Thrust profile not found. Check your spelling, fool!\nTry test_flight.py -h for a list of available thrust profiles.'
        raise SystemExit

    # Set up logging
    logging.basicConfig(level=logging.DEBUG)

    TestFlight()