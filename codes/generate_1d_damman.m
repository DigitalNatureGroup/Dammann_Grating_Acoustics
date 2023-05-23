function [damman_mask, combined_2d] = generate_1d_damman(damman_x, damman_x_k, damman_y, transducer_x, transducer_y)

g_x = damman_grating(damman_x, damman_x_k); 
g_x = [fliplr(g_x), g_x];
combined_2d = repmat(g_x, length(g_x), 1);
combined_2d(combined_2d==0) = 1;
x = [-fliplr(damman_x) damman_x];
y = [-fliplr(damman_y) damman_y];

%Normalize to between -0.5 and 0.5
transducer_x = (transducer_x ./ max(abs(transducer_x))).*0.49;
transducer_y = (transducer_y ./ max(abs(transducer_y))).*0.49;

damman_mask = zeros(size(transducer_x));
for tr = 1:length(transducer_x)
    damman_mask(tr) = sign(interp2(x, y, combined_2d, transducer_x(tr), transducer_y(tr)));
end

end