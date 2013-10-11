import csv

#from config import *

prbs_scaling_factor = 5
command_freq 		= 100 # Hz

max_pitch 			= 5	# deg
max_roll 			= max_pitch
max_yaw_rate 		= 20	# deg/sec
hover_thrust        = 37500

pretest_hover_time	= 1 # sec



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


with open('prbs_inputs_15.csv', 'rb') as f:
    reader = csv.reader(f)
    for row in reader:
        u1.append(int(row[0]))
        u2.append(int(row[1]))
        u3.append(int(row[2]))

prbs_sequence_length = len(u1)

test_flight_length = (prbs_scaling_factor * prbs_sequence_length * 1.0)/command_freq + pretest_hover_time


ts = 1.0/command_freq
step = 0


# build a pretest hover profile
for i in range(pretest_hover_time*command_freq):
	pitch.append(0)
	roll.append(0)
	yaw_rate.append(0)
	thrust.append(hover_thrust)
	step += 1

# build prbs input profile
for i in range(prbs_sequence_length):
	for j in range(prbs_scaling_factor):
		prbs_pitch.append(u1[i]*max_pitch)
		prbs_roll.append(u2[i]*max_roll)
		prbs_yaw_rate.append(u3[i]*max_yaw_rate)
		prbs_thrust.append(hover_thrust)
		step += 1

# append prbs profile to end of pretest hover profile
pitch.extend(prbs_pitch)
roll.extend(prbs_roll)
yaw_rate.extend(prbs_yaw_rate)
thrust.extend(prbs_thrust)

for i in range(len(pitch)):
	print i, pitch[i], roll[i], yaw_rate[i], thrust[i]
