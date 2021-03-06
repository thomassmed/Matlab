% Model of a blue whale's call

%% Create the time base for the signal.
fs = 4000;
t = 0:(1/fs):1.5;

%% Set the fundamental frequency of the call.
f0 = 175;

%% Create the harmonics.
y0 = sin(2*pi*f0*t) + sin(2*pi*2*f0*t) + sin(2*pi*3*f0*t);

%% Create the envelope
% Set the additional parameters in the model.
A0 = 2; % Initial amplitude.
B  = 1.5; % Amplitude decay rate.
fm = 0.65; % Frequency of the modulating envelope.
% Create the envelope
A  = A0*exp(-B*t).*sin(2*pi*fm*t);

%% Create the call.
call = A.*y0;

%% Plot the model call and listen to it.
figure
plot(t,call)
soundsc(call,fs)