function stabtrend(file)
% stabtrend(verificationfile)
% plottar resultat från verifieringkörning
% indata: .mat-file från verify

load(file)
f=load(file);

% dmpkvot matstab mot mtning
plot(drmeas,drmstab,'x');
hold on
%h2=plot(drmeas(end),drmstab(end),'o');
plot([0 1],[0 1],'k')
plot([0 1],[0 1]-0.1,'-.k')
plot([0 1],[0 1]+0.1,'-.k')
axis([0 1 0 1])
grid on
xlabel('dr, mätning')
ylabel('dr, matstab')
title([upper(staton) ' Dämpkvot matstab mot mätning'])
%legend([h1;h2],'c12-17','c18',4)

%
clf
subplot(211)
plot(drmeas,'-x')
hold on
plot(drmstab,'-or')
legend('Mätning','Matstab')

subplot(212)
plot(f.fdmeas,'-x')
hold on
plot(fdmstab,'-or')
legend('Mätning','Matstab')
