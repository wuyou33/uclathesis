clear all
close all
clc

ts = 1/50;

model = '1760';
shift = [-0.6 0.3 1.45 1650 0 -210];
front_trim = 1;

fig_dir = '/Users/akee/School/UCLA/01 thesis/uclathesis/fig/';
fig_name = 'sim_1760_pitch.eps';

% Load model
model_path = '/Users/akee/School/UCLA/01 thesis/uclathesis/data/models/20131017212836_63_39500/';
model_file = strcat('parsim_',model, '_8.mat');
load(strcat(model_path, model_file))

% set initial condition
sys.ts = 1/50;


% Load verification data
ver_path = '/Users/akee/School/UCLA/01 thesis/uclathesis/data/verification/';
ver_file = '20131126163250_pitch_41000/20131126163250_pitch_41000.mat';
load(strcat(ver_path, ver_file));
u_ver = u;
y_ver = y;
clear u y

% build iddata object and estimate states
ver_dat = iddata(y_ver,u_ver,ts);
x0est = findstates(sys,ver_dat);

y_sim = sim(sys,ver_dat.u);
%y_sim = sim(sys,ver_dat.u, 'InitialCondition',x0est);

y_sim(:,1) = y_sim(:,1) + shift(1);
y_sim(:,2) = y_sim(:,2) + shift(2);
y_sim(:,3) = y_sim(:,3) + shift(3);
y_sim(:,4) = y_sim(:,4) + shift(4);

y_sim(:,6) = y_sim(:,6) + shift(6);

y_sim(:,5) = detrend(y_sim(:,5), 'linear', 90);
y_sim(:,5) = y_sim(:,5) + shift(5);

y_ver(:,6) = detrend(y_ver(:,6), 'linear', 80);

[Len dim] = size(u_ver);
X = 1:Len;
t = X.*ts;
t = t';

y_sim = [t y_sim];
y_ver = [t y_ver];

x0 = [0 0 0; 0 0 0; 0 0 0];
ver_out = find_position(y_ver,x0);  %[phi theta psi; u v w; x y z]
sim_out = find_position(y_sim,x0);  %[phi theta psi; u v w; x y z]

% build euler angle matrices
phi_ver = [];
theta_ver = [];
psi_ver = [];
phi_sim = [];
theta_sim = [];
psi_sim = [];

for i=1:size(ver_out,3)
    phi_ver = [phi_ver ver_out(1,1,i)];
    theta_ver = [theta_ver ver_out(1,2,i)];
    psi_ver = [psi_ver ver_out(1,3,i)];
    phi_sim = [phi_sim sim_out(1,1,i)];
    theta_sim = [theta_sim sim_out(1,2,i)];
    psi_sim = [psi_sim sim_out(1,3,i)];
end

close all

subplot(3,1,1)
plot(phi_ver, 'k-')
hold on
plot(phi_sim, 'k--')
subplot(3,1,2)
plot(theta_ver, 'k-')
hold on
plot(theta_sim, 'k--')
subplot(3,1,3)
plot(psi_ver, 'k-')
hold on
plot(psi_sim, 'k--')




%set(gcf,'PaperUnits','inches','PaperPosition',[0 0 6.5 8])
%out_file = strcat(fig_dir, fig_name);
%print(h, '-depsc2', out_file, '-r100')
%close(gcf);