clear all
close all
clc

addpath('codes\')
rng default % For reproducibility

common_parameters

pmax = 5.538116103374706e+04; % found through single focus pressure

store_3db_range = zeros(length(x1), 1);
local_peak = zeros(length(x1), 1);
nan_coordinates = [];
for ii = 1:length(x1)
    load(['visual_damman\field_save' num2str(ii) '_.mat'], 'p1', 'XX', 'YY');
    % Find the local maxima in the 2D matrix
    [x_peaks, y_peaks, peak_values] = findpeaks2D(abs(p1)', xx, yy, 5e-03);
    % Combine x, y, and f into a single matrix
    data = [x_peaks(:), y_peaks(:), peak_values(:)];

    % Sort the matrix rows based on the values of the f(x,y) column (3rd column)
    sorted_data = sortrows(data, -3);

    % Extract the sorted x and y values
    sorted_x = sorted_data(:, 1);
    sorted_y = sorted_data(:, 2);
    sorted_peaks = sorted_data(:,3);

    max_local_peak = max(peak_values);
    % Calculate the -3dB threshold value (assuming the values are in linear scale)
    threshold = max_local_peak / sqrt(2);
    nan_out = 0;
    if max_local_peak < 0.325*pmax
        nan_out=1;
    else
        % Count the number of elements in sorted_peaks that are greater than or equal to the threshold value
        count_within_range = sum(peak_values >= threshold);

        if count_within_range > 1
            store_3db_range(ii, :) = count_within_range;
            local_peak(ii,:) = max_local_peak;
        else
            nan_out=1;
        end
    end

    if nan_out
        store_3db_range(ii, :) = NaN;
        local_peak(ii,:) = NaN;
        nan_coordinates = [nan_coordinates; x1(ii) x2(ii)];
    end
end
figure_handle = figure;
screen_size = get(0, 'ScreenSize');
square_size = 1200; % Define the size of the square window in pixels
position = [(screen_size(3) - square_size) / 2, (screen_size(4) - square_size) / 2, square_size, square_size];
set(figure_handle, 'Position', position);

scatter(x1, x2, 3500, store_3db_range,'.','LineWidth',2)
hold on
scatter(nan_coordinates(:,1), nan_coordinates(:,2), 700, 'kx','LineWidth',2)
axis equal
grid on
set(gca,'FontSize',24)
colorbar
colormap turbo
xlabel('x_1 [-]')
ylabel('x_2 [-]')
% Set the tick locations for the x and y axes
tick_values = 0:0.1:0.5;
xticks(tick_values);
yticks(tick_values);
exportgraphics(gca, 'fig_allsweep_trap_n.pdf','ContentType','vector')

figure_handle = figure;
screen_size = get(0, 'ScreenSize');
square_size = 1200; % Define the size of the square window in pixels
position = [(screen_size(3) - square_size) / 2, (screen_size(4) - square_size) / 2, square_size, square_size];
set(figure_handle, 'Position', position);
scatter(x1, x2, 3500, local_peak./pmax,'.','LineWidth',2)
hold on
scatter(nan_coordinates(:,1), nan_coordinates(:,2), 700, 'kx','LineWidth',2)
axis equal
grid on
set(gca,'FontSize',24)
colorbar
colormap hot
xlabel('x_1 [-]')
ylabel('x_2 [-]')
clim([0 1])
% Set the tick locations for the x and y axes
tick_values = 0:0.1:0.5;
xticks(tick_values);
yticks(tick_values);
exportgraphics(gca, 'fig_allsweep_trap_p.pdf','ContentType','vector')

disp(['Percentage of invalid combination ' num2str(sum(isnan(store_3db_range))./length(store_3db_range).*100, 3) ' Percent'])

%% For each trap, find which one is more stronger
unique_trap_n = unique(store_3db_range);
unique_trap_n(isnan(unique_trap_n)) = [];
disp(unique_trap_n)
best_comb_trap = zeros(length(unique_trap_n), 2);

for ii = 1:length(unique_trap_n)
    index = find(store_3db_range == unique_trap_n(ii));
    disp(['Share of N = ' num2str(unique_trap_n(ii)) ' (%): ' num2str(length(index)./length(store_3db_range).*100,3)])
    [M,I] = min(local_peak(index));
    choice_i = index(I);
    best_comb_trap(ii, :) = [x1(choice_i) x2(choice_i)];

    disp(num2str(best_comb_trap(ii,:),3))

    load(['visual_damman\field_save' num2str(choice_i) '_.mat'], 'p1', 'XX', 'YY');

    figure_handle = figure;
    screen_size = get(0, 'ScreenSize');
    square_size = 1200; % Define the size of the square window in pixels
    position = [(screen_size(3) - square_size) / 2, (screen_size(4) - square_size) / 2, square_size, square_size];
    set(figure_handle, 'Position', position);
    pcolor(XX, YY, abs(p1)./(pmax))
    colormap hot
    shading interp
    clim([0 1])
    [x_peaks, y_peaks, peak_values] = findpeaks2D(abs(p1)', xx, yy, 5e-03);
    % Combine x, y, and f into a single matrix
    data = [x_peaks(:), y_peaks(:), peak_values(:)];

    % Sort the matrix rows based on the values of the f(x,y) column (3rd column)
    sorted_data = sortrows(data, -3);
    % Extract the sorted x and y values
    sorted_x = sorted_data(:, 1);
    sorted_y = sorted_data(:, 2);
    sorted_peaks = sorted_data(:,3);
    sorted_data = [sorted_x'; sorted_y'; sorted_peaks'];
    hold on
    scatter(sorted_x(1:unique_trap_n(ii)), sorted_y(1:unique_trap_n(ii)),250, 'wx','LineWidth',2)
    set(gca,'FontSize',24)
    axis equal
    exportgraphics(gca, ['selected_traps\selected_trap_n_' num2str(unique_trap_n(ii)) '.png'])
    close

    disp([num2str(mean(sorted_peaks(1:unique_trap_n(ii)))./(pmax))])
        
    figure_handle = figure;
    screen_size = get(0, 'ScreenSize');
    square_size = 1200; % Define the size of the square window in pixels
    position = [(screen_size(3) - square_size) / 2, (screen_size(4) - square_size) / 2, square_size, square_size];
    set(figure_handle, 'Position', position);
    pcolor(XX, YY, angle(p1)')
    colormap jet
    shading interp
    hold on
    clim([-pi pi])
    scatter(sorted_x(1:unique_trap_n(ii)), sorted_y(1:unique_trap_n(ii)),250, 'kx','LineWidth',2)
    set(gca,'FontSize',24)
    axis equal
    exportgraphics(gca, ['selected_traps\selected_trap_n_' num2str(unique_trap_n(ii)) 'phase.png'])

    damman_x_k = [0 x1(choice_i) x2(choice_i)];
    damman_y_k = damman_x_k;
    [damman_mask, combined_2d] = generate_damman(damman_x, damman_x_k,damman_y, damman_y_k, Trans_x, Trans_y);
    phase_mask = zeros(size(damman_mask));
    phase_mask(damman_mask==1) = pi;
    phase_mask(damman_mask==-1) = 0;

    figure_handle = figure;
    screen_size = get(0, 'ScreenSize');
    square_size = 1200; % Define the size of the square window in pixels
    position = [(screen_size(3) - square_size) / 2, (screen_size(4) - square_size) / 2, square_size, square_size];
    set(figure_handle, 'Position', position);
    
    scatter(Trans_x, Trans_y, 50, phase_mask,'.')
    axis equal
    set(gca,'FontSize',24)
    exportgraphics(gca, ['selected_traps\selected_trap_n_' num2str(unique_trap_n(ii)) '_sign.pdf'],'ContentType','vector')
    close

    writematrix(sorted_data, ['selected_traps\selected_trap_n_' num2str(unique_trap_n(ii)) '_data.csv'])
end

save('transfer2pat.mat','best_comb_trap','unique_trap_n')