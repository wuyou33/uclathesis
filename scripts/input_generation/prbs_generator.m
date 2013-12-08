clear all
close all
clc

signal_length   = 63;
num_signals     = 3; % Number of signals to generate
min             = -1;
max             = 1;


N      = [signal_length num_signals];
type   = 'prbs';
band   = [0 1];
levels = [min, max];


r = idinput(N, type, band, levels);
csvwrite('prbs_inputs_63.csv',r)