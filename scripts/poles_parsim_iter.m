% Poles

clear all
close all
clc

sys_order = 8;
bins = 45;

ch = CubeHelix(256,0.5,-1.5,1.2,1.0);

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

h = figure(1);
imagesc(xi, yi, Z)
%contourf(Z)
colormap(flipud(ch))
hold on
axis([-1.1 1.1 -1.1 1.1])
axis square
plot([0 0],[-1.1 1.1], 'k-')
plot([-1.1 1.1],[0 0], 'k-')
t = 0:0.001:2*pi;
plot(sin(t),cos(t), 'k:')
Xlabel = xlabel('Real');
Ylabel = ylabel('Imaginary');


set( gca,...
    'box'         , 'on', ...
    'TickDir'     , 'out'     , ...
    'TickLength'  , [.015 .015] , ...
    'FontName'    , 'AvantGarde', ...
    'FontSize'    , 9, ...
    'xTick'       , [-1:.5:1], ...
    'yTick'       , [-1:.5:1], ...
    'XColor'      , [.2 .2 .2], ...
    'YColor'      , [.2 .2 .2]);

set([Xlabel, Ylabel], ...
    'FontName'    , 'AvantGarde', ...
    'FontWeight'  , 'bold', ...
    'FontSize'    , 9);


%figure(2)
%surf(Z)
%colormap(flipud(ch))



set(gcf,'PaperUnits','inches','PaperPosition',[0 0 6.5 4])
out_file = strcat(fig_dir, fig_name);
print(h, '-depsc2', out_file, '-r100')
close(gcf);