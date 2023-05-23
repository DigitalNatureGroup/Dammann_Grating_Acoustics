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

xx = min(Trans_y):lambda/15:max(Trans_y);
yy = min(Trans_y):lambda/15:max(Trans_y);
[XX, YY]=ndgrid(xx,yy);
focal_point = [0,0,0.1];
pre_calc = pre_pressure_calc_2d(XX, YY, focal_point, Trans_x, Trans_y, Trans_z, f0, c0, p_0, k);

[x1,x2] = meshgrid(linspace(0, 0.5, 30));
% Create a mask for the upper triangular half
mask = triu(true(size(x1)), 1);

% Set the upper triangular half elements to NaN
x1(mask) = [];
x2(mask) = [];