import time
import datetime
import argparse
import logging
import csv
import os.path
from threading import Thread

import cflib
from cflib.crazyflie import Crazyflie
from cfclient.utils.logconfigreader import LogConfig
from cfclient.utils.logconfigreader import LogVariable

from config import *



class TestFlight:
    def __init__(self):
        self.log_data = []

        self.crazyflie = Crazyflie()

        cflib.crtp.init_drivers()

        self.crazyflie.open_link(crazyradio)

        # Set up the callback when connected
        self.crazyflie.connectSetupFinished.add_callback(
            self.connectSetupFinished)

    def connectSetupFinished(self, linkURI):
        log_timestamp = datetime.datetime.now().strftime('%Y%m%d%H%M%S')
        self.motor_log_filename = str(log_timestamp) + '_motor.csv'
        self.acc_log_filename = str(log_timestamp) + '_acc.csv'
        self.gyro_log_filename = str(log_timestamp) + '_gyro.csv'

        Thread(target = self.motor_log).start()
        Thread(target = self.acc_log).start()
        Thread(target = self.gyro_log).start()


        # Call the requested thrust profile. 
        # Start a separate thread to run test.
        # Do not hijack the calling thread!
        if args.thrust_profile == 'increasing_step':
            Thread(target=self.increasing_step).start()
        if args.thrust_profile == 'hover':
            Thread(target=self.hover).start()
        if args.thrust_profile == 'prbs':
            Thread(target=self.prbs).start()


    # LOGGING METHODS
    # - - - - - - - -
    def motor_log(self):
        motor_log_file = open(self.motor_log_filename, 'wb')
        self.motor_writer = csv.writer(motor_log_file)
        self.motor_writer.writerow(['time','m1','m2','m3','m4'])

        motor_log_config = LogConfig('motor', motor_log_period)
        motor_log_config.addVariable(LogVariable('motor.m1', 'uint32_t'))
        motor_log_config.addVariable(LogVariable('motor.m2', 'uint32_t'))
        motor_log_config.addVariable(LogVariable('motor.m3', 'uint32_t'))
        motor_log_config.addVariable(LogVariable('motor.m4', 'uint32_t'))

        self.motor_log = self.crazyflie.log.create_log_packet(motor_log_config)
        if (self.motor_log is not None):
            self.motor_log.data_received.add_callback(self.motor_data)
            self.motor_log.error.add_callback(self.logging_error)
            self.motor_log.start()
        else:
            logger.warning("Could not setup logconfiguration after connection!")
    def motor_data(self, data):
        self.motor_writer.writerow([time.time(), data['motor.m1'], data['motor.m2'], data['motor.m3'], data['motor.m4']])


    def acc_log(self):
        acc_log_file = open(self.acc_log_filename, 'wb')
        self.acc_writer = csv.writer(acc_log_file)
        self.acc_writer.writerow(['time','acc.x','acc.y','acc.z'])

        acc_log_config = LogConfig('acc', acc_log_period)
        acc_log_config.addVariable(LogVariable('acc.x', 'float'))
        acc_log_config.addVariable(LogVariable('acc.y', 'float'))
        acc_log_config.addVariable(LogVariable('acc.z', 'float'))

        self.acc_log = self.crazyflie.log.create_log_packet(acc_log_config)
        if (self.acc_log is not None):
            self.acc_log.data_received.add_callback(self.acc_data)
            self.acc_log.error.add_callback(self.logging_error)
            self.acc_log.start()
        else:
            logger.warning("Could not setup logconfiguration after connection!")
    def acc_data(self, data):
        self.acc_writer.writerow([time.time(), data['acc.x'], data['acc.y'], data['acc.z']])

    def gyro_log(self):
        gyro_log_file = open(self.gyro_log_filename, 'wb')
        self.gyro_writer = csv.writer(gyro_log_file)
        self.gyro_writer.writerow(['time','gyro.x','gyro.y','gyro.z'])

        gyro_log_config = LogConfig('gyro', gyro_log_period)
        gyro_log_config.addVariable(LogVariable('gyro.x', 'float'))
        gyro_log_config.addVariable(LogVariable('gyro.y', 'float'))
        gyro_log_config.addVariable(LogVariable('gyro.z', 'float'))

        self.gyro_log = self.crazyflie.log.create_log_packet(gyro_log_config)
        if (self.gyro_log is not None):
            self.gyro_log.data_received.add_callback(self.gyro_data)
            self.gyro_log.error.add_callback(self.logging_error)
            self.gyro_log.start()
        else:
            logger.warning("Could not setup logconfiguration after connection!")
    def gyro_data(self, data):
        self.gyro_writer.writerow([time.time(), data['gyro.x'], data['gyro.y'], data['gyro.z']])

    def logging_error(self):
        logger.warning("Callback of error in LogEntry :(")


    # THRUST PROFILES
    # - - - - - - - -
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

        pitch = 0
        roll = 0
        yaw_rate = 0

        # Check to see if the thrust has been specified from the command line
        try:
            thrust = int(args.motor)
        except:
            thrust = int(hover_thrust)

        while step*ts <= hover_time:
            self.crazyflie.commander.send_setpoint(roll, pitch, yaw_rate, thrust)
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
    logging.basicConfig(level=logging.INFO)

    TestFlight()