clear all
close all
clc

interp_method = 'nearest';
collection_freq = 50; % Hz


% Open data
[acc_file,acc_path] = uigetfile('*.csv','Select the acc output file', '/Users/akee/School/UCLA/01 thesis/uclathesis/data/');
[gyro_file,gyro_path] = uigetfile('*.csv','Select the gyro output file', acc_path);
[motor_file,motor_path] = uigetfile('*.csv','Select the motor input file', acc_path);

motor = csvread(strcat(motor_path, motor_file), 1, 0);
acc = csvread(strcat(acc_path, acc_file), 1, 0);
gyro = csvread(strcat(gyro_path, gyro_file), 1, 0);


% Apply interpolation to non-uniformly sampled data to generate
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

figure(1)
subplot(3,1,1)
plot(u(:,1), 'b-')
hold on
plot(u(:,2), 'g-')
plot(u(:,3), 'r-')
plot(u(:,4), 'k-')

subplot(3,1,2)
plot(y(:,1), 'b-')
hold on
plot(y(:,2), 'g-')
plot(y(:,3), 'r-')

subplot(3,1,3)
plot(y(:,4), 'b-')
hold on
plot(y(:,5), 'g-')
plot(y(:,6), 'r-')


front_trim = input('Front trim: ');
back_trim = input('Back trim: ');

y = y(front_trim:end-back_trim, :);
u = u(front_trim:end-back_trim, :);

clf(gcf)
fh = figure(1);
subplot(3,1,1)
plot(u(:,1), 'b-')
hold on
plot(u(:,2), 'g-')
plot(u(:,3), 'r-')
plot(u(:,4), 'k-')

subplot(3,1,2)
plot(y(:,1), 'b-')
hold on
plot(y(:,2), 'g-')
plot(y(:,3), 'r-')

subplot(3,1,3)
plot(y(:,4), 'b-')
hold on
plot(y(:,5), 'g-')
plot(y(:,6), 'r-')

waitfor(fh);


[out_file, out_path] = uiputfile('*.mat','Save Data As', acc_path);
% Save results to .mat file
save(strcat(out_path, out_file), 'u', 'y')