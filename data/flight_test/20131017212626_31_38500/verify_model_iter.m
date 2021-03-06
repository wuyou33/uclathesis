clear all
close all
clc

L_min = 15;
L_max = 18;
J_min = 66;
J_max = 70;


sys_order = 8;
bins = 45;

for L = 10:1:45
    for J = 50:1:70
        
    model_path = '/Users/akee/School/UCLA/01 thesis/uclathesis/data/models/20131017212836_63_39500/';
    model_file = strcat('parsim_',num2str(L), num2str(J), '_8.mat');
    load(strcat(model_path, model_file))
       

    fig_dir = '/Users/akee/School/UCLA/01 thesis/uclathesis/fig/';
    fig_name = 'poles_parsim_all.eps';

lam = eig(sys.a);
for i = 1:sys_order
    re = real(lam(i));
    im = imag(lam(i));
    
    if exist('x','var')
        x=[x; re];
    else
        x = re;
    end
        
    if exist('y','var')
        y=[y; im];
    else
        y = im;
    end
end

    end
end


xi = linspace(-1,1,bins);
yi = linspace(-1,1,bins);

xr = interp1(xi,1:numel(xi),x,'nearest');
yr = interp1(yi,1:numel(yi),y,'nearest');

Z = accumarray([yr xr], 1, [bins bins]);



ts = 1/50;

for L = L_min:1:L_max
    for J = J_min:1:J_max
        
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

    h = figure(1);
    set(h, 'Position', [200 100 800 900])
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
    
    
%     g = figure(2);
%     set(g, 'Position', [1050 600 500 500])
%     imagesc(xi, yi, Z)
%     colormap(flipud(gray))
%     hold on
%     axis([-1.1 1.1 -1.1 1.1])
%     axis square
%     plot([0 0],[-1.1 1.1], 'k-')
%     plot([-1.1 1.1],[0 0], 'k-')
%     t = 0:0.001:2*pi;
%     plot(sin(t),cos(t), 'k:')
%     plot(eig(sys.a), 'r+')
%     Xlabel = xlabel('Real');
%     Ylabel = ylabel('Imaginary');
    
    waitfor(h)
%     clf(g)
    end
end

%close all
