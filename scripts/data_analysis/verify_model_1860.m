clear all
close all
clc

ts = 1/50;

model = '1860';
shift = [-0.2 0.1 1.1 500 -500 -50];
front_trim = 1;

% Load model
model_path = '/Users/akee/School/UCLA/01 thesis/uclathesis/data/models/20131017212836_63_39500/';
model_file = strcat('parsim_',model, '_8.mat');
load(strcat(model_path, model_file))

% set initial condition
sys.ts = 1/50;


% Load verification data
[ver_file,ver_path] = uigetfile('*.mat','Select verification data', '/Users/akee/School/UCLA/01 thesis/uclathesis/data/');
load(strcat(ver_path, ver_file));
u_ver = u;
y_ver = y;
clear u y

% build iddata object and estimate states
ver_dat = iddata(y_ver,u_ver,ts);
%x0est = findstates(sys,ver_dat);

%sim_opt = simOptions('InitialCondition',x0est);

y_sim = sim(sys,ver_dat.u);

y_sim(:,1) = y_sim(:,1) + shift(1);
y_sim(:,2) = y_sim(:,2) + shift(2);
y_sim(:,3) = y_sim(:,3) + shift(3);
y_sim(:,4) = y_sim(:,4) + shift(4);
y_sim(:,5) = y_sim(:,5) + shift(5);
y_sim(:,6) = y_sim(:,6) + shift(6);

err = y_sim - y_ver;

[pitch_ver, roll_ver, yaw_ver] = complimentary_filter(y_ver(front_trim:end,:));
[pitch_sim, roll_sim, yaw_sim] = complimentary_filter(y_sim(front_trim:end,:));

pitch_ver = detrend(pitch_ver);
roll_ver = detrend(roll_ver);
yaw_ver = detrend(yaw_ver);
pitch_sim = detrend(pitch_sim);
roll_sim = detrend(roll_sim);
yaw_sim = detrend(yaw_sim);


figure(1)
subplot(3,1,1)
plot(pitch_sim, 'b-')
hold on
plot(pitch_ver, 'b--')

subplot(3,1,2)
plot(roll_sim, 'b-')
hold on
plot(roll_ver, 'b--')

subplot(3,1,3)
plot(yaw_sim, 'b-')
hold on
plot(yaw_ver, 'b--')




figure(2)
subplot(6,1,1)
plot(y_ver(:,1), 'b--')
hold on
plot(y_sim(:,1), 'g-')

subplot(6,1,2)
plot(y_ver(:,2), 'b--')
hold on
plot(y_sim(:,2), 'g-')

subplot(6,1,3)
plot(y_ver(:,3), 'b--')
hold on
plot(y_sim(:,3), 'g-')

subplot(6,1,4)
plot(y_ver(:,4), 'b--')
hold on
plot(y_sim(:,4), 'g-')

subplot(6,1,5)
plot(y_ver(:,5), 'b--')
hold on
plot(y_sim(:,5), 'g-')

subplot(6,1,6)
plot(y_ver(:,6), 'b--')
hold on
plot(y_sim(:,6), 'g-')


% figure(3)
% subplot(6,1,1)
% plot(err(:,1), 'b-')
% 
% subplot(6,1,2)
% plot(err(:,2), 'b-')
% 
% subplot(6,1,3)
% plot(err(:,3), 'b-')
% 
% subplot(6,1,4)
% plot(err(:,4), 'b-')
% 
% subplot(6,1,5)
% plot(err(:,5), 'b-')
% 
% subplot(6,1,6)
% plot(err(:,6), 'b-')
