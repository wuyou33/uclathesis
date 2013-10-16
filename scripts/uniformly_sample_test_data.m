clear all
close all
clc


data_path = '../data/raw_flight_test_data/';
motor_filename = '20131013210336_50_motor.csv';
acc_filename = '20131013210336_50_acc.csv';
gyro_filename = '20131013210336_50_gyro.csv';
collection_freq = 50; % Hz
resample_freq = 50; % Hz
interp_method = 'nearest';


motor = csvread(strcat(data_path,motor_filename), 1, 0);
acc = csvread(strcat(data_path,acc_filename), 1, 0);
gyro = csvread(strcat(data_path,gyro_filename), 1, 0);

% Find the time of the first recorded measurement
% Recompute all times relative to t_0
min_t = min([min(motor(:,1)) min(acc(:,1)) min(gyro(:,1))]);
motor(:,1) = motor(:,1) - min_t;
acc(:,1) = acc(:,1) - min_t;
gyro(:,1) = gyro(:,1) - min_t;


% Apply linear interpolation to non-uniformly sampled data to generate
% uniormly spaced samples
x_i = [0.2:1/resample_freq:2];

motor_1_i = interp1(motor(:,1),motor(:,2),x_i, interp_method);
motor_2_i = interp1(motor(:,1),motor(:,3),x_i, interp_method);
motor_3_i = interp1(motor(:,1),motor(:,4),x_i, interp_method);
motor_4_i = interp1(motor(:,1),motor(:,5),x_i, interp_method);
motor_i = [x_i; motor_1_i; motor_2_i; motor_3_i; motor_4_i]';

acc_x_i = interp1(acc(:,1),acc(:,2),x_i, interp_method);
acc_y_i = interp1(acc(:,1),acc(:,3),x_i, interp_method);
acc_z_i = interp1(acc(:,1),acc(:,4),x_i, interp_method);
acc_i = [x_i; acc_x_i; acc_y_i; acc_z_i]';

gyro_x_i = interp1(gyro(:,1),gyro(:,2),x_i, interp_method);
gyro_y_i = interp1(gyro(:,1),gyro(:,3),x_i, interp_method);
gyro_z_i = interp1(gyro(:,1),gyro(:,4),x_i, interp_method);
gyro_i = [x_i; gyro_x_i; gyro_y_i; gyro_z_i]';


figure(1)
subplot(3,1,1)
plot(motor_i(:,2), 'b-')
hold on
plot(motor_i(:,3), 'g-')
plot(motor_i(:,4), 'r-')
plot(motor_i(:,5), 'k-')

subplot(3,1,2)
plot(acc_i(:,2), 'b-')
hold on
plot(acc_i(:,3), 'g-')
plot(acc_i(:,4), 'r-')

subplot(3,1,3)
plot(gyro_i(:,2), 'b-')
hold on
plot(gyro_i(:,3), 'g-')
plot(gyro_i(:,4), 'r-')

figure(2)
plot(acc(:,1), acc(:,4), 'k.-')
hold on
plot(x_i, acc_i(:,4), 'b.-')
legend('raw', interp_method)