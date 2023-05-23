function [damman_mask, combined_2d] = generate_damman(damman_x, damman_x_k,damman_y, damman_y_k, transducer_x, transducer_y)

g_x =damman_grating(damman_x, damman_x_k); 
g_x = [fliplr(g_x), g_x];
Gx = repmat(g_x, length(g_x), 1);
x = [-fliplr(damman_x) damman_x];


g_y =damman_grating(damman_y, damman_y_k); 
g_y = [fliplr(g_y), g_y];
Gy = repmat(g_y, length(g_y), 1)';
y = [-fliplr(damman_y) damman_y];

combined_2d = Gx + Gy;
combined_2d(combined_2d == 0) = 1;
combined_2d(combined_2d == -2) = -1;
combined_2d(combined_2d == 2) = -1;

%Normalize to between -0.5 and 0.5
transducer_x = (transducer_x ./ max(abs(transducer_x))).*max(damman_x);

transducer_y = (transducer_y ./ max(abs(transducer_y))).*max(damman_x);

damman_mask = zeros(size(transducer_x));
for tr = 1:length(transducer_x)
    damman_mask(tr) = sign(interpn(x, y, combined_2d, transducer_x(tr), transducer_y(tr)));
end

end