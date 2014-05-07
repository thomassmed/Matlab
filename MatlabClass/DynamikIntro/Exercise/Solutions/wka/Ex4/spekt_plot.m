function spekt_plot(obj, event, n)
Ts = 0.01;
fs = 1/Ts;
t=0:Ts:10-Ts;
NFFT = length(t);
df = fs/NFFT;

f = (df*n);
u = sin(f*2*pi*t);
U=fft(u);

f_twosided = 0:df:fs-df;
subplot(2,1,1)
plot(t,u);
title(['Signal (u), sinus med frekvens ' num2str(f) ' Hz, fs=' num2str(fs) ' Hz'])
ylim([-1 1])
xlabel('Tid [s]')
subplot(2,1,2)
plot(f_twosided, abs(U)/NFFT, [50 50], [0 1],'r--');
title('Dubbelsidigt amplitudspektrum, abs(fft(u))/length(u)')
xlabel('Frekvens [Hz]')
ylim([0 1])
legend('FFT','Nyquist frekvens')
shg
end
