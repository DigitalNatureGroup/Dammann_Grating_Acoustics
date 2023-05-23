% function to print Checkerboard pattern
function x = create_checkerboard(n)
    disp('Checkerboard pattern:');
    
    % create a n x n matrix
    x = zeros(n, n);
    
    % fill with 1 the alternate rows and columns
    x(1:2:end, 1:2:end) = 1;
    x(2:2:end, 2:2:end) = 1;
    
    % print the pattern
%     disp(x);
end

