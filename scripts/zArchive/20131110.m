clear all
close all
clc

%   with two inputs and two outputs:
    a = [0.603 0.603 0 0;-0.603 0.603 0 0;0 0 -0.603 -0.603;0 0 0.603 -0.603];
    b = [1.1650,-0.6965;0.6268 1.6961;0.0751,0.0591;0.3516 1.7971];
    c = [0.2641,-1.4462,1.2460,0.5774;0.8717,-0.7012,-0.6390,-0.3600];
    d = [0];

%   We take a white noise sequence of 1000 points as input u.
    len = 2000;
    u = randn(len,2);

%   With noise added, the state space system4 equations become:
%                  x_(k+1) = A x_k + B u_k + K e_k        
%                    y_k   = C x_k + D u_k + e_k
%                 cov(e_k) = R
%                 
    k = [0.1242,-0.0895;-0.0828,-0.0128;0.0390,-0.0968;-0.0225,0.1459]*4;
    r = [0.0176,-0.0267;-0.0267,0.0497];

%   The noise input thus is equal to (the extra chol(r) makes cov(e) = r):
    e = randn(len,2)*chol(r);
% 
%   And the simulated noisy output:
    y = dlsim(a,b,c,d,u) + dlsim(a,k,c,eye(2),e);

%u = [1:0.02:2];
%y = [5:0.02:6];

max_order = 10;

%  Turn the data into row vectors
[ydim,ylen]=size(y); if (ydim > ylen); y = y'; [ydim,ylen]=size(y); end
[udim,ulen]=size(u); if (udim > ulen); u = u'; [udim,ulen]=size(u); end

%  Determine the number of rows and columns in the Hankel matrices
i = 2 * (max_order/ydim);       % Number of block rows in hankel matrices
j = ylen-2*i+1;                 % Columns

%  Quick validation checks on the experimental data
if (ulen < 0); error('Need a non-empty input vector'); end
if (ulen ~= ylen); error('Number of data points different in input and output'); end
if ((ylen-2*i+1) < (2*ydim*i)); error('Not enough data points'); end

Y = block_hankel(y/sqrt(j),2*i,j); 	% Output block Hankel
U = block_hankel(u/sqrt(j),2*i,j); 	% Output block Hankel

% Split U and Y into "past" and "future" components
Up_rows = (udim*i)/2;
Uf_rows = Up_rows;
Yp_rows = (ydim*i)/2;
Yf_rows = Yp_rows;

Up = U(1:Up_rows , :);
Uf = U(Up_rows+1:udim*i , :);
Yp = Y(1:Up_rows , :);
Yf = Y(Up_rows+1:udim*i , :);

Zp = [Up; Yp];


% Compute orthogonal projections
PI_Uf = eye(1981) - Uf'*inv(Uf*Uf')*Uf;
Obs = Yf*PI_Uf*Zp';

[U,S,V] = svd(Obs);

% Prompt to setermine the system order
sv = diag(S);       % singular values
figure(1)
semilogy(sv, 'k.')
title('Singular Values'); xlabel('Order');
n = input('      System order ? ');
close(gcf)

% Reduce model order
U1 = U(:,1:n);          % Determine U1
S1 = S(1:n, 1:n);       % Determine S1
V1 = V(:,1:n);

Obs = U1;
Obs_over = Obs(1:end-1 , :);
Obs_under = Obs(2:end , :);

% Extract C and A
C = Obs(1:ydim,:);
A = Obs_under\Obs_over;