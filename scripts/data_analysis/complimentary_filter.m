function [pitch, roll, yaw] = complimentary_filter(y)

alpha = 0.1;
dt = 1/50;



% Load verification data
%[ver_file,ver_path] = uigetfile('*.mat','Select verification data', '/Users/akee/School/UCLA/01 thesis/uclathesis/data/');
%load(strcat(ver_path, ver_file));

d2x = y(:,1);
d2y = y(:,2);
d2z = y(:,3);
p = y(:,4);
q = y(:,5);
r = y(:,6);


% Direct computation of accelerometer angles
pitch_acc = atan2(d2x,sqrt(d2x.^2 + d2z.^2)) * 180/pi;
roll_acc = atan2(d2y,sqrt(d2x.^2 + d2z.^2)) * 180/pi;
yaw_acc = atan2(sqrt(d2x.^2 + d2y.^2), d2z) * 180/pi;


% Numerically integrate to get gyro angles
[len, n] = size(y);
pitch_gyro(1) = 0;
roll_gyro(1) = 0;
yaw_gyro(1) = 0;

for i=2:len
    pitch_gyro(i) = pitch_gyro(i-1)+(q(i)*dt);
    roll_gyro(i) = roll_gyro(i-1)+(p(i)*dt);
    yaw_gyro(i) = yaw_gyro(i-1)+(r(i)*dt);
end

pitch_gyro = pitch_gyro';
roll_gyro = roll_gyro';
yaw_gyro = yaw_gyro';


% complimentary filter
pitch = (1-alpha).*pitch_gyro + alpha.*pitch_acc;
roll = (1-alpha).*roll_gyro + alpha.*roll_acc;
yaw = (1-alpha).*yaw_gyro + alpha.*yaw_acc;

% subplot(3,1,1)
% plot(pitch_gyro, 'g--')
% hold on
% plot(pitch)
% ylabel('pitch')
% 
% subplot(3,1,2)
% plot(roll_gyro, 'g--')
% hold on
% plot(roll)
% ylabel('roll')
% 
% subplot(3,1,3)
% plot(yaw_gyro, 'g--')
% hold on
% plot(yaw)
% ylabel('yaw')

end
