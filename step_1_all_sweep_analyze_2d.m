clear all
close all
clc

addpath('codes\')
rng default % For reproducibility

common_parameters

writematrix([x1;x2],"x_ii.csv")

pmax = 5.538116103374706e+04; % found through single focus pressure
for ii = 1:length(x1)
    damman_x_k = [0 x1(ii) x2(ii) 0.5];
    damman_y_k = damman_x_k;
    [damman_mask, combined_2d] = generate_damman(damman_x, damman_x_k,damman_y, damman_y_k, Trans_x, Trans_y);
    phase_mask = zeros(size(damman_mask));
    phase_mask(damman_mask==1) = pi;
    phase_mask(damman_mask==-1) = 0;
    p1 = pressure_calc_2d(pre_calc,phase_mask);
    
    figure(1)
    pcolor(XX, YY, abs(p1)'./pmax)
    shading interp
    colormap hot
    axis equal
    xlim([-max_t max_t])
    ylim([-max_t max_t])
    clim([0 1])
    exportgraphics(gcf,['visual_damman\pressure_peaks_' num2str(ii) '_.png'])

    figure(2)
    pcolor(XX, YY, angle(p1)')
    shading interp
    colormap jet
    axis equal
    xlim([-max_t max_t])
    ylim([-max_t max_t])
    clim([-pi pi])
    exportgraphics(gcf,['visual_damman\phase_peaks_' num2str(ii) '_.png'])

    save(['visual_damman\field_save' num2str(ii) '_.mat'], 'p1', 'XX', 'YY');
end

