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
focal_point = [0,0,0.1];
pre_calc = pre_pressure_calc_2d_pat(XX, YY, focal_point,Trans_x, Trans_y, Trans_z, f0, c0, p_0, k, trans_q, a);

load('transfer2pat.mat')
store_3db_range = zeros(length(best_comb_trap), 1);
local_peak = zeros(length(best_comb_trap), 1);
nan_coordinates = [];

phase_store = zeros(length(best_comb_trap), length(Trans_x));
for ii = 1:length(best_comb_trap)
    damman_x_k = [0 best_comb_trap(ii,1) best_comb_trap(ii,2) 0.5];
    damman_y_k = damman_x_k;
    [damman_mask, combined_2d] = generate_damman(damman_x, damman_x_k,damman_y, damman_y_k, Trans_x, Trans_y);
    phase_mask = zeros(size(damman_mask));
    
    phase_mask(damman_mask==1) = 1;
    phase_mask(damman_mask==-1) = 0;  
    filename = sprintf('sonicSurface_mask/%d.csv', ii);
    writematrix(phase_mask, filename);
    
%     phase_mask(damman_mask==1) = pi;
%     phase_mask(damman_mask==-1) = 0;
%     phase_store(ii, :) = phase_mask;
    

%     p1 = pressure_calc_2d(pre_calc,phase_mask);
% 
%     figure_handle = figure;
%     screen_size = get(0, 'ScreenSize');
%     square_size = 1200; % Define the size of the square window in pixels
%     position = [(screen_size(3) - square_size) / 2, (screen_size(4) - square_size) / 2, square_size, square_size];
%     set(figure_handle, 'Position', position);
%     pcolor(XX, YY, abs(p1))
%     colormap hot
%     shading interp
%     clim([0 2500])
%     [x_peaks, y_peaks, peak_values] = findpeaks2D(abs(p1)', xx, yy, 5e-03);
%     % Combine x, y, and f into a single matrix
%     data = [x_peaks(:), y_peaks(:), peak_values(:)];
% 
%     % Sort the matrix rows based on the values of the f(x,y) column (3rd column)
%     sorted_data = sortrows(data, -3);
%     % Extract the sorted x and y values
%     sorted_x = sorted_data(:, 1);
%     sorted_y = sorted_data(:, 2);
%     sorted_peaks = sorted_data(:,3);
%     
%     hold on
%     scatter(sorted_x(1:unique_trap_n(ii)), sorted_y(1:unique_trap_n(ii)),250, 'kx','LineWidth',2)
%     set(gca,'FontSize',24)
%     axis equal
%     exportgraphics(gca, ['selected_traps\selected_trap_n_' num2str(unique_trap_n(ii)) 'pat.png'])
% 
%     figure_handle = figure;
%     screen_size = get(0, 'ScreenSize');
%     square_size = 1200; % Define the size of the square window in pixels
%     position = [(screen_size(3) - square_size) / 2, (screen_size(4) - square_size) / 2, square_size, square_size];
%     set(figure_handle, 'Position', position);
%     pcolor(XX, YY, angle(p1))
%     colormap jet
%     shading interp
%     
%     hold on
%     scatter(sorted_x(1:unique_trap_n(ii)), sorted_y(1:unique_trap_n(ii)),250, 'kx','LineWidth',2)
%     set(gca,'FontSize',24)
%     axis equal
%     exportgraphics(gca, ['selected_traps\selected_trap_n_' num2str(unique_trap_n(ii)) 'pat_phase.png'])
end

% writematrix(phase_store, 'phase_exports_pat.csv')