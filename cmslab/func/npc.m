function [V1,V2]=npc(x1,x2,fv,fs)

% [V1,V2]=npc(x1,x2,fv,fs) 
% x1 och x2 är två stycken lika långa signaler.
% Funktionen returnerar värdet av resp. npc-funktion vid frekvensen fv
% normerat med värdet av koherensfunktionen mellan signalerna vid 
% samma frekvens. V1 anger hur mycket x1 påverkar x2 och V2 vice versa.
% Koherensfunktionen och npc_funktionerna plottas även som funktion av frekvensen
% fs är samplingsfrekvensen. 

x1=dtrend(x1,1);
x2=dtrend(x2,1);


th1=arx([x2 x1],[15 15 1],[],1/fs);
th2=arx([x1 x2],[15 15 1],[],1/fs);

[Gx2_x1,Px2]=th2ff(th1);
[Gx1_x2,Px1]=th2ff(th2);

f=Gx1_x2(:,1);

G12=Gx1_x2(:,2);
G21=Gx2_x1(:,2);

P11=Px1(:,2);
P22=Px2(:,2);

f12(1)=0;
G12(1)=0;
G21(1)=0;
P11(1)=0;
P22(1)=0;


for i=1:length(f)
	if (G12(i)^2)*P22(i)+P11(i)>0
		NPC12(i)=(G12(i)^2)*P22(i)/((G12(i)^2)*P22(i)+P11(i));
	else
		NPC12(i)=0;
	end
		
	if (G21(i)^2)*P11(i)+P22(i)>0
		NPC21(i)=(G21(i)^2)*P11(i)/((G21(i)^2)*P11(i)+P22(i));
	else
		NPC21(i)=0;
	end				
end

f(1)=0;
f=f/(2*pi);
N=length(f);
fmax=f(N);
index=round(fv*N/fmax)+1;

V1=NPC21(index);
V2=NPC12(index);

[C,f2]=cohere(x2,x1,[],fs);

f2(1)=0;

N2=length(f2);
f2max=f2(N2);
index2=round(fv*N2/f2max)+1;
norm=C(index2);
V1=V1/norm;
V2=V2/norm;

figure
subplot(2,2,1),plot(f,NPC12), title('Hur signal2 påverkar signal1')
subplot(2,2,2),plot(f,NPC21), title('Hur signal1 påverkar signal2')
subplot(2,2,3),plot(f2,C),title('Koherensfunktionen mellan signalerna')



