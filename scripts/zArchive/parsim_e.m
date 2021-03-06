function [a,d,b,k,HLd,HLs]=parsim_e(Y,U,L,g,J,n)
tic;
% [A,C,B,K]=parsim_e(Y,U,L,g,J,n)
%Purpose
% Implementation of the PARSIM-E algorithm
% On input
% Y,U -The output and input data matrices
% L - Prediction horizon for the states
% g - g=0 for closed loop systems
% J - Past horizon so that (A-KD)^J small
% n - System order
if nargin == 5; n = 1; end
if nargin == 4; n = 1; J = L; end
if nargin == 3; n = 1; J = L; g = 0; end
if nargin == 2; n = 1; J = 1; g = 0; L=1; end
[Ny,ny] = size(Y);
if isempty(U)==1; U=zeros(Ny,1); end
[Nu,nu] = size(U);
N = min(Ny,Nu);
K = N - L - J;
% 1. %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if nargin < 6
disp('Ordering the given input output data')
end
YL = zeros((L+J+1)*ny,K);
UL = zeros((L+J+g)*nu,K);
for i=1:L+J+1
YL(1+(i-1)*ny:i*ny,:) = Y(i:K+i-1,:)';
end
for i=1:L+J+g
UL(1+(i-1)*nu:i*nu,:) = U(i:K+i-1,:)';
end
%
Yf=YL(J*ny+1:(J+L+1)*ny,:);
Uf=UL(J*nu+1:(J+L+g)*nu,:);
%
Up=UL(1:J*nu,:);
Yp=YL(1:J*ny,:);
Wp=[Up;Yp];
% general case, PARSIM-E algorithm
Uf_J=[]; Ef_J=[]; OCds=[];
for i=1:L+1
    fprintf('Step %5g\n', i)
Wf=[Uf_J;Wp;Ef_J];
y_Ji=YL((J+i-1)*ny+1:(J+i)*ny,:);
Hi=y_Ji*Wf'*pinv(Wf*Wf');
Zd=Hi*Wf;
e_Ji=y_Ji-Zd;
Ef_J=[Ef_J;e_Ji];
OCds=[OCds; ...
Hi(:,(i-1)*nu+1:(i-1)*nu+J*nu+J*ny)];
if i < L+1
Uf_J=UL(J*nu+1:(J+i)*nu,:);
end
end
% Compute A and D/C
[U,S,V]=svd(OCds);
U1=U(:,1:n); S1=S(1:n,1:n);
OL=U1(1:L*ny,:);
OLA=U1(ny+1:(L+1)*ny,:);
a=pinv(OL)*OLA;
d=U1(1:ny,:);
% Markov parameters
HLd=Hi(:,1:L*nu);
HLs=Hi(:,L*nu+J*nu+J*ny+1:end);
% Form OL*B matrix from impulse responses in Hi
ni=(L-1)*nu;
for i=1:L
%ni+1,2*ni
OLB((i-1)*ny+1:i*ny,1:nu)=Hi(:,ni+1:ni+nu);
ni=ni-nu;
end
b=pinv(U1(1:L*ny,:))*OLB;
% Form OL*C matrix from impulse responses in Hi
Hs=Hi(:,L*nu+J*nu+J*ny+1:end);
ni=(L-1)*ny;
for i=1:L
OLC((i-1)*ny+1:i*ny,1:ny)=Hs(:,ni+1:ni+ny);
ni=ni-ny;
end
k=pinv(U1(1:L*ny,:))*OLC;
% END PARSIM_E
toc
