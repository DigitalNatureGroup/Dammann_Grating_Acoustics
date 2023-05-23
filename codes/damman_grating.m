function [g] = damman_grating(x, x_n)

if x_n(1) ~= 0
    error('First index of x_n needs to be a zero')
end

if min(x) < 0
    error('Less than zero')
end

if max(x) > 0.5
    error('More than 0.5')
end

N = length(x_n)-1;
g = 0.*x;
for n = 0:N-1
    index_n = n+1;
    g = g + ((-1)^(n)).*rect_function((x- 0.5*(x_n(index_n+1) + x_n(index_n)))./ (x_n(index_n+1) - x_n(index_n)));
end

end