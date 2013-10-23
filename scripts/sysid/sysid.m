clear all
close all
clc

load ../../data/flight_test_data/20131017212836.mat
i = 12;


[l, ny] = size(y);
if (ny < l); y = y'; [l, ny] = size(y); end
    
[m, nu] = size(u);
if (nu < m); u = u'; [m, nu] = size(u); end

j = ny - i + 1;

Y = block_hankel(y,i,j);
U = block_hankel(u,i,j)
