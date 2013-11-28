clear all
close all
clc

ts = 1/50;

% Load model
load('/Users/akee/School/UCLA/01 thesis/uclathesis/data/models/20131017212836_63_39500/parsim-e_50_8.mat');

% set initial condition
sys.ts = 1/50;


%% Singular Values
load('/Users/akee/School/UCLA/01 thesis/uclathesis/data/models/20131017212836_63_39500/50_singular_values.mat')
trim = 100;
sv = sv(1:trim);
h = figure(1);
plot([8.6 8.6],[0 1.4], 'k:')
hold on
plot(sv, 'k.')
Xlabel = xlabel('Singular Value');
Ylabel = ylabel('Magnitude');

set( gca,...
    'box'         , 'off', ...
    'TickDir'     , 'out'     , ...
    'TickLength'  , [.015 .015] , ...
    'FontName'    , 'AvantGarde', ...
    'FontSize'    , 9, ...
    'XColor'      , [.2 .2 .2], ...
    'YColor'      , [.2 .2 .2]);

set([Xlabel, Ylabel], ...
    'FontName'    , 'AvantGarde', ...
    'FontWeight'  , 'bold', ...
    'FontSize'    , 9);

%% Eigenvalues
h = figure(1);
plot(eig(sys.a), 'kx', 'MarkerSize', 10);
axis([-1.1 1.1 -1.1 1.1])
axis square
hold on
plot([0 0],[-1.1 1.1], 'k-')
plot([-1.1 1.1],[0 0], 'k-')
t = 0:0.001:2*pi;
plot(sin(t),cos(t), 'k:')
Xlabel = xlabel('Real');
Ylabel = ylabel('Imaginary');

set( gca,...
    'box'         , 'on', ...
    'TickDir'     , 'out'     , ...
    'TickLength'  , [.015 .015] , ...
    'FontName'    , 'AvantGarde', ...
    'FontSize'    , 9, ...
    'xTick'       , [-1:.25:1], ...
    'yTick'       , [-1:.25:1], ...
    'XColor'      , [.2 .2 .2], ...
    'YColor'      , [.2 .2 .2]);

set([Xlabel, Ylabel], ...
    'FontName'    , 'AvantGarde', ...
    'FontWeight'  , 'bold', ...
    'FontSize'    , 9);




%% PRBS-A data
pitch_offset = -150;
roll_offset = -100;
g = 1.1;
load('/Users/akee/School/UCLA/01 thesis/uclathesis/data/flight_test/20131017212626_31_38500/20131017212626.mat');
u_prbs = u;
y_prbs = y;
clear u y

y_prbs_sim = sim(sys,u_prbs);


% Detrend and correct data
y_prbs_sim(:,4) = y_prbs_sim(:,4) + pitch_offset;
y_prbs_sim(:,5) = y_prbs_sim(:,5) + roll_offset;
y_prbs_sim = detrend(y_prbs_sim);
y_prbs_sim(:,3) = y_prbs_sim(:,3) + g;

[pitch_prbs, roll_prbs, yaw_prbs] = complimentary_filter(y_prbs);
[pitch_prbs_sim, roll_prbs_sim, yaw_prbs_sim] = complimentary_filter(y_prbs_sim);

figure(1)
subplot(6,1,1)
plot(y_prbs_sim(:,1), 'b-')
hold on
plot(y_prbs(:,1), 'b--')

subplot(6,1,2)
plot(y_prbs_sim(:,2), 'b-')
hold on
plot(y_prbs(:,2), 'b--')

subplot(6,1,3)
plot(y_prbs_sim(:,3), 'b-')
hold on
plot(y_prbs(:,3), 'b--')

subplot(6,1,4)
plot(y_prbs_sim(:,4), 'b-')
hold on
plot(y_prbs(:,4), 'b--')

subplot(6,1,5)
plot(y_prbs_sim(:,5), 'b-')
hold on
plot(y_prbs(:,5), 'b--')

subplot(6,1,6)
plot(y_prbs_sim(:,6), 'b-')
hold on
plot(y_prbs(:,6), 'b--')



figure(2)
subplot(3,1,1)
plot(pitch_prbs_sim, 'b-')
hold on
plot(pitch_prbs, 'b--')

subplot(3,1,2)
plot(roll_prbs_sim, 'b-')
hold on
plot(roll_prbs, 'b--')

subplot(3,1,3)
plot(yaw_prbs_sim, 'b-')
hold on
plot(yaw_prbs, 'b--')


%% PRBS-B data
pitch_offset = -150;
roll_offset = -100;
g = 1.1;
load('/Users/akee/School/UCLA/01 thesis/uclathesis/data/flight_test/20131126162145_63_39500/20131126162145_63_39500.mat');
u_prbs = u;
y_prbs = y;
clear u y

y_prbs_sim = sim(sys,u_prbs);


% Detrend and correct data
y_prbs_sim(:,4) = y_prbs_sim(:,4) + pitch_offset;
y_prbs_sim(:,5) = y_prbs_sim(:,5) + roll_offset;
y_prbs_sim = detrend(y_prbs_sim);
y_prbs_sim(:,3) = y_prbs_sim(:,3) + g;

% Complimentary filter
[pitch_prbs, roll_prbs, yaw_prbs] = complimentary_filter(y_prbs);
[pitch_prbs_sim, roll_prbs_sim, yaw_prbs_sim] = complimentary_filter(y_prbs_sim);


% Prediction error
err = (y_prbs_sim-y_prbs)./y_prbs

figure(1)
subplot(6,1,1)
plot(y_prbs_sim(:,1), 'b-')
hold on
plot(y_prbs(:,1), 'b--')

subplot(6,1,2)
plot(y_prbs_sim(:,2), 'b-')
hold on
plot(y_prbs(:,2), 'b--')

subplot(6,1,3)
plot(y_prbs_sim(:,3), 'b-')
hold on
plot(y_prbs(:,3), 'b--')

subplot(6,1,4)
plot(y_prbs_sim(:,4), 'b-')
hold on
plot(y_prbs(:,4), 'b--')

subplot(6,1,5)
plot(y_prbs_sim(:,5), 'b-')
hold on
plot(y_prbs(:,5), 'b--')

subplot(6,1,6)
plot(y_prbs_sim(:,6), 'b-')
hold on
plot(y_prbs(:,6), 'b--')



figure(2)
subplot(3,1,1)
plot(pitch_prbs_sim, 'b-')
hold on
plot(pitch_prbs, 'b--')

subplot(3,1,2)
plot(roll_prbs_sim, 'b-')
hold on
plot(roll_prbs, 'b--')

subplot(3,1,3)
plot(yaw_prbs_sim, 'b-')
hold on
plot(yaw_prbs, 'b--')

%% Pitch data
%load('/Users/akee/School/UCLA/01 thesis/uclathesis/data/verification/20131121203930_pitch_38000/20131121203930.mat');
%load('/Users/akee/School/UCLA/01 thesis/uclathesis/data/verification/20131126163250_pitch_41000/20131126163250_pitch_41000.mat');
load('/Users/akee/School/UCLA/01 thesis/uclathesis/data/verification/20131126162858_pitch_40000/20131126162858_pitch_40000.mat');
pitch_offset = -150;
roll_offset = -100;
g = 1.1;
u_pitch = u;
y_pitch = y;
clear u y

y_pitch_sim = sim(sys,u_pitch);


% Correct data
y_pitch_sim(:,4) = y_pitch_sim(:,4) + pitch_offset;
y_pitch_sim(:,5) = y_pitch_sim(:,5) + roll_offset;
y_pitch_sim(:,3) = y_pitch_sim(:,3) + g;

[pitch, roll, yaw] = complimentary_filter(y_pitch);
[pitch_sim, roll_sim, yaw_sim] = complimentary_filter(y_pitch_sim);

figure(1)
subplot(6,1,1)
plot(y_pitch_sim(:,1), 'b-')
hold on
plot(y_pitch(:,1), 'b--')

subplot(6,1,2)
plot(y_pitch_sim(:,2), 'b-')
hold on
plot(y_pitch(:,2), 'b--')

subplot(6,1,3)
plot(y_pitch_sim(:,3), 'b-')
hold on
plot(y_pitch(:,3), 'b--')

subplot(6,1,4)
plot(y_pitch_sim(:,4), 'b-')
hold on
plot(y_pitch(:,4), 'b--')

subplot(6,1,5)
plot(y_pitch_sim(:,5), 'b-')
hold on
plot(y_pitch(:,5), 'b--')

