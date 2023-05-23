clear all
close all
clc

%% Simulation Settings
voltage = 20;
p_0 = (0.221)*voltage;
f0 = 40e03; % Hz
c0 = 346; % m/s

lambda = c0/f0;
k = 2*pi*f0/c0;
a = 4.5e-03; % Transducer Radius
trans_q = [0,0,1];

% Transducer
tr_spacing = 2e-03;
min_t = -0.08;
max_t = 0.08;
tx = min_t:tr_spacing:max_t;
ty = min_t:tr_spacing:max_t;
[Trans_x, Trans_y] = meshgrid(tx, ty);
Trans_x = Trans_x(:);
Trans_y = Trans_y(:);
Trans_z = 0.*Trans_y;

trans_array = [Trans_x Trans_y Trans_z];
% return
number_of_trans = length(trans_array);
%% initialize phase with random
geo_arr = [-2.5*lambda, 0, 0.1, 2.5*lambda, 0, 0.1];
phases = zeros(size(geo_arr,1), number_of_trans);
control_point_amp = ones(1, size(geo_arr, 2));

rand_phase = rand(1, length(control_point_amp)).*2.*pi;
for ii = 1:size(geo_arr,1)
    control_points = [geo_arr(ii, 1:3:end); geo_arr(ii, 2:3:end); geo_arr(ii, 3:3:end)];
    b = complex(control_point_amp.*cos(rand_phase), control_point_amp.*sin(rand_phase));
    
    transducer2point_amp = zeros(length(control_point_amp), number_of_trans);
    transducer2point_dist = zeros(length(control_point_amp), number_of_trans);
    single_point_field = zeros(length(control_point_amp), number_of_trans);
    for m = 1:size(control_points, 2)
        for tr = 1:number_of_trans
            trans_x = [trans_array(tr,1) trans_array(tr,2) trans_array(tr,3)];
            trans_q = [0 0 1];
            
            if trans_x(3) > 0
                trans_q(3) = -1;
            end
            
            r_prep_x = control_points(1,m)-trans_x(1);
            r_prep_y = control_points(2,m)-trans_x(2);
            r_prep_z = control_points(3,m)-trans_x(3);
            
            R = sqrt((r_prep_x).^2 + (r_prep_y).^2 + (r_prep_z).^2);
            dotproduct = r_prep_x.*trans_q(1) + r_prep_y.*trans_q(2) + r_prep_z.*trans_q(3);
            theta = acos(dotproduct./R./sqrt(trans_q(1).^2+trans_q(2).^2+trans_q(3).^2));
            if theta == 0
                theta = theta + realmin;
            end
            D = 1;
            transducer2point_amp(m, tr) = (p_0./R).*D;
            transducer2point_dist(m, tr) = R;
            
            single_point_field(m, tr) = (p_0./R).*D.*exp(1j.*(-k.*R));
        end
    end
    
    % return
    transducer_state = zeros(1, number_of_trans);
    for tr = 1:number_of_trans
        for m = 1:size(control_points, 2)
            transducer_state(tr) = transducer_state(tr) + complex(real(real(single_point_field(m, tr)).*real(b(m)) - imag(single_point_field(m, tr)).*imag(b(m))) ...
                ,(real(single_point_field(m, tr)).*imag(b(m)) + imag(single_point_field(m, tr)).*real(b(m))));
        end
    end
    
    curA2 = real(transducer_state).^2 + imag(transducer_state).^2;
    transducer_state = complex(real(transducer_state) ./sqrt(curA2), (imag(transducer_state) ./sqrt(curA2)));
    
    for n = 1:1000
        for m = 1:size(control_points, 2)
            b(m) = 0;
            for tr = 1:number_of_trans
                b(m) = b(m) + complex((real(transducer_state(tr))*real(single_point_field(m, tr)) ...
                    -imag(transducer_state(tr))*imag(-single_point_field(m, tr))), ...
                    (real(transducer_state(tr))*imag(-single_point_field(m, tr)) ...
                    -imag(transducer_state(tr))*real(single_point_field(m, tr))));
            end
        end
        for m = 1:size(control_points, 2)
            amp = sqrt(real(b(m)).^2 + imag(b(m)).^2);
            b(m) = complex(real(b(m)).*control_point_amp(m)./amp, imag(b(m)).*control_point_amp(m)./amp);
        end
        
        for tr = 1:number_of_trans
            transducer_state(tr) = 0;
            for m = 1:size(control_points, 2)
                transducer_state(tr) = transducer_state(tr) + complex(real(real(single_point_field(m, tr)).*real(b(m)) - imag(single_point_field(m, tr)).*imag(b(m))) ...
                    ,(real(single_point_field(m, tr)).*imag(b(m)) + imag(single_point_field(m, tr)).*real(b(m))));
            end
        end
        
        for tr = 1:number_of_trans
            amp = sqrt(real(transducer_state(tr)).^2 + imag(transducer_state(tr)).^2);
            transducer_state(tr) = complex(real(transducer_state(tr))/amp, imag(transducer_state(tr))/amp);
        end
    end
    
    phases(ii,:) = angle(transducer_state);
%     rand_phase = angle(transducer_state);
end
save('ibp_phase_2focus.mat','phases')