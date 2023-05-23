function [p1] = pressure_calc_2d(pre_calc,phase_mask)
p1 = 0;
parfor tr = 1:length(phase_mask)
    p1 = p1 + pre_calc(:, :,tr).* exp(1j.*(phase_mask(tr)));
end
end