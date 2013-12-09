clear all
close all
clc

ts = 1/50;

model = '1760';
shift = [-0.4 0.3 1.5 1500 -130 -190]; % -1180
moesp_shift = [0 -0.25 1 -1000 0 -900];
front_trim = 1;
gray = [0.6,0.6,0.6];

fig_dir = '/Users/akee/School/UCLA/01 thesis/uclathesis/fig/';
fig_name = 'sim_1760_moesp.eps';

% Load parsim model
model_path = '/Users/akee/School/UCLA/01 thesis/uclathesis/data/models/20131017212836_63_39500/';
model_file = strcat('parsim_',model, '_8.mat');
load(strcat(model_path, model_file))
% set initial condition
sys.ts = 1/50;
sys_parsim = sys;
clear sys

% Load moesp model
model_path = '/Users/akee/School/UCLA/01 thesis/uclathesis/data/models/20131017212836_63_39500/';
model_file = strcat('moesp_5.mat');
load(strcat(model_path, model_file))
% set initial condition
sys.ts = 1/50;
sys_moesp = sys;


% Load verification data
ver_path = '/Users/akee/School/UCLA/01 thesis/uclathesis/data/flight_test/';
ver_file = '20131017212626_31_38500/20131017212626.mat';
load(strcat(ver_path, ver_file));
u_ver = u;
y_ver = y;
clear u y

% build iddata object and estimate states
ver_dat = iddata(y_ver,u_ver,ts);
x0est = findstates(sys,ver_dat);


% estimate parsim model
y_parsim = sim(sys_parsim,ver_dat.u);
%y_sim = sim(sys,ver_dat.u, 'InitialCondition',x0est);

y_parsim(:,1) = y_parsim(:,1) + shift(1);
y_parsim(:,2) = y_parsim(:,2) + shift(2);
y_parsim(:,3) = y_parsim(:,3) + shift(3);
y_parsim(:,4) = y_parsim(:,4) + shift(4);
y_parsim(:,5) = detrend(y_parsim(:,5));
y_parsim(:,5) = y_parsim(:,5) + shift(5);
y_parsim(:,6) = y_parsim(:,6) + shift(6);

y_ver(:,6) = detrend(y_ver(:,6));
y_ver(:,5) = detrend(y_ver(:,5));


% estimate moesp model
y_moesp = sim(sys_moesp,ver_dat.u);

y_moesp(:,1) = y_moesp(:,1) + moesp_shift(1);
y_moesp(:,2) = y_moesp(:,2) + moesp_shift(2);
y_moesp(:,3) = y_moesp(:,3) + moesp_shift(3);
y_moesp(:,4) = y_moesp(:,4) + moesp_shift(4);
y_moesp(:,5) = y_moesp(:,5) + moesp_shift(5);
y_moesp(:,6) = y_moesp(:,6) + moesp_shift(6);



[Len dim] = size(u_ver);
X = 1:Len;
t = X.*ts;


h = figure(1);
subplot(6,1,4)
plot(t, y_ver(:,1), 'k-')
hold on
plot(t, y_parsim(:,1), '-', 'Color', gray)
plot(t, y_moesp(:,1), 'k--')
axis([0.5 3 -0.5 0.5])
y1 = ylabel('acc x');
set( gca,...
    'box'         , 'off', ...
    'TickDir'     , 'out'     , ...
    'TickLength'  , [.015 .015] , ...
    'FontName'    , 'AvantGarde', ...
    'FontSize'    , 8, ...
    'xGrid'       , 'on', ...
    'yGrid'       , 'on', ...
    'XColor'      , [.2 .2 .2], ...
    'YColor'      , [.2 .2 .2]);

subplot(6,1,5)
plot(t, y_ver(:,2), 'k-')
hold on
plot(t, y_parsim(:,2), '-', 'Color', gray)
plot(t, y_moesp(:,2), 'k--')
axis([0.5 3 -0.5 1])
y2 = ylabel('acc y');
set( gca,...
    'box'         , 'off', ...
    'TickDir'     , 'out'     , ...
    'TickLength'  , [.015 .015] , ...
    'FontName'    , 'AvantGarde', ...
    'FontSize'    , 8, ...
    'xGrid'       , 'on', ...
    'yGrid'       , 'on', ...
    'XColor'      , [.2 .2 .2], ...
    'YColor'      , [.2 .2 .2]);

subplot(6,1,6)
plot(t, y_ver(:,3), 'k-')
hold on
plot(t, y_parsim(:,3), '-', 'Color', gray)
plot(t, y_moesp(:,3), 'k--')
axis([0.5 3 -1 2])
y3 = ylabel({'acc z'; ' '});
x = xlabel('Time (sec.)');
set( gca,...
    'box'         , 'off', ...
    'TickDir'     , 'out'     , ...
    'TickLength'  , [.015 .015] , ...
    'FontName'    , 'AvantGarde', ...
    'FontSize'    , 8, ...
    'xGrid'       , 'on', ...
    'yGrid'       , 'on', ...
    'XColor'      , [.2 .2 .2], ...
    'YColor'      , [.2 .2 .2]);

subplot(6,1,1)
plot(t, y_ver(:,4), 'k-')
hold on
plot(t, y_parsim(:,4), '-', 'Color', gray)
plot(t, y_moesp(:,4), 'k--')
axis([0.5 3 -1000 9000])
y4 = ylabel('gyro x');
set( gca,...
    'box'         , 'off', ...
    'TickDir'     , 'out'     , ...
    'TickLength'  , [.015 .015] , ...
    'FontName'    , 'AvantGarde', ...
    'FontSize'    , 8, ...
    'xGrid'       , 'on', ...
    'yGrid'       , 'on', ...
    'XColor'      , [.2 .2 .2], ...
    'YColor'      , [.2 .2 .2], ...
    'YTick'       , 0:4000:8000);

subplot(6,1,2)
plot(t, y_ver(:,5), 'k-')
hold on
plot(t, y_parsim(:,5), '-', 'Color', gray)
plot(t, y_moesp(:,5), 'k--')
axis([0.5 3 -1000 10000])
y5 = ylabel('gyro y');
set( gca,...
    'box'         , 'off', ...
    'TickDir'     , 'out'     , ...
    'TickLength'  , [.015 .015] , ...
    'FontName'    , 'AvantGarde', ...
    'FontSize'    , 8, ...
    'xGrid'       , 'on', ...
    'yGrid'       , 'on', ...
    'XColor'      , [.2 .2 .2], ...
    'YColor'      , [.2 .2 .2]);

subplot(6,1,3)
plot(t, y_ver(:,6), 'k-')
hold on
plot(t, y_parsim(:,6), '-', 'Color', gray)
plot(t, y_moesp(:,6), 'k--')
axis([0.5 3 -100 1600])
y6 = ylabel('gyro z');
set( gca,...
    'box'         , 'off', ...
    'TickDir'     , 'out'     , ...
    'TickLength'  , [.015 .015] , ...
    'FontName'    , 'AvantGarde', ...
    'FontSize'    , 8, ...
    'xGrid'       , 'on', ...
    'yGrid'       , 'on', ...
    'XColor'      , [.2 .2 .2], ...
    'YColor'      , [.2 .2 .2]);

set([x, y1, y2, y3, y4, y5, y6], ...
    'FontName'    , 'AvantGarde', ...
    'FontWeight'  , 'bold', ...
    'FontSize'    , 9);

set(gcf,'PaperUnits','inches','PaperPosition',[0 0 6.5 8])
out_file = strcat(fig_dir, fig_name);
print(h, '-depsc2', out_file, '-r100')
close(gcf);