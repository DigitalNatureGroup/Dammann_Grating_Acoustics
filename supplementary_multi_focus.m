clear all
close all
clc

%% Create optimized focal spot using IBP algorithm first. 

addpath('codes\')
rng default % For reproducibility
%% Simulation Settings
voltage = 20;
p_0 = (0.221)*voltage;
f0 = 40e03; % Hz
c0 = 346; % m/s

lambda = c0/f0;
k = 2*pi*f0/c0;
a = 4.5e-03; % Transducer Radius
trans_q = [0,0,1];

% Transducer
tr_spacing = 2e-03;
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

xx = min(Trans_y):lambda/15:max(Trans_y);
yy = min(Trans_y):lambda/15:max(Trans_y);
[XX, YY]=ndgrid(xx,yy);

load('transfer2pat.mat')
store_3db_range = zeros(length(best_comb_trap), 1);
local_peak = zeros(length(best_comb_trap), 1);
nan_coordinates = [];

phase_store = zeros(length(best_comb_trap), length(Trans_x));

trap_translate = [-5*lambda, -2.5*lambda, 0.0];
ii =1;

pre_calc = pre_pressure_calc_2d_pat_nofocus(XX, YY, Trans_x, Trans_y, Trans_z, p_0, k, trans_q, a, 0.1);

damman_x_k = [0 best_comb_trap(ii,1) best_comb_trap(ii,2)];
damman_y_k = damman_x_k;
[damman_mask, combined_2d] = generate_damman(damman_x, damman_x_k,damman_y, damman_y_k, Trans_x, Trans_y);



%     return
phase_mask = zeros(size(damman_mask));
phase_mask(damman_mask==1) = pi;
phase_mask(damman_mask==-1) = 0;
phase_store(ii, :) = phase_mask;

ibp_phase = struct2array(load('ibp_phase_singlefocus.mat'));
p1 = pressure_calc_2d(pre_calc,phase_mask + ibp_phase);

figure_handle = figure;
screen_size = get(0, 'ScreenSize');
square_size = 1200; % Define the size of the square window in pixels
position = [(screen_size(3) - square_size) / 2, (screen_size(4) - square_size) / 2, square_size, square_size];
set(figure_handle, 'Position', position);
pcolor(XX, YY, abs(p1))
colormap hot
shading interp
colorbar
set(gca,'FontSize',24)
axis equal
exportgraphics(gca, ['manuscript_figure\single_focus_IBP.png'])


p1 = pressure_calc_2d(pre_calc,ibp_phase);

figure_handle = figure;
screen_size = get(0, 'ScreenSize');
square_size = 1200; % Define the size of the square window in pixels
position = [(screen_size(3) - square_size) / 2, (screen_size(4) - square_size) / 2, square_size, square_size];
set(figure_handle, 'Position', position);
pcolor(XX, YY, abs(p1))
colormap hot
shading interp
colorbar
set(gca,'FontSize',24)
axis equal
exportgraphics(gca, ['manuscript_figure\single_focus_IBP_only.png'])

ibp_phase = struct2array(load('ibp_phase_2focus.mat'));
p1 = pressure_calc_2d(pre_calc,phase_mask + ibp_phase);

figure_handle = figure;
screen_size = get(0, 'ScreenSize');
square_size = 1200; % Define the size of the square window in pixels
position = [(screen_size(3) - square_size) / 2, (screen_size(4) - square_size) / 2, square_size, square_size];
set(figure_handle, 'Position', position);
pcolor(XX, YY, abs(p1))
colormap hot
shading interp
colorbar
set(gca,'FontSize',24)
axis equal
exportgraphics(gca, ['manuscript_figure\twofocus_IBP.png'])


p1 = pressure_calc_2d(pre_calc,ibp_phase);

figure_handle = figure;
screen_size = get(0, 'ScreenSize');
square_size = 1200; % Define the size of the square window in pixels
position = [(screen_size(3) - square_size) / 2, (screen_size(4) - square_size) / 2, square_size, square_size];
set(figure_handle, 'Position', position);
pcolor(XX, YY, abs(p1))
colormap hot
shading interp
colorbar
set(gca,'FontSize',24)
axis equal
exportgraphics(gca, ['manuscript_figure\twofocus_IBP_only.png'])