subplot(6,1,6)
plot(y_pitch_sim(:,6), 'b-')
hold on
plot(y_pitch(:,6), 'b--')


figure(2)
plot(pitch_sim, 'b-')
hold on
plot(pitch, 'b--')

%% Roll data
pitch_offset = -200;
roll_offset = -100;
g = 1.1;
load('/Users/akee/School/UCLA/01 thesis/uclathesis/data/verification/20131126163313_roll_41000/20131126163313_roll_41000.mat');
u_roll = u;
y_roll = y;
clear u y

y_roll_sim = sim(sys,u_roll);


% Detrend and correct data
y_roll_sim(:,4) = y_roll_sim(:,4) + pitch_offset;
y_roll_sim(:,5) = y_roll_sim(:,5) + roll_offset;
y_roll_sim(:,3) = y_roll_sim(:,3) + g;

[pitch, roll, yaw] = complimentary_filter(y_roll);
[pitch_sim, roll_sim, yaw_sim] = complimentary_filter(y_roll_sim);

figure(1)
subplot(6,1,1)
plot(y_roll_sim(:,1), 'b-')
hold on
plot(y_roll(:,1), 'b--')

subplot(6,1,2)
plot(y_roll_sim(:,2), 'b-')
hold on
plot(y_roll(:,2), 'b--')

subplot(6,1,3)
plot(y_roll_sim(:,3), 'b-')
hold on
plot(y_roll(:,3), 'b--')

subplot(6,1,4)
plot(y_roll_sim(:,4), 'b-')
hold on
plot(y_roll(:,4), 'b--')

subplot(6,1,5)
plot(y_roll_sim(:,5), 'b-')
hold on
plot(y_roll(:,5), 'b--')

subplot(6,1,6)
plot(y_roll_sim(:,6), 'b-')
hold on
plot(y_roll(:,6), 'b--')


figure(2)
subplot(3,1,1)
plot(pitch_sim, 'b-')
hold on
plot(pitch, 'b--')

subplot(3,1,2)
plot(roll_sim, 'b-')
hold on
plot(roll, 'b--')

subplot(3,1,3)
plot(yaw_sim, 'b-')
hold on
plot(yaw, 'b--')

%% Yaw data
pitch_offset = -200;
roll_offset = -100;
g = 1.1;
load('/Users/akee/School/UCLA/01 thesis/uclathesis/data/verification/20131126163349_yaw_41000/20131126163349_yaw_41000.mat');
u_yaw = u;
y_yaw = y;
clear u y

y_yaw_sim = sim(sys,u_yaw);


% Detrend and correct data
y_yaw_sim(:,4) = y_yaw_sim(:,4) + pitch_offset;
y_yaw_sim(:,5) = y_yaw_sim(:,5) + roll_offset;
y_yaw_sim(:,3) = y_yaw_sim(:,3) + g;

[pitch, roll, yaw] = complimentary_filter(y_yaw);
[pitch_sim, roll_sim, yaw_sim] = complimentary_filter(y_yaw_sim);

figure(1)
subplot(6,1,1)
plot(y_yaw_sim(:,1), 'b-')
hold on
plot(y_yaw(:,1), 'b--')

subplot(6,1,2)
plot(y_yaw_sim(:,2), 'b-')
hold on
plot(y_yaw(:,2), 'b--')

subplot(6,1,3)
plot(y_yaw_sim(:,3), 'b-')
hold on
plot(y_yaw(:,3), 'b--')

subplot(6,1,4)
plot(y_yaw_sim(:,4), 'b-')
hold on
plot(y_yaw(:,4), 'b--')

subplot(6,1,5)
plot(y_yaw_sim(:,5), 'b-')
hold on
plot(y_yaw(:,5), 'b--')

subplot(6,1,6)
plot(y_yaw_sim(:,6), 'b-')
hold on
plot(y_yaw(:,6), 'b--')


figure(2)
subplot(3,1,1)
plot(pitch_sim, 'b-')
hold on
plot(pitch, 'b--')

subplot(3,1,2)
plot(roll_sim, 'b-')
hold on
plot(roll, 'b--')

subplot(3,1,3)
plot(yaw_sim, 'b-')
hold on
plot(yaw, 'b--')