clear all
close all
clc

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
min_t = -0.08;
max_t = 0.08;
Trans_x = readmatrix("trans_x.csv");
Trans_y = readmatrix("trans_y.csv");
Trans_z = readmatrix("trans_z.csv");
Trans_x(Trans_z>0) = [];
Trans_y(Trans_z>0) = [];
Trans_z(Trans_z>0) = [];

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

trap_translate = [-5*lambda, -2.5*lambda];
ii =1;

for jj = 1:length(trap_translate)
    focal_point = [trap_translate(jj),0,0.1];
    focal_phi = -(2*pi*f0/c0).*(sqrt((Trans_x-focal_point(1)).^2+(Trans_y-focal_point(2)).^2+(Trans_z-focal_point(3)).^2) ...
        - sqrt(focal_point(1).^2 + focal_point(2).^2 + focal_point(3).^2));

    damman_x_k = [0 best_comb_trap(ii,1) best_comb_trap(ii,2)];
    damman_y_k = damman_x_k;
    [damman_mask, combined_2d] = generate_damman(damman_x, damman_x_k,damman_y, damman_y_k, Trans_x, Trans_y);

    phase_mask = zeros(size(damman_mask));
    phase_mask(damman_mask==1) = pi;
    phase_mask(damman_mask==-1) = 0;

    figure_handle = figure;
    screen_size = get(0, 'ScreenSize');
    square_size = 1200; % Define the size of the square window in pixels
    position = [(screen_size(3) - square_size) / 2, (screen_size(4) - square_size) / 2, square_size, square_size];
    set(figure_handle, 'Position', position);
    
    scatter(Trans_x, Trans_y, 15000, phase_mask,'.')
    axis equal
    colormap gray
    clim([0 2*pi])
    set(gca,'FontSize',24)
    exportgraphics(gca, ['manuscript_figure\shift_' num2str(jj) '_damman.png'])

    figure_handle = figure;
    screen_size = get(0, 'ScreenSize');
    square_size = 1200; % Define the size of the square window in pixels
    position = [(screen_size(3) - square_size) / 2, (screen_size(4) - square_size) / 2, square_size, square_size];
    set(figure_handle, 'Position', position);
    
    scatter(Trans_x, Trans_y, 15000, mod(focal_phi, 2*pi),'.')
    axis equal
    colormap gray
    set(gca,'FontSize',24)
    clim([0 2*pi])
    exportgraphics(gca, ['manuscript_figure\shift_' num2str(jj) '_focus.png'])

    figure_handle = figure;
    screen_size = get(0, 'ScreenSize');
    square_size = 1200; % Define the size of the square window in pixels
    position = [(screen_size(3) - square_size) / 2, (screen_size(4) - square_size) / 2, square_size, square_size];
    set(figure_handle, 'Position', position);
    
    scatter(Trans_x, Trans_y, 15000, mod(focal_phi+phase_mask, 2*pi),'.')
    axis equal
    colormap gray
    clim([0 2*pi])
    set(gca,'FontSize',24)
    exportgraphics(gca, ['manuscript_figure\shift_' num2str(jj) '_total.png'])
end

rotate_translate = [22.5 45];
focal_point = [0,0,0.1];
for jj = 1:length(rotate_translate)

    damman_x_k = [0 best_comb_trap(ii,1) best_comb_trap(ii,2)];
    damman_y_k = damman_x_k;
    [damman_mask, combined_2d] = generate_damman_rotate(damman_x, damman_x_k,damman_y, damman_y_k, Trans_x, Trans_y, rotate_translate(jj));

%     return
    phase_mask = zeros(size(damman_mask));
    phase_mask(damman_mask==1) = pi;
    phase_mask(damman_mask==-1) = 0;  
    
    focal_phi = -(2*pi*f0/c0).*(sqrt((Trans_x-focal_point(1)).^2+(Trans_y-focal_point(2)).^2+(Trans_z-focal_point(3)).^2) ...
        - sqrt(focal_point(1).^2 + focal_point(2).^2 + focal_point(3).^2));

    figure_handle = figure;
    screen_size = get(0, 'ScreenSize');
    square_size = 1200; % Define the size of the square window in pixels
    position = [(screen_size(3) - square_size) / 2, (screen_size(4) - square_size) / 2, square_size, square_size];
    set(figure_handle, 'Position', position);
    
    scatter(Trans_x, Trans_y, 15000, phase_mask,'.')
    axis equal
    colormap gray
    clim([0 2*pi])
    set(gca,'FontSize',24)
    exportgraphics(gca, ['manuscript_figure\rotate_' num2str(jj) '_damman.png'])

    figure_handle = figure;
    screen_size = get(0, 'ScreenSize');
    square_size = 1200; % Define the size of the square window in pixels
    position = [(screen_size(3) - square_size) / 2, (screen_size(4) - square_size) / 2, square_size, square_size];
    set(figure_handle, 'Position', position);
    
    scatter(Trans_x, Trans_y, 15000, mod(focal_phi, 2*pi),'.')
    axis equal
    colormap gray
    set(gca,'FontSize',24)
    clim([0 2*pi])
    exportgraphics(gca, ['manuscript_figure\rotate_' num2str(jj) '_focus.png'])

    figure_handle = figure;
    screen_size = get(0, 'ScreenSize');
    square_size = 1200; % Define the size of the square window in pixels
    position = [(screen_size(3) - square_size) / 2, (screen_size(4) - square_size) / 2, square_size, square_size];
    set(figure_handle, 'Position', position);
    
    scatter(Trans_x, Trans_y, 15000, mod(focal_phi+phase_mask, 2*pi),'.')
    axis equal
    colormap gray
    clim([0 2*pi])
    set(gca,'FontSize',24)
    exportgraphics(gca, ['manuscript_figure\rotate_' num2str(jj) '_total.png'])
end