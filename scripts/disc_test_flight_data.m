clear all
close all
clc


data_path = '../data/flight_test_data/raw/20131013181929_hover_40Hz/';
motor_filename = '20131013181929_motor.csv';
acc_filename = '20131013181929_acc.csv';
gyro_filename = '20131013181929_gyro.csv';
collection_freq = 40; % Hz


motor = csvread(strcat(data_path,motor_filename), 1, 0);
acc = csvread(strcat(data_path,acc_filename), 1, 0);
gyro = csvread(strcat(data_path,gyro_filename), 1, 0);

% Find the time of the first recorded measurement
% Recompute all times relative to t_0
min_t = min([min(motor(:,1)) min(acc(:,1)) min(gyro(:,1))]);
motor(:,1) = motor(:,1) - min_t;
acc(:,1) = acc(:,1) - min_t;
gyro(:,1) = gyro(:,1) - min_t;

figure(1)
subplot(3,1,1)
plot(motor(:,2), 'b-')
hold on
plot(motor(:,3), 'g-')
plot(motor(:,4), 'r-')
plot(motor(:,5), 'k-')

subplot(3,1,2)
plot(acc(:,2), 'b-')
hold on
plot(acc(:,3), 'g-')
plot(acc(:,4), 'r-')

subplot(3,1,3)
plot(gyro(:,2), 'b-')
hold on
plot(gyro(:,3), 'g-')
plot(gyro(:,4), 'r-')
