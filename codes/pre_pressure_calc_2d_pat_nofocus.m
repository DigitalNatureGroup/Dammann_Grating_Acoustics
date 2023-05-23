function pre_calc = pre_pressure_calc_2d_pat_nofocus(XX, YY, Trans_x, Trans_y, Trans_z, p_0, k, trans_q, a, z_height)
pre_calc = zeros(length(XX), length(YY), length(Trans_x));
for tr = 1:length(Trans_x)
    r_prep_x = XX-Trans_x(tr);
    r_prep_y = YY-Trans_y(tr);
    r_prep_z = z_height - Trans_z(tr);
    R = sqrt((r_prep_x).^2 + (r_prep_y).^2 + (r_prep_z).^2);
    dotproduct = r_prep_x.*trans_q(1) + r_prep_y.*trans_q(2) + r_prep_z.*trans_q(3);
    theta = acos(dotproduct./R./sqrt(trans_q(1).^2+trans_q(2).^2+trans_q(3).^2));
%     D = directivity_fun(k, a, theta);
D= 1;
    pre_calc(:, :,tr) = (p_0./R).* D.*exp(1j.*(k.*R));
end
end