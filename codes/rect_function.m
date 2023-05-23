function [outputArg1] = rect_function(x)

abs_x = abs(x);

outputArg1 = abs_x;
outputArg1(abs_x<0.5) = 1;
outputArg1(abs_x>=0.5) = 0;

end