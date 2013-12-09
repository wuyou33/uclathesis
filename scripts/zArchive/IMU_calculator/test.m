clear all
close all
clc

load('sample inputs.mat')

phi = 0.0;
theta =0.218893;
psi=0.0;

u=35.156;
v =-0.79;
w=7.598;

X =0.0;
Y=0.0;
Z=609.6;

x0 = [phi theta psi; u v w; X Y Z];

output=find_position(data,initial)