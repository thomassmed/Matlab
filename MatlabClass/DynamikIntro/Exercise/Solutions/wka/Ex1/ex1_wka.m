% Övning 1
%
% Euler framåt: N(k+1) = N(k)-h*N
% Euler bakåt: N(k+1) = N(k)/(1+h)

lock_axis = 1;

h = 0.004;
N0 = 1;
t = 0:h:5;

N_f=zeros(size(t));
N_f(1) = N0;
N_b=zeros(size(t));
N_b(1) = N0;

for k=1:length(t)-1;
    N_f(k+1) = N_f(k)-h*N_f(k); % Euler framåt
    N_b(k+1) = N_b(k)/(1+h); % Euler bakåt
end

subplot(2,1,1)
plot(t, exp(-t), t, N_f, t, N_b)
legend('Exakt', 'Euler framåt', 'Euler bakåt')
title('Absolutvärde')
grid on

subplot(2,1,2)
plot(t, exp(-t)-N_f,t, exp(-t) - N_b, t, N_f-N_b)
legend('Exakt - Euler framåt','Exakt - Euler bakåt', 'Euler framåt - Euler bakåt')
title('Skillnad')
if lock_axis
    axis([0 5 -3e-3 3e-3])
end
grid on
shg