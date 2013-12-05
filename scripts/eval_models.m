clear all
close all
clc

sys_order = 8;
bins = 25;
ts = 1/50;

models = [
'1161'
'1169'
'1265'
'1266'
'1358'
'1359'
'1365'
'1562'
'1563'
'1564'
'1565'
'1656'
'1661'
'1662'
'1663'
'1665'
'1760'
'1761'
'1762'
'1763'
'1860'
'1861'
'1862'
'1863'
'1859'
'1960'
'1962'
'2058'
'2059'
'2060'
'2159'
'2160'
'2257'
'2258'
'2259'
'2357'
'2358'
'2359'
'2360'
'2361'
'2457'
'2458'
'2555'
'2556'
'2557'
'2558'
'2656'];


[Nm nm] = size(models);

for i=1:Nm
    model_path = '/Users/akee/School/UCLA/01 thesis/uclathesis/data/models/20131017212836_63_39500/';
    model_file = strcat('parsim_',num2str(models(i,:)), '_8.mat');
    load(strcat(model_path, model_file))

lam = eig(sys.a);
for j = 1:sys_order
    re = real(lam(j));
    im = imag(lam(j));
    
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


xi = linspace(-1,1,bins);
yi = linspace(-1,1,bins);

xr = interp1(xi,1:numel(xi),x,'nearest');
yr = interp1(yi,1:numel(yi),y,'nearest');

Z = accumarray([yr xr], 1, [bins bins]);



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

    % build iddata object and estimate states
    ver_dat = iddata(y_ver,u_ver,ts);
    x0est = findstates(sys,ver_dat);

    %sim_opt = simOptions('InitialCondition',x0est);

    y_sim = sim(sys,ver_dat.u, 'InitialCondition',x0est);
    %y_sim = sim(sys,ver_dat.u);

    h = figure(1);
    subplot(7,1,1)
    plot(y_ver(:,1), 'b--')
    hold on
    plot(y_sim(:,1), 'g-')
    plot_title = strcat(num2str(models(i,:)), '-IC');
    title(plot_title)

    subplot(7,1,2)
    plot(y_ver(:,2), 'b--')
    hold on
    plot(y_sim(:,2), 'g-')

    subplot(7,1,3)
    plot(y_ver(:,3), 'b--')
    hold on
    plot(y_sim(:,3), 'g-')

    subplot(7,1,4)
    plot(y_ver(:,4), 'b--')
    hold on
    plot(y_sim(:,4), 'g-')

    subplot(7,1,5)
    plot(y_ver(:,5), 'b--')
    hold on
    plot(y_sim(:,5), 'g-')

    subplot(7,1,6)
    plot(y_ver(:,6), 'b--')
    hold on
    plot(y_sim(:,6), 'g-')
    
    subplot(7,1,7)
    imagesc(xi, yi, Z)
    colormap(flipud(gray))
    hold on
    axis([-1.1 1.1 -1.1 1.1])
    axis square
    plot([0 0],[-1.1 1.1], 'k-')
    plot([-1.1 1.1],[0 0], 'k-')
    t = 0:0.001:2*pi;
    plot(sin(t),cos(t), 'k:')
    plot(eig(sys.a), 'r+')
    Xlabel = xlabel('Real');
    Ylabel = ylabel('Imaginary');
    
    fig_dir = '/Users/akee/School/UCLA/01 thesis/uclathesis/fig/model_eval/';
    fig_name = strcat(models(i,:),'_ic.eps');
    set(gcf,'PaperUnits','inches','PaperPosition',[0 0 6.5 8])
    out_file = strcat(fig_dir, fig_name);
    print(h, '-depsc2', out_file, '-r100')
    close(gcf);

end