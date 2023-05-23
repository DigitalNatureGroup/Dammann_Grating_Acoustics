function [m_fourier, frequency_sp] = fft_calc(data_points,t_space)
m_fourier_out = fft(data_points).*2./length(t_space);
fc = 1./(t_space(end)-t_space(1));
frequency_sp = fc.*[0:length(m_fourier_out)-1];
m_fourier = m_fourier_out(1:end/2);
frequency_sp = frequency_sp(1:end/2);
end