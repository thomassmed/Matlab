% �vning 1
%
% Euler fram�t: N(k+1) = N(k)-h*N
% Euler bak�t: N(k+1) = N(k)/(1+h)

lock_axis = 1;

h = 0.004;
N0 = 1;
t = 0:h:5;

N_f=zeros(size(t));
N_f(1) = N0;
N_b=zeros(size(t));
N_b(1) = N0;

for k=1:length(t)-1;
    N_f(k+1) = N_f(k)-h*N_f(k); % Euler fram�t
    N_b(k+1) = N_b(k)/(1+h); % Euler bak�t
end

subplot(2,1,1)
plot(t, exp(-t), t, N_f, t, N_b)
legend('Exakt', 'Euler fram�t', 'Euler bak�t')
title('Absolutv�rde')
grid on

subplot(2,1,2)
plot(t, exp(-t)-N_f,t, exp(-t) - N_b, t, N_f-N_b)
legend('Exakt - Euler fram�t','Exakt - Euler bak�t', 'Euler fram�t - Euler bak�t')
title('Skillnad')
if lock_axis
    axis([0 5 -3e-3 3e-3])
end
grid on
shg