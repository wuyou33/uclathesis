clear all
close all
clc


%   Consider a multivariable fourth order system a,b,c,d
%   with two inputs and two outputs:
    a = [0.603 0.603 0 0;-0.603 0.603 0 0;0 0 -0.603 -0.603;0 0 0.603 -0.603];
    b = [1.1650,-0.6965;0.6268 1.6961;0.0751,0.0591;0.3516 1.7971];
    c = [0.2641,-1.4462,1.2460,0.5774;0.8717,-0.7012,-0.6390,-0.3600];
    d = [0];

%   We take a white noise sequence of 1000 points as input u.
    len = 1000;
    u = randn(len,2);

%   With noise added, the state space system equations become:
%                  x_{k+1) = A x_k + B u_k + K e_k        
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
    
    
    
%           y: matrix of measured outputs
%           u: matrix of measured inputs 
%              for stochastic systems, u = []
%           i: number of block rows in Hankel matrices
%              (i * #outputs) is the max. order that can be estimated 
%              Typically: i = 2 * (max order)/(#outputs)

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

%  Generate block Hankel matrices for the input and output data
Y = block_hankel(y/sqrt(j),2*i,j); 	% Output block Hankel
U = block_hankel(u/sqrt(j),2*i,j); 	% Output block Hankel


%  Compute the column space of the extended observability matrix
T_hat = Y*U'*inv(U*U');
Obs_col_space = Y - T_hat*U;


%  Compute the SVD
[U,S,V] = svd(Obs_col_space);

%  Determine the system order from its singular values and partition the
%  SVD
sv = diag(S);       % singular values

figure(gcf)
semilogy(sv, 'k.')
title('Singular Values'); xlabel('Order');
n = input('      System order ? ');

U1 = U(:,1:n);          % Determine U1
S1 = S(1:n, 1:n);       % Determine S1
V1 = V(:,1:n);


%  Calculate A and C (this is solving the equation on p. 299 of the book)
Os = U1;
C = Os(1:ydim,:);
A = Os(1:ydim*(i-1),:)\Os(ydim+1:i*ydim,:);

%  Calculate B and D
CN = S1*V1';
B = CN(:,1:udim);


