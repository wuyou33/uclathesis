clear all
close all
clc

ts = 1/50;

for L = 10:1:11
    for J = 50:1:55
        
    model_path = '/Users/akee/School/UCLA/01 thesis/uclathesis/data/models/20131017212836_63_39500/';
    model_file = strcat('parsim_',num2str(L), num2str(J), '_8.mat');
    load(strcat(model_path, model_file))

    % set initial condition
    sys.ts = 1/50;


    % Load verification data
    load('/Users/akee/School/UCLA/01 thesis/uclathesis/data/flight_test/20131017212626_31_38500/20131017212626.mat');
    u_ver = u;
    y_ver = y;
    clear u y

    % build iddata object and estimate states
    ver_dat = iddata(y_ver,u_ver,ts);
    %x0est = findstates(sys,ver_dat);

    %sim_opt = simOptions('InitialCondition',x0est);

    %y_sim = sim(sys,ver_dat.u, 'InitialCondition',x0est);
    y_sim = sim(sys,ver_dat.u);

    %[pitch_ver, roll_ver, yaw_ver] = complimentary_filter(y_ver);
    %[pitch_sim, roll_sim, yaw_sim] = complimentary_filter(y_sim);

    %y_sim(:,1) = y_sim(:,1) + .02;
    %y_sim(:,2) = y_sim(:,2) + 1;
    %y_sim(:,3) = y_sim(:,3) + 1.25;


    % figure(1)
    % subplot(3,1,1)
    % plot(pitch_sim, 'b-')
    % hold on
    % plot(pitch_ver, 'b--')
    % 
    % subplot(3,1,2)
    % plot(roll_sim, 'b-')
    % hold on
    % plot(roll_ver, 'b--')
    % 
    % subplot(3,1,3)
    % plot(yaw_sim, 'b-')
    % hold on
    % plot(yaw_ver, 'b--')




    h = figure(2);
    set(h, 'Position', [500 0 800 900])
    subplot(6,1,1)
    plot(y_ver(:,1), 'b--')
    hold on
    plot(y_sim(:,1), 'g-')
    plot_title = strcat(num2str(L), num2str(J));
    title(plot_title)

    subplot(6,1,2)
    plot(y_ver(:,2), 'b--')
    hold on
    plot(y_sim(:,2), 'g-')

    subplot(6,1,3)
    plot(y_ver(:,3), 'b--')
    hold on
    plot(y_sim(:,3), 'g-')

    subplot(6,1,4)
    plot(y_ver(:,4), 'b--')
    hold on
    plot(y_sim(:,4), 'g-')

    subplot(6,1,5)
    plot(y_ver(:,5), 'b--')
    hold on
    plot(y_sim(:,5), 'g-')

    subplot(6,1,6)
    plot(y_ver(:,6), 'b--')
    hold on
    plot(y_sim(:,6), 'g-')
    
    waitfor(h)
    end
end
