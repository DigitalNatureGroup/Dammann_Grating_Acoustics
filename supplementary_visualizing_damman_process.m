clear all
close all
clc

addpath('codes\')
rng default % For reproducibility
%% Simulation Settings
p_0 = 1; %
f0 = 40e03; % Hz
c0 = 346; % m/s

lambda = c0/f0;
k = 2*pi*f0/c0;
a = 5e-03; % Transducer Radius
trans_q = [0,0,1];

% Transducer
tr_spacing = 2e-03;

% min_t = -0.078749985;
% max_t = 0.078749985;
min_t = -0.08;
max_t = 0.08;
tx = min_t:tr_spacing:max_t;
ty = min_t:tr_spacing:max_t;
[Trans_x, Trans_y] = meshgrid(tx, ty);
Trans_x = Trans_x(:);
Trans_y = Trans_y(:);
Trans_z = 0.*Trans_y;

damman_x= linspace(0,0.5,100);
damman_x(1) = [];
damman_x(end) = [];

damman_y= linspace(0,0.5,100);
damman_y(1) = [];
damman_y(end) = [];

focal_point = [0,0,0.1];

damman_x_k = [0 0.1 0.2 0.5];
g_x =damman_grating(damman_x, damman_x_k);
plot(damman_x, g_x,'k','LineWidth',2)
set(gca,'FontSize',24)
grid on
grid minor
xlim([0 0.55])
xticks([0, 0.1, 0.2 0.3 0.4 0.5])
yticks([-1 0 1])
ylim([-1.1 1.1])
exportgraphics(gca,'manuscript_figure\damman_1d.png')


g_x = [fliplr(g_x), g_x];
Gx = repmat(g_x, length(g_x), 1);
x = [-fliplr(damman_x) damman_x];
plot(x, g_x,'k','LineWidth',2)
set(gca,'FontSize',24)
grid on
grid minor
xlim([-0.55 0.55])
xticks([-0.5 0 0.5])
yticks([-1 0 1])
ylim([-1.1 1.1])
exportgraphics(gca,'manuscript_figure\damman_1d_mirror.png')
% 
damman_y_k = damman_x_k;
[damman_mask, combined_2d] = generate_damman(damman_x, damman_x_k,damman_y, damman_y_k, Trans_x, Trans_y);
pcolor(combined_2d)
return
% phase_mask = zeros(size(damman_mask));
% phase_mask(damman_mask==1) = pi;
% phase_mask(damman_mask==-1) = 0;
% 
