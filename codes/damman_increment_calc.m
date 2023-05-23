function [phase_mask,damman_x_k] = damman_increment_calc(d,Trans_x, Trans_y)
d_k = cumsum([0 d]);
damman_x_k = 0.5.*d_k./(d_k(end));
damman_x_k = damman_x_k(1:end-1);

damman_x= linspace(0,0.5,100);
damman_x(1) = [];
damman_x(end) = [];

damman_y= linspace(0,0.5,100);
damman_y(1) = [];
damman_y(end) = [];

[damman_mask, ~] = generate_1d_damman(damman_x, damman_x_k, damman_y, Trans_x, Trans_y);

phase_mask = zeros(size(damman_mask));
phase_mask(damman_mask==1) = pi;
phase_mask(damman_mask==-1) = 0;
end