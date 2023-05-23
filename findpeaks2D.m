function [x_peaks, y_peaks, peak_values] = findpeaks2D(M, x, y, R)
    % Get the dimensions of the input matrix
    [rows, cols] = size(M);

    % Initialize the output arrays for row and column indices of local maxima
    row = [];
    col = [];

    % Iterate through each element in the matrix
    for r = 2:(rows - 1)
        for c = 2:(cols - 1)
            % Check if the current element is greater than or equal to its 8 neighboring elements
            if M(r, c) >= M(r-1, c-1) && M(r, c) >= M(r-1, c) && M(r, c) >= M(r-1, c+1) && ...
               M(r, c) >= M(r, c-1) && M(r, c) >= M(r, c+1) && ...
               M(r, c) >= M(r+1, c-1) && M(r, c) >= M(r+1, c) && M(r, c) >= M(r+1, c+1)

                % Check if the current element is not part of an already detected flat peak
                if isempty(row) || (~isempty(row) && ~(M(row(end), col(end)) == M(r, c) && (row(end) == r || col(end) == c)))
                    % If the current element is a local maximum, add its indices to the output arrays
                    row = [row; r];
                    col = [col; c];
                end
            end
        end
    end

    % Get the x and y coordinates and peak values at the local maxima
    x_peaks = x(col);
    y_peaks = y(row);
    peak_values = M(sub2ind(size(M), row, col));

    % Now, sort the peaks in order of amplitude:
    [peak_values_sorted, idx] = sort(peak_values,'descend');
    x_peaks_sorted = x_peaks(idx);
    y_peaks_sorted = y_peaks(idx);

    % Start from the highest peak and discard any other peaks closer than the minimum peak distance
    this_peak = 1;
    while this_peak < (length(peak_values_sorted) + 1)
        % Calculate the Euclidean distances to all remaining neighbors
        dist = sqrt((x_peaks_sorted - x_peaks_sorted(this_peak)).^2 + (y_peaks_sorted - y_peaks_sorted(this_peak)).^2);
        % Find the neighbors that are within the minimum peak distance but not the peak itself
        within = (dist <= R) & (dist ~= 0);
        % Remove the peaks that are too close
        peak_values_sorted(within) = [];
        x_peaks_sorted(within) = [];
        y_peaks_sorted(within) = [];
        % Update the peak counter
        this_peak = this_peak + 1;
    end

    % Assign the filtered peaks to the output variables
    x_peaks = x_peaks_sorted;
    y_peaks = y_peaks_sorted;
    peak_values = peak_values_sorted;
end
