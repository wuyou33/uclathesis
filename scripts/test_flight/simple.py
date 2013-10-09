import time
from threading import Thread

import cflib
from cflib.crazyflie import Crazyflie

class Main:
    def __init__(self):
        self.crazyflie = Crazyflie()
        cflib.crtp.init_drivers()

        # You may need to update this value if your Crazyradio uses a different frequency.
        self.crazyflie.open_link("radio://0/10/250K")
        # Set up the callback when connected
        self.crazyflie.connectSetupFinished.add_callback(self.connectSetupFinished)

    def connectSetupFinished(self, linkURI):
        # Start a separate thread to do the motor test.
        # Do not hijack the calling thread!
        Thread(target=self.pulse_command).start()

    def increasing_step(Self):
        min_thrust          = 10000
        max_thrust          = 30000
        thrust_increment    = 1000
        thrust_hold_time    = 2 # sec
        update_freq         = 10 # Hz

        pitch               = 0
        roll                = 0
        yaw_rate            = 0

        thrust = min_thrust
        ts = 1.0/update_freq
        step = 0


        while thrust <= max_thrust:
            self.crazyflie.commander.send_setpoint(
                roll, pitch, yawrate, thrust)
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



    def pulse_command(self):
        thrust_mult = 1
        thrust_step = 500
	    thrust = 20000
        pitch = 0
        roll = 0
        yawrate = 0
        while thrust >= 20000:
	       self.crazyflie.commander.send_setpoint(roll, pitch, yawrate, thrust)
            time.sleep(0.1)
            if (thrust >= 25000):
                thrust_mult = -1
            thrust = thrust + (thrust_step * thrust_mult)
        self.crazyflie.commander.send_setpoint(0,0,0,0)
        # Make sure that the last packet leaves before the link is closed
        # since the message queue is not flushed before closing
	    time.sleep(0.1)
        self.crazyflie.close_link()




Main()
