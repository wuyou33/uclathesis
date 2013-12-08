clear all
close all
clc

ts = 1/50;

% Load model
load('/Users/akee/School/UCLA/01 thesis/uclathesis/data/models/20131017212836_63_39500/parsim-e_50_8.mat');

load('/Users/akee/School/UCLA/01 thesis/uclathesis/data/flight_test/20131017212626_31_38500/20131017212626.mat');

% set initial condition
sys.ts = 1/50;

data = iddata(y,u,ts);

pe(sys,data)
