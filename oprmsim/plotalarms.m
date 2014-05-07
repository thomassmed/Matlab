%
% Funktion för att plotta resultat från oprm-simulering
%
% Input:
%	simdata		Struct med data från simulering
%
function fig=plotalarms(simdata)

t = simdata.time;

fig = figure;

subplot(4,3,1);
plot(t,simdata.peak);
title('Normalized signal');
xlabel('Time [s]');


subplot(4,3,2);
plot(t,simdata.confcount);
title('Confirm count');
xlabel('Time [s]');


subplot(4,3,3);
plot(t,simdata.period0);
title('Base Period');
xlabel('Time [s]');

% **************************************************

subplot(4,3,4);
plot(t,simdata.aba_alarm);
title('ABA alarm (H1)');
xlabel('Time [s]');
set(gca,'YLim',[0 1.1]);


subplot(4,3,5);
plot(t,simdata.aba_pretrip);
title('ABA pretrip (H2)');
xlabel('Time [s]');
set(gca,'YLim',[0 1.1]);


subplot(4,3,6);
plot(t,simdata.aba_trip);
title('ABA trip (H3)');
xlabel('Time [s]');
set(gca,'YLim',[0 1.1]);

% **************************************************

subplot(4,3,7);
plot(t,simdata.pba_alarm);
title('PBA alarm (H1)');
xlabel('Time [s]');
set(gca,'YLim',[0 1.1]);


subplot(4,3,8);
plot(t,simdata.pba_pretrip);
title('PBA pretrip (H2)');
xlabel('Time [s]');
set(gca,'YLim',[0 1.1]);


subplot(4,3,9);
plot(t,simdata.pba_trip);
title('PBA trip (H3)');
xlabel('Time [s]');
set(gca,'YLim',[0 1.1]);


% **************************************************

subplot(4,3,10);
plot(t,simdata.grba_alarm);
title('GRBA alarm (H1)');
xlabel('Time [s]');
set(gca,'YLim',[0 1.1]);


subplot(4,3,11);
plot(t,simdata.grba_pretrip);
title('GRBA pretrip (H2)');
xlabel('Time [s]');
set(gca,'YLim',[0 1.1]);


subplot(4,3,12);
plot(t,simdata.grba_trip);
title('GRBA trip (H3)');
xlabel('Time [s]');
set(gca,'YLim',[0 1.1]);
