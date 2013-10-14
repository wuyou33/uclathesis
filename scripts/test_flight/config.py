# Crazyflie configuration
#crazyradio = 'radio://0/10/250K'
crazyradio = 'radio://0/10/1M'

# General test flight configuration
command_freq 				= 10 # Hz

# Logging setup
motor_log_period			= 50 # ms
acc_log_period				= 50 # ms
gyro_log_period				= 50 # ms


# Increasing step
step_min_thrust          	= 30000
step_max_thrust          	= 40000     # Liftoff at 37000-38000
step_thrust_increment    	= 1000
step_thrust_hold_time    	= 1 # sec

# Hover
hover_thrust 				= 37500
hover_time					= 2 # sec

# PRBS
prbs_scaling_factor 		= 10
prbs_pretest_hover_time  	= 2 # sec
prbs_max_pitch           	= 25 # deg
prbs_max_roll            	= prbs_max_pitch
prbs_max_yaw_rate        	= 35 # deg/sec
prbs_hover_thrust        	= 38500