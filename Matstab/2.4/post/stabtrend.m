function stabtrend(file)
% stabtrend(verificationfile)
% plottar resultat fr�n verifieringk�rning
% indata: .mat-file fr�n verify

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
xlabel('dr, m�tning')
ylabel('dr, matstab')
title([upper(staton) ' D�mpkvot matstab mot m�tning'])
%legend([h1;h2],'c12-17','c18',4)

%
clf
subplot(211)
plot(drmeas,'-x')
hold on
plot(drmstab,'-or')
legend('M�tning','Matstab')

subplot(212)
plot(f.fdmeas,'-x')
hold on
plot(fdmstab,'-or')
legend('M�tning','Matstab')
