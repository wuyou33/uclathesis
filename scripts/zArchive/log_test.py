import time
 
import cflib.crtp
from cfclient.utils.logconfigreader import LogConfig
from cfclient.utils.logconfigreader import LogVariable
from cflib.crazyflie import Crazyflie
 
#logging.basicConfig(level=logging.DEBUG)
 
log_data = []


class Main:
    """
    Class is required so that methods can access the object fields.
    """
    def __init__(self):
        """
        Connect to Crazyflie, initialize drivers and set up callback.
 
        The callback takes care of logging the accelerometer values.
        """
        self.crazyflie = Crazyflie()
        cflib.crtp.init_drivers()
 
        self.crazyflie.connectSetupFinished.add_callback(
                                                    self.connectSetupFinished)
 
        self.crazyflie.open_link("radio://0/10/250K")
 
    def connectSetupFinished(self, linkURI):
        """
        Configure the logger to log accelerometer values and start recording.
 
        The logging variables are added one after another to the logging
        configuration. Then the configuration is used to create a log packet
        which is cached on the Crazyflie. If the log packet is None, the
        program exits. Otherwise the logging packet receives a callback when
        it receives data, which prints the data from the logging packet's
        data dictionary as logging info.
        """

        logging_period = 20

        # Set gyro logging config
        gyro_log_conf = LogConfig("gyro", logging_period)
        gyro_log_conf.addVariable(LogVariable("gyro.x", "float"))
        gyro_log_conf.addVariable(LogVariable("gyro.y", "float"))
        gyro_log_conf.addVariable(LogVariable("gyro.z", "float"))

        # Set accelerometer logging config
        acc_log_conf = LogConfig("acc", logging_period)
        acc_log_conf.addVariable(LogVariable("acc.x", "float"))
        acc_log_conf.addVariable(LogVariable("acc.y", "float"))
        acc_log_conf.addVariable(LogVariable("acc.z", "float"))

        # Set motor logging config
        motor_log_conf = LogConfig("motor", logging_period)
        motor_log_conf.addVariable(LogVariable("motor.m1", "int32"))
        motor_log_conf.addVariable(LogVariable("motor.m2", "int32"))
        motor_log_conf.addVariable(LogVariable("motor.m3", "int32"))
        motor_log_conf.addVariable(LogVariable("motor.m4", "int32"))


        # Now that the connection is established, start logging
        self.gyro_log = self.crazyflie.log.create_log_packet(gyro_log_conf)
        self.acc_log = self.crazyflie.log.create_log_packet(acc_log_conf)
        self.motor_log = self.crazyflie.log.create_log_packet(motor_log_conf)
 
        if self.gyro_log is not None:
            self.gyro_log.data_received.add_callback(self.gyro_data)
            self.gyro_log.start()
        else:
            print("gyro.x/y/z not found in log TOC")

        if self.acc_log is not None:
            self.acc_log.data_received.add_callback(self.acc_data)
            self.acc_log.start()
        else:
            print("acc.x/y/z not found in log TOC")

        if self.motor_log is not None:
            self.motor_log.data_received.add_callback(self.motor_data)
            self.motor_log.start()
        else:
            print("motor.1/2/3/4 not found in log TOC")


        
 
        
 
    def gyro_data(self, data):
        log_data.append('gyro, %f, %f, %f, %f' % 
            time.time(), data["gyro.x"], data["gyro.y"], data["gyro.z"])
    def acc_data(self, data):
        log_data.append('acc, %f, %f, %f, %f' %
            time.time(), data["acc.x"], data["acc.y"], data["acc.z"])
    def motor_data(self, data):
        log_data.append('motor, %i, %i, %i, %i' % 
            time.time(), data["motor.m1"], data["motor.m2"], data["motor.m3"], data["motor.m4"])
 
Main()