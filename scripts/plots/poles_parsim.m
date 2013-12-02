% Poles

clear all
close all
clc

% Load model
load('/Users/akee/School/UCLA/01 thesis/uclathesis/data/models/20131017212836_63_39500/parsim-e_50_8.mat');

ts = 1/50;
fig_dir = '/Users/akee/School/UCLA/01 thesis/uclathesis/fig/';
fig_name = 'poles_parsim.eps';

% set initial condition
sys.ts = 1/50;

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
    'xTick'       , [-1:.5:1], ...
    'yTick'       , [-1:.5:1], ...
    'XColor'      , [.2 .2 .2], ...
    'YColor'      , [.2 .2 .2]);

set([Xlabel, Ylabel], ...
    'FontName'    , 'AvantGarde', ...
    'FontWeight'  , 'bold', ...
    'FontSize'    , 9);


set(gcf,'PaperUnits','inches','PaperPosition',[0 0 6.5 4])
out_file = strcat(fig_dir, fig_name);
print(h, '-depsc2', out_file, '-r100')
close(gcf);