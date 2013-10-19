clear all
close all
clc
%format longG

run_id = '20131017212836';
interp_method = 'nearest';
collection_freq = 50; % Hz
front_trim = 5; % number of measurements to trim off the front
back_trim = 5; % number of measurements to trim off the back


% Read the raw csv data in to matrices
data_path = '../data/raw_flight_test_data/';
motor_filename = strcat(data_path, run_id, '/', run_id, '_motor.csv');
acc_filename = strcat(data_path, run_id, '/', run_id, '_acc.csv');
gyro_filename = strcat(data_path, run_id, '/', run_id, '_gyro.csv');

motor = csvread(motor_filename, 1, 0);
acc = csvread(acc_filename, 1, 0);
gyro = csvread(gyro_filename, 1, 0);

% Apply linear interpolation to non-uniformly sampled data to generate
% uniormly spaced samples
min_t = min([min(motor(:,1)) min(acc(:,1)) min(gyro(:,1))]);
max_t = max([max(motor(:,1)) max(acc(:,1)) max(gyro(:,1))]);

ts = 1/collection_freq;

uniform_t = [min_t:ts:max_t];

motor_1_i = interp1(motor(:,1),motor(:,2),uniform_t,interp_method);
motor_2_i = interp1(motor(:,1),motor(:,3),uniform_t,interp_method);
motor_3_i = interp1(motor(:,1),motor(:,4),uniform_t,interp_method);
motor_4_i = interp1(motor(:,1),motor(:,5),uniform_t,interp_method);

acc_x_i = interp1(acc(:,1),acc(:,2),uniform_t,interp_method);
acc_y_i = interp1(acc(:,1),acc(:,3),uniform_t,interp_method);
acc_z_i = interp1(acc(:,1),acc(:,4),uniform_t,interp_method);

gyro_x_i = interp1(gyro(:,1),gyro(:,2),uniform_t,interp_method);
gyro_y_i = interp1(gyro(:,1),gyro(:,3),uniform_t,interp_method);
gyro_z_i = interp1(gyro(:,1),gyro(:,4),uniform_t,interp_method);

u = [motor_1_i; motor_2_i; motor_3_i; motor_4_i]';
y = [acc_x_i; acc_y_i; acc_z_i; gyro_x_i; gyro_y_i; gyro_z_i]';

y_trim = y(3:end-1, :);
u_trim = u(3:end-1, :);

% Save results to .mat file
out_file = strcat('../data/flight_test_data/', run_id, '.mat');
save(out_file, 'u', 'y')


% figure(1)
% subplot(3,1,1)
% plot(motor(:,2), 'b-')
% hold on
% plot(motor(:,3), 'g-')
% plot(motor(:,4), 'r-')
% plot(motor(:,5), 'k-')
% 
% subplot(3,1,2)
% plot(acc(:,2), 'b-')
% hold on
% plot(acc(:,3), 'g-')
% plot(acc(:,4), 'r-')
% 
% subplot(3,1,3)
% plot(gyro(:,2), 'b-')
% hold on
% plot(gyro(:,3), 'g-')
% plot(gyro(:,4), 'r-')
% 
% 
% figure(2)
% subplot(3,1,1)
% plot(acc(:,1), acc(:,2), 'g--')
% hold on
% plot(acc_i(:,1), acc_i(:,2), 'b-')
% ylabel('acc.x')
% subplot(3,1,2)
% plot(acc(:,1), acc(:,3), 'g--')
% hold on
% plot(acc_i(:,1), acc_i(:,3), 'b-')
% ylabel('acc.y')
% subplot(3,1,3)
% plot(acc(:,1), acc(:,4), 'g--')
% hold on
% plot(acc_i(:,1), acc_i(:,4), 'b-')
% ylabel('acc.z')
% 
% figure(3)
% subplot(3,1,1)
% plot(gyro(:,1), gyro(:,2), 'g--')
% hold on
% plot(gyro_i(:,1), gyro_i(:,2), 'b-')
% ylabel('gyro.x')
% subplot(3,1,2)
% plot(gyro(:,1), gyro(:,3), 'g--')
% hold on
% plot(gyro_i(:,1), gyro_i(:,3), 'b-')
% ylabel('gyro.y')
% subplot(3,1,3)
% plot(gyro(:,1), gyro(:,4), 'g--')
% hold on
% plot(gyro_i(:,1), gyro_i(:,4), 'b-')
% ylabel('gyro.z')
% 
% figure(4)
% subplot(4,1,1)
% plot(motor(:,1), motor(:,2), 'g--')
% hold on
% plot(motor_i(:,1), motor_i(:,2), 'b-')
% ylabel('motor.1')
% subplot(4,1,2)
% plot(motor(:,1), motor(:,3), 'g--')
% hold on
% plot(motor_i(:,1), motor_i(:,3), 'b-')
% ylabel('motor.2')
% subplot(4,1,3)
% plot(motor(:,1), motor(:,4), 'g--')
% hold on
% plot(motor_i(:,1), motor_i(:,4), 'b-')
% ylabel('motor.3')
% subplot(4,1,4)
% plot(motor(:,1), motor(:,5), 'g--')
% hold on
% plot(motor_i(:,1), motor_i(:,5), 'b-')
% ylabel('motor.4')