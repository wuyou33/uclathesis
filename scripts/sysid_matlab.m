clear all
close all
clc

Ts = 1/50;
n = 3;

% Load data
[file, path] = uigetfile('*.mat','Select input-output data file', '/Users/akee/School/UCLA/01 thesis/uclathesis/data/');
load(strcat(path, file));

data = iddata(y,u,Ts);

sys = n4sid(data,n,'N4Weight','MOESP');

[out_file, out_path] = uiputfile('*.mat','Save Model As', '/Users/akee/School/UCLA/01 thesis/uclathesis/data/');
% Save results to .mat file
test_data = strcat(path, file);
sys_order = n;
save(strcat(out_path, out_file), 'sys', 'sys_order', 'test_data')