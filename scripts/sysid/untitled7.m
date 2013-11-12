clear all
close all
clc

load ../../data/flight_test_data/20131017212836.mat;
max_order = 10;

% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -    
    
    
    
%  Turn the data into row vectors
[ydim,ylen]=size(y); if (ydim > ylen); y = y'; [ydim,ylen]=size(y); end
[udim,ulen]=size(u); if (udim > ulen); u = u'; [udim,ulen]=size(u); end

%  Determine the number of rows and columns in the Hankel matrices
    % input
Ui = round(2 * (max_order/udim));
Uj = ylen-2*Ui+1;
    % output
Yj = Uj;
Yi = (ylen-Yj+1)/2;

%  Quick validation checks on the experimental data
if (ulen < 0); error('Need a non-empty input vector'); end
if (ulen ~= ylen); error('Number of data points different in input and output'); end
%if ((ylen-2*i+1) < (2*ydim*i)); error('Not enough data points'); end

Y = block_hankel(y/sqrt(Yj),2*Yi,Yj); 	% Output block Hankel
U = block_hankel(u/sqrt(Uj),2*Ui,Uj); 	% Output block Hankel

% Split U and Y into "past" and "future" components
Up_rows = (udim*Ui);
Uf_rows = Up_rows;
Yp_rows = (ydim*Yi);
Yf_rows = Yp_rows;

Up = U(1:Up_rows , :);
Uf = U(Up_rows+1:end , :);
Yp = Y(1:Up_rows , :);
Yf = Y(Up_rows+1:end , :);

IO = [Uf; Up; Y];

km=Ui*udim;
kp=Yi*ydim;

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
subplot(2,1,1)
semilogy(sv, 'k.')
subplot(2,1,2)
plot(sv, 'k.')
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
A = pinv(Ok(1:ydim*(Yi-1),1:n))*Ok(ydim+1:Yi*ydim,1:n);

% Matrices B and D
U2 = UU(:,n+1:size(UU',1));
Z = U2'*[L31 L32 L41]/[L21 L22 L11];
XX = []; 
RR = [];
for j = 1:Yi
    XX = [XX; Z(:,udim*(j-1)+1:udim*j)];
    Okj = Ok(1:ydim*(Yi-j),:);
    Rj = [zeros(ydim*(j-1),ydim) zeros(ydim*(j-1),n);
        eye(ydim) zeros(ydim,n); zeros(ydim*(Yi-j),ydim) Okj]; 
    RR = [RR; U2'*Rj];
end
DB = pinv(RR)*XX;
D = DB(1:ydim,:);
B = DB(ydim+1:size(DB,1),:);

Ts = 1/50;
sys = ss(A,B,C,D,Ts);
figure(1)
impulse(sys)

figure(2)
pzmap(sys)