clear all
close all
clc

max_order = 10;


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

    
% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -    
    
    
    
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
Up_rows = (udim*i);
Uf_rows = Up_rows;
Yp_rows = (ydim*i);
Yf_rows = Yp_rows;

Up = U(1:Up_rows , :);
Uf = U(Up_rows+1:end , :);
Yp = Y(1:Up_rows , :);
Yf = Y(Up_rows+1:end , :);

IO = [Uf; Up; Y];

km=i*udim;
kp=i*ydim;

% LQ decomposition
L = triu(qr(IO'))';
L11 = L(1:km,1:km);
L21 = L(km+1:2*km,1:km);
L22 = L(km+1:2*km,km+1:2*km);
L31 = L(2*km+1:2*km+kp,1:km);
L32 = L(2*km+1:2*km+kp,km+1:2*km);
L41 = L(2*km+kp+1:2*km+2*kp,1:km);
L42 = L(2*km+kp+1:2*km+2*kp,km+1:2*km);
L43 = L(2*km+kp+1:2*km+2*kp,2*km+1:2*km+kp); 

[UU,SS,VV]=svd([L42 L43]);

% Prompt to setermine the system order
sv = diag(SS);       % singular values
figure(1)
semilogy(sv, 'k.')
title('Singular Values'); xlabel('Order');
n = input('      System order ? ');
close(gcf)

% Reduce model order
U1 = UU(:,1:n);          % Determine U1
S1 = SS(1:n, 1:n);       % Determine S1
V1 = VV(:,1:n);

Ok = U1*sqrtm(S1);

% Matrices C and A
C = Ok(1:ydim,1:n);
A = pinv(Ok(1:ydim*(i-1),1:n))*Ok(ydim+1:i*ydim,1:n);

% Matrices B and D
U2 = UU(:,n+1:size(UU',1));
Z = U2'*[L31 L32 L41]/[L21 L22 L11];
XX = []; 
RR = [];
for j = 1:i
    XX = [XX; Z(:,udim*(j-1)+1:udim*j)];
    Okj = Ok(1:ydim*(i-j),:);
    Rj = [zeros(ydim*(j-1),ydim) zeros(ydim*(j-1),n);
        eye(ydim) zeros(ydim,n); zeros(ydim*(i-j),ydim) Okj]; 
    RR = [RR; U2'*Rj];
end
DB = pinv(RR)*XX;
D = DB(1:ydim,:);
B = DB(ydim+1:size(DB,1),:);

sys_orig = ss(a,b,c,d,-1);
sys_est = ss(A,B,C,D,-1);

figure(1)
impulse(sys_orig)

figure(2)
impulse(sys_est)

