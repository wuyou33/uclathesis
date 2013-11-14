clear all
close all
clc

load ../../data/flight_test_data/20131017212836.mat;

% [A,C,B,K]=parsim_e(Y,U,L,g,J,n)
%Purpose
% Implementation of the PARSIM-E algorithm
% On input
% Y,U -The output and input data matrices
% L - Prediction horizon for the states
% g - g=0 for closed loop systems
% J - Past horizon so that (A-KD)^J small
% n - System order
L = 200;
J = 1;
[A,C,B,K] = parsim_e(y,u,L,0,J,5);
D = 0;

Ts = 1/50;
sys = ss(A,B,C,D,Ts);
figure(1)
impulse(sys)

figure(2)
pzmap(sys)