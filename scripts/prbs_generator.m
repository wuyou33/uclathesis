clear all
close all
clc

signal_length   = 127;
num_signals     = 3; % Number of signals to generate
min             = -1;
max             = 1;


N      = [signal_length num_signals];
type   = 'prbs';
band   = [0 1];
levels = [min, max];


r = idinput(N, type, band, levels);
csvwrite('../data/prbs_sequences/prbs_inputs_127.csv',r)