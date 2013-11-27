# Crazyflie configuration
#crazyradio = 'radio://0/10/250K'
#crazyradio = 'radio://0/10/1M'
crazyradio = 'radio://0/10/2M'

# General test flight configuration
command_freq 				= 10 # Hz

# Logging setup
log_freq					= 60 # Hz

# Increasing step
step_min_thrust          	= 30000
step_max_thrust          	= 40000     # Liftoff at 37000-38000
step_thrust_increment    	= 1000
step_thrust_hold_time    	= 1 # sec

# Hover
hover_thrust 				= 39500
hover_time					= 2 # sec

# PRBS
prbs_scaling_factor 		= 1
prbs_pretest_hover_time  	= 2 # sec
prbs_max_pitch           	= 30 # deg
prbs_max_roll            	= prbs_max_pitch
prbs_max_yaw_rate        	= 180 # deg/sec
prbs_hover_thrust        	= 41000