import time
import argparse
import logging
from threading import Thread

import cflib
from cflib.crazyflie import Crazyflie
from cfclient.utils.logconfigreader import LogConfig
from cfclient.utils.logconfigreader import LogVariable



# CONFIGURATION                                                           
crazyradio = 'radio://0/10/250K'





# Set up command line argument parsing
parser = argparse.ArgumentParser(
    description='Execute a variety of test flights with the Bitcraze Crazyflie.')
parser.add_argument('thrust_profile', metavar='thrust_profile', type=str,
    help='Thrust profile to use for the test flight. Available options are: increasing_step, prbs_hover, prbs_asc, prbs_desc.')
args = parser.parse_args()

# Make sure the requested thrust profile is valid
if args.thrust_profile not in ['increasing_step', 'prbs_hover', 'prbs_asc', 'prbs_desc']:
    print 'Requested thrust profile not found. Check your spelling, fool!\nTry test_flight.py -h for a list of available thrust profiles.'
    raise SystemExit


# Set up logging
logging.basicConfig(level=logging.DEBUG)


class TestFlight:
    def __init__(self):
        self.crazyflie = Crazyflie()
        cflib.crtp.init_drivers()

        self.crazyflie.open_link(crazyradio)
        # Set up the callback when connected
        self.crazyflie.connectSetupFinished.add_callback(self.connectSetupFinished)

    def connectSetupFinished(self, linkURI):
        # Configure the logger to log accelerometer values and start recording.
 
        # The logging variables are added one after another to the logging
        # configuration. Then the configuration is used to create a log packet
        # which is cached on the Crazyflie. If the log packet is None, the
        # program exits. Otherwise the logging packet receives a callback when
        # it receives data, which prints the data from the logging packet's
        # data dictionary as logging info.

        # Set accelerometer logging config
        accel_log_conf = LogConfig("Accel", 10)

        accel_log_conf.addVariable(LogVariable("acc.x", "float"))
        accel_log_conf.addVariable(LogVariable("acc.y", "float"))
        accel_log_conf.addVariable(LogVariable("acc.z", "float"))

        
        # Now that the connection is established, start logging
        self.accel_log = self.crazyflie.log.create_log_packet(accel_log_conf)

 
        if self.accel_log is not None:
            self.accel_log.dataReceived.add_callback(self.log_accel_data)
            self.accel_log.start()
        else:
            print("acc.x/y/z not found in log TOC")


        # Call the requested thrust profile. 
        # Start a separate thread to run test.
        # Do not hijack the calling thread!
        if args.thrust_profile == 'increasing_step':
            Thread(target=self.increasing_step).start()
        if args.thrust_profile == 'prbs_hover':
            Thread(target=self.prbs_hover).start()
        if args.thrust_profile == 'prbs_asc':
            Thread(target=self.prbs_asc).start()
        if args.thrust_profile == 'prbs_desc':
            Thread(target=self.prbs_desc).start()

    def log_accel_data(self, data):
        logging.info("Accelerometer: x=%.2f, y=%.2f, z=%.2f" %
                        (data["acc.x"], data["acc.y"], data["acc.z"]))


    # THRUST PROFILES
    def increasing_step(self):
        min_thrust          = 39000
        max_thrust          = 40000     # Liftoff at 37000-38000
        thrust_increment    = 1000
        thrust_hold_time    = 1 # sec
        update_freq         = 10 # Hz

        pitch               = 0
        roll                = 0
        yaw_rate            = 0

        thrust = min_thrust
        ts = 1.0/update_freq
        step = 0


        while thrust <= max_thrust:
	    print thrust
            self.crazyflie.commander.send_setpoint(
                roll, pitch, yaw_rate, thrust)
            time.sleep(ts)
            step += 1
            if step == thrust_hold_time*update_freq:
                thrust += thrust_increment
                step = 0

        self.crazyflie.commander.send_setpoint(0,0,0,0)
        # Make sure that the last packet leaves before the link is closed
        # since the message queue is not flushed before closing
        time.sleep(0.1)
        self.crazyflie.close_link()

    def prbs_hover(self):
        break

    def prbs_asc(self):
        break

    def prbs_desc(self):
        break


TestFlight()
