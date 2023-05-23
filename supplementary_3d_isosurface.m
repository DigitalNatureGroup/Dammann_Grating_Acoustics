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

xx = -5*lambda:lambda/15:5*lambda;
yy = -5*lambda:lambda/15:5*lambda;
zz = -5*lambda:lambda/15:5*lambda;
focal_point = [0,0,0.1];
[XX, YY, ZZ]=ndgrid(xx,yy, zz+focal_point(3));

[x1,x2] = meshgrid(linspace(0, 0.5, 30));
% Create a mask for the upper triangular half
mask = triu(true(size(x1)), 1);

% Set the upper triangular half elements to NaN
x1(mask) = [];
x2(mask) = [];

pmax = 5.538116103374706e+04; % found through single focus pressure

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
    phase_mask(damman_mask==1) = pi;
    phase_mask(damman_mask==-1) = 0;
    phase_store(ii, :) = phase_mask;


    p1 = pressure_calc_3d(XX, YY, ZZ, focal_point, Trans_x, Trans_y, Trans_z, f0, c0, p_0, k, phase_mask);

    figure_handle = figure;
    screen_size = get(0, 'ScreenSize');
    square_size = 1200; % Define the size of the square window in pixels
    position = [(screen_size(3) - square_size) / 2, (screen_size(4) - square_size) / 2, square_size, square_size];
    set(figure_handle, 'Position', position);

    s = isosurface(xx,yy,zz+0.1,abs(p1)./pmax,(0.325/sqrt(2)));
    p = patch(s);
    isonormals(xx,yy,zz+0.1,abs(p1),p)
    view(3);
    set(p,'FaceColor',[1.0 0.0 0.0]);
    set(p,'EdgeColor','none');
    camlight;
    lighting gouraud;
    axis equal
    set(gca,'FontSize',24)
    exportgraphics(gca, ['selected_traps\selected_trap_n_' num2str(unique_trap_n(ii)) '3d_view' num2str(ii) '.png'])
    
end