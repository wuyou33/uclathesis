import time
import logging
from threading import Thread

import cflib.crtp
from cfclient.utils.logconfigreader import LogConfig
from cfclient.utils.logconfigreader import LogVariable
from cflib.crazyflie import Crazyflie

logging.basicConfig(
	level = logging.DEBUG,
	# format = '%(levelname)s: %(message)s',
	filename = 'data.txt'
	)

class TestFlight:
	def __init__(self):
		"""
		Create the crazyflie object, initialize drivers, and set up a
		callback which is called once a connection with the vehicle is
		established. Finally, we connect to the vehcile.
		"""
		self.crazyflie = Crazyflie()
		cflib.crtp.init_drivers()

		self.crazyflie.connectSetupFinished.add_callback(
						self.connectSetupFinished)

		self.crazyflie.open_link('radio://0/10/250K')


	def connectSetupFinished(self, linkURI):
		"""
		Start a separate thread for each function.
		Do not hijack the calling thread!
		"""
		Thread(target = self.start_logging).start()

	def start_logging(self):
		"""
		Configure the logger to capture motor inputs and accelerometer
		and gyroscope outputs.

		The logging variables are added one after another to the logging
		configuration. Then the configuration is used to create a log
		packet which is cached on the Crazyflie. If the log packet is
		None, the program exits. Otherwise the logging packet receives a
		callback when it receives data.
		"""

		# Logging config
		log_conf = LogConfig('Log', 10)		# FILENAME ALSO AVAILABLE

		# Accelerometer
		log_conf.addVariable(LogVariable('acc.x', 'float'))
		log_conf.addVariable(LogVariable('acc.y', 'float'))
		log_conf.addVariable(LogVariable('acc.z', 'float'))

		# Gyro


		# Motors



		# Since the connection is already established, we can start logging
		self.log_data = self.crazyflie.log.create_log_packet(log_conf)

		if self.log_data is not None:
			self.log_data.dataReceived.add_callback(self.write_log)
			self.log_data.start()
		else:
			print('One or more log variables not found in TOC')


	def write_log(self, data):
		logging.info('Accelerometer: %.2f %.2f %.2f' %
			(data['acc.x'], data['acc.y']. data['acc.z']))










if __name__ == '__main__':
	TestFlight()
