function f = rectwin(x, width)
% Rectangular window function with specified width
% x: input vector
% width: width of window function (symmetric around zero)

f = abs(x) < width/2; % rectangular window condition
f = double(f); % convert logical array to double precision