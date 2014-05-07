Ts = 0.01;
t=0:Ts:10;
u = sin(pi*t);

%% a)
w = pi;
G_pi = 1/(1+0.2*i*w);
G_pi_abs = abs(G_pi);
G_pi_angle = angle(G_pi);

%% b)
G=tf(1,[0.2 1]);
y = lsim(G,u,t);
figure(1)
plot(t,u,t,y,t,G_pi_abs*sin(pi*t+G_pi_angle))
legend('u','y simulerad','y beräknad')

%% c)
% Ta bort 1 sampel för att få ett jämnt antal punkter, 0.5 Hz blir då även
% en exakt punkt i FFTn
Y = fft(y(1:end-1));
U = fft(u(1:end-1));

% Lösning 1
NFFT = length(Y);
f_FFT = 1/Ts/2*linspace(0,1,NFFT/2+1);
single_side_amplitude_spectrum_U = 2*abs(U(1:NFFT/2+1))/NFFT;
single_side_amplitude_spectrum_Y = 2*abs(Y(1:NFFT/2+1))/NFFT;
figure(2)
plot(f_FFT,single_side_amplitude_spectrum_U,...
    f_FFT,single_side_amplitude_spectrum_Y)
f_05Hz_index = find(f_FFT==0.5);
% Kvot vid 0.5 Hz
single_side_amplitude_spectrum_Y(f_05Hz_index)/single_side_amplitude_spectrum_U(f_05Hz_index)

% Lösning 2
[xmax,imax]=max(abs(U));
figure(3)
compass(U(imax))
hold on
compass(Y(imax),'g')
Gjw = 1/(1+0.2j*pi);
compass(U(imax)*Gjw,'r')

%% d)
u1 = chirp(t,0.01,10,20);
y1=lsim(G,u1,t)';
figure(4)
subplot(2,1,1)
plot(u1)
subplot(2,1,2)
plot(y1)

f = linspace(0,50,501);
w_d = 2*pi*f;

Y1 = fft(y1);
U1 = fft(u1);

G1 = Y1(1:501)./U1(1:501);
G2 = bode(G,w_d);
G3 = 1./(1+0.2*i*w_d);

figure(5)
loglog(f,G1,f,squeeze(G2),f,G3)
legend('G1','G2','G3')