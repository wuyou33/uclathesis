clear all
close all
clc

sys_order = 8;
bins = 25;
ts = 1/50;

models = [
'1358'
'1359'
'1562'
'1760'
'1761'
'1762'
'1860'
'1861'
'1862'
'1962'
'2059'
'2060'
'2159'
'2160'
'2258'
'2259'
'2357'
'2358'
'2360'
'2557'];


[Nm nm] = size(models);
err_table = zeros(Nm, 7);


for i=1:Nm
    model_path = '/Users/akee/School/UCLA/01 thesis/uclathesis/data/models/20131017212836_63_39500/';
    model_file = strcat('parsim_',num2str(models(i,:)), '_8.mat');
    load(strcat(model_path, model_file))

    % set initial condition
    sys.ts = 1/50;


    % Load verification data
    load('/Users/akee/School/UCLA/01 thesis/uclathesis/data/flight_test/20131017212626_31_38500/20131017212626.mat');
    u_ver = u;
    y_ver = y;
    clear u y

    % build iddata object and calculate one step prediction error
    ver_dat = iddata(y_ver,u_ver,ts);
    err = pe(sys,ver_dat);
    
    x = 1:160;
    lin_1 = polyfit(x,err.y(:,1)',1);
    lin_2 = polyfit(x,err.y(:,2)',1);
    lin_3 = polyfit(x,err.y(:,3)',1);
    lin_4 = polyfit(x,err.y(:,4)',1);
    lin_5 = polyfit(x,err.y(:,5)',1);
    lin_6 = polyfit(x,err.y(:,6)',1);
    
    err_table(i,1) = models(i);
    err_table(i,2) = lin_1(1);
    err_table(i,3) = lin_2(1);
    err_table(i,4) = lin_3(1);
    err_table(i,5) = lin_4(1);
    err_table(i,6) = lin_5(1);
    err_table(i,7) = lin_6(1);

    h = figure(1);
    set(h, 'Position', [200 100 800 900]);
    subplot(6,1,1)
    plot(err.y(:,1), 'b-')
    plot_title = strcat(num2str(models(i,:)));
    title(plot_title)

    subplot(6,1,2)
    plot(err.y(:,2), 'b-')

    subplot(6,1,3)
    plot(err.y(:,3), 'b-')

    subplot(6,1,4)
    plot(err.y(:,4), 'b-')

    subplot(6,1,5)
    plot(err.y(:,5), 'b-')

    subplot(6,1,6)
    plot(err.y(:,6), 'b-')
    

    waitfor(h)

end