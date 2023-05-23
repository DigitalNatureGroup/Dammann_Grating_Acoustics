function p1 = pre_pressure_calc_3d(XX, YY, ZZ, focal_point,Trans_x, Trans_y, Trans_z, f0, c0, p_0, k, custom_phase)
p1 = zeros(length(XX), length(YY), length(ZZ));
for tr = 1:length(Trans_x)
    r_prep_x = XX-Trans_x(tr);
    r_prep_y = YY-Trans_y(tr);
    r_prep_z = ZZ - Trans_z(tr);
    R = sqrt((r_prep_x).^2 + (r_prep_y).^2 + (r_prep_z).^2);
    focal_phi = -(2*pi*f0/c0).*(sqrt((Trans_x(tr)-focal_point(1)).^2+(Trans_y(tr)-focal_point(2)).^2+(Trans_z(tr)-focal_point(3)).^2) ...
            - sqrt(focal_point(1).^2 + focal_point(2).^2 + focal_point(3).^2));
    p1 = p1 + (p_0./R).* exp(1j.*(k.*R + focal_phi + custom_phase(tr)));
end
end