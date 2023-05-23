function pre_calc = pre_pressure_calc_2d_pat(XX, YY, focal_point,Trans_x, Trans_y, Trans_z, f0, c0, p_0, k, trans_q, a)
pre_calc = zeros(length(XX), length(YY), length(Trans_x));
for tr = 1:length(Trans_x)
    r_prep_x = XX-Trans_x(tr);
    r_prep_y = YY-Trans_y(tr);
    r_prep_z = focal_point(3) - Trans_z(tr);
    R = sqrt((r_prep_x).^2 + (r_prep_y).^2 + (r_prep_z).^2);
    focal_phi = -(2*pi*f0/c0).*(sqrt((Trans_x(tr)-focal_point(1)).^2+(Trans_y(tr)-focal_point(2)).^2+(Trans_z(tr)-focal_point(3)).^2) ...
            - sqrt(focal_point(1).^2 + focal_point(2).^2 + focal_point(3).^2));
    dotproduct = r_prep_x.*trans_q(1) + r_prep_y.*trans_q(2) + r_prep_z.*trans_q(3);
    theta = acos(dotproduct./R./sqrt(trans_q(1).^2+trans_q(2).^2+trans_q(3).^2));
    D = directivity_fun(k, a, theta);
    pre_calc(:, :,tr) = (p_0./R).* D.*exp(1j.*(k.*R + focal_phi));
end
end