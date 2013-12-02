% Singular values

clear all
close all
clc

ts = 1/50;
fig_dir = '/Users/akee/School/UCLA/01 thesis/uclathesis/fig/';
fig_name = 'singular_values_parsim.eps';

% set initial condition
sys.ts = 1/50;


% Singular Values
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

set(gcf,'PaperUnits','inches','PaperPosition',[0 0 6.5 2.5])
out_file = strcat(fig_dir, fig_name);
print(h, '-depsc2', out_file, '-r100')
close(gcf);