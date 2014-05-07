function present_pump(f_matstab)
%present_pump(f_matstab)
%
%Presents homologus pumpkurves and ordinary
%pumpkurves
%
%f_matstab - matstab output file (extension: .mat)

%@(#)   1.2     99/03/05     12:29:42

%load(f_matstab,'pump','pk1','pk2','phcpump','nhcpump','Wl','P','tl','NIN')
load(f_matstab,'geom','termo','steady')

pump=termo.pump;
pk1=termo.pk1;
pk2=termo.pk2;
phcpump=termo.phcpump;
nhcpump=termo.nhcpump;
Wl=steady.Wl_dc2(end);
P=termo.P;
tl=steady.tl_dc2(end);
P=P(1);

rol = cor_rol(P,tl);

Q = Wl/rol;
q = Q/pump(3);

w = nhcpump/pump(1);

h = (phcpump/9.81/rol - pump(7)*(Q^2))/pump(4);

subplot(1,2,2)
plot(pk1(:,2),pk1(:,1),'b'),hold on
plot(pk1(:,2),pk1(:,1),'bx')
plot(pk2(:,2),pk2(:,1),'r')
plot(pk2(:,2),pk2(:,1),'rx')
if (q/w)>1,
  plot(w/q,h/(q^2),'ro')
else
  plot(q/w,h/(w^2),'bo')
end
plot([0 1],[0 0],'k')
title('Homologous pump model')
text(0.1,0.4,'h / w^2','Rotation',90,'Color',[0 0 1]);
text(0.2,0.4,'h / q^2','Rotation',90,'Color',[1 0 0]);
text(0.1,-0.8,'q / w','Color',[0 0 1]);
text(0.1,-0.9,'w / q','Color',[1 0 0]);
grid
hold off

%Ordinary pump model

rpm = [0.2:0.1:1]'*pump(1)*60;

Wmass = [0.2:0.02:1]'*pump(3)*rol;

Phead1 = NaN*ones(length(Wmass),length(rpm));
Phead2 = Phead1;
for nn=1:length(rpm),
  for mm=1:length(Wmass),
     w = rpm(nn)/60/pump(1);
     q = Wmass(mm)/rol/pump(3);
     if (q/w)>1,
       h = interp1(pk2(:,2),pk2(:,1),w/q)*q^2;
       Phead2(mm,nn) = (pump(4)*h + pump(7)*(Wmass(mm)/rol)^2)*9.81*rol/1e5;
     else
       h = interp1(pk1(:,2),pk1(:,1),q/w)*w^2;
       Phead1(mm,nn) = (pump(4)*h + pump(7)*(Wmass(mm)/rol)^2)*9.81*rol/1e5;
     end
  end
end
subplot(1,2,1)
plot(Wmass,Phead1,'b'),grid,hold on
plot(Wmass,Phead2,'r')
title('Pump curves')
xlabel('Pump flow [kg/s]')
ylabel('Pump head [bar]')
tx=plot(Wl,phcpump/1e5,'rx');
set(tx,'linewidth',5);
set(tx,'markersize',20);

for nn=1:length(rpm),
  w = rpm(nn)/60/pump(1);
  q = min(Wmass)/rol/pump(3);
  if (q/w)>1,
    text(min(Wmass),Phead2(1,nn),[num2str(round(rpm(nn))),' rpm'],...
      'HorizontalAlignment','center')
  else
    text(min(Wmass),Phead1(1,nn),[num2str(round(rpm(nn))),' rpm'],...
      'HorizontalAlignment','center')
  end
end

hold off
