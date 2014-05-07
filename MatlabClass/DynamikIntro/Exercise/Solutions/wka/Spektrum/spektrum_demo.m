%% Skapa signal
nof_samp = 1000;
Ts = 0.001;
fs = 1/Ts;
t = (0:nof_samp-1)'*Ts;
sin1_f = 100;
sin1_f = sin1_f + fs/2/nof_samp; % "Halva effekten i två närliggande FFT punkter"
sin1_A = 1;
sin1 = sin1_A*sin(2*pi*sin1_f*t);
brus_A = 0;
brus = brus_A*randn(nof_samp,1);

sin2_f = 101;
sin2_A = 1;
sin2 = sin2_A*sin(2*pi*sin2_f*t);

en_sinus = 1;
if en_sinus
    x1 = sin1 + brus;
else
    x1 = sin1 + sin2 + brus;
end

zero_padding = 1;
if zero_padding == 1
    nof_padding = length(sin1)*10;
    x1 = [sin1+brus; zeros(nof_padding,1)];
    t = (0:length(x1)-1)'*Ts;
end

% Spektrum
% Utför enkelsidig FFT
fft_x1 = fft(x1); % FFT
N_x1 = length(x1);
fft_oneside_x1 = fft_x1(1:N_x1/2+1); % Enkelsidig
f_x1 = fs/2*linspace(0, 1, N_x1/2+1);

% Beräkna spektrum
AS_x1 = 2/N_x1*abs(fft_oneside_x1); % Amplitudspektrum
PS_x1 = 2/fs/N_x1*abs(fft_oneside_x1).^2; % Effektspektrum

% Plot
figure(1)
subplot(3,1,1)
plot(t,x1,'r')
%plot(t,x1)
%axis([0 t(end) -5*brus_A brus_A*5])
xlabel('Tid [s]')
ylabel('Amplitud')
subplot(3,1,2)
plot(f_x1, AS_x1)
xlabel('Frekvens [Hz]')
ylabel('Amplitudspektrum')
axis([0 fs/2 0 round(sin1_A*1.2*10)/10])
subplot(3,1,3)
plot(f_x1, PS_x1)
xlabel('Frekvens [Hz]')
ylabel('"Effektspektrumstäthet" (PSD)')
%axis([0 fs/2 0 round(sin1_A*1.2*10)/10])
shg

%% Periodogram
% [Pxx,f] = periodogram(x,window,nfft,fs,'range') Syntax
[PS_x1_per1, f_x1_per1] = periodogram(x1,window(@rectwin,N_x1),N_x1,fs);

nof_segments = 100;
segment_length = round(N_x1/nof_segments);
percent_overlap = 0;
% [Pxx,F] = PWELCH(X,WINDOW,NOVERLAP,NFFT,Fs) Syntax
[PS_x1_welch1, f_x1_welch1] = pwelch(x1,window(@rectwin,segment_length),...
    round(segment_length*percent_overlap/100),segment_length,fs);
%[PS_x1_welch1, f_x1_welch1] =
%pwelch(x1,window(@rectwin,segment_length),...
%    round(segment_length*percent_overlap/100),segment_length*10,fs);

figure(2)
subplot(2,1,1)
plot(f_x1, PS_x1, f_x1_per1, PS_x1_per1,'r', f_x1_welch1, PS_x1_welch1,'k')
ylabel('Effekt/frekvens (1/HZ)')
legend('FFT', 'Periodogram','Welch')
xlabel('Frekvens [Hz]')
grid on
subplot(2,1,2)
plot(f_x1, 10*log10(PS_x1), f_x1_per1, 10*log10(PS_x1_per1),'r', f_x1_welch1, 10*log10(PS_x1_welch1),'k')
ylabel('Effekt/frekvens (dB/HZ)')
legend('FFT', 'Periodogram','Welch')
xlabel('Frekvens [Hz]')
grid on