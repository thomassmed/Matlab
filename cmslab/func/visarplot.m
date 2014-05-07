function visarplot(argumentmatris,skalfaktor,detektor,detpos,mminj)
% visarplot(argumentmatris,skalfaktor,detektor,detpos,mminj)
% Funktion som redovisar amplitud och fas i de noder där lprm:erna är placerade som en visare.
% Funktionen kräver en distplot där resultatet ska ritas upp.
% Funktionen använder hjälpfunktionen "npclinje"
% ARGUMENTMATRISEN måste vara 25*676.
% I DETEKTOR anger du vilka lprmdetektorer du vill se: 
%		 detektor=1 -> toppdetektor 
%                detektor=2 -> övre mellandetektor
%		 detektor=3 -> nedre mellandetektor
%		 detektor=4 -> bottendetektor
%		 detektor=5 -> alla nivådetektorer
% DETPOS och MMINJ fås med hjälp av readdist. 
% DETPOS anger var lprm:erna är placerade och MMINJ hur härden ser ut.

matris=argumentmatris;

level1=zeros(30,30);
level2=zeros(30,30);
level3=zeros(30,30);
level4=zeros(30,30);

for count=1:676
	
	pos=knum2cpos(count,mminj);
	rad=pos(1);
	kol=pos(2);
	
	level1(rad,kol)=0.5*(matris(21,count)+matris(20,count));
	
	level2(rad,kol)=0.5*(matris(15,count)+matris(14,count));
	
	level3(rad,kol)=0.5*(matris(9,count)+0.25*matris(10,count)+0.75*matris(8,count));
	
	level4(rad,kol)=0.5*(matris(3,count)+0.62*matris(4,count)+0.38*matris(2,count));
	
end


N=length(detpos);
maxpos=detpos(N);
lp=zeros(6,maxpos);

for i=1:N
	nr=detpos(i);
	lp(1,nr)=1;
end

amplitud=zeros(4,maxpos);
fas=zeros(4,maxpos);

for t=1:maxpos
  if (lp(1,t)==1)==1
  
     pos=knum2cpos(t,mminj);
     rad=pos(1);
     kol=pos(2);
      
      
     lp(1,t)=0.25*( level1(rad,kol) + level1(rad,kol+1) + level1(rad+1,kol) + level1(rad+1,kol+1));
			
     lp(2,t)=0.25*( level2(rad,kol) + level2(rad,kol+1) + level2(rad+1,kol) + level2(rad+1,kol+1));

     lp(3,t)=0.25*( level3(rad,kol) + level3(rad,kol+1) + level3(rad+1,kol) + level3(rad+1,kol+1));

     lp(4,t)=0.25*( level4(rad,kol) + level4(rad,kol+1) + level4(rad+1,kol) + level4(rad+1,kol+1));
	
	
     amplitud(1,t)=skalfaktor*abs(lp(1,t));
     amplitud(2,t)=skalfaktor*abs(lp(2,t));
     amplitud(3,t)=skalfaktor*abs(lp(3,t));
     amplitud(4,t)=skalfaktor*abs(lp(4,t));
     
     fas(1,t)=angle(lp(1,t));
     fas(2,t)=angle(lp(2,t));
     fas(3,t)=angle(lp(3,t));
     fas(4,t)=angle(lp(4,t));
     	
  end
end

for t=1:maxpos
	if (lp(1,t)~=1)
	   	pos=knum2cpos(t,mminj);
		rad=pos(1);
		kol=pos(2);
	 	rad=rad+1;
	   	kol=kol+1;
	  	if detektor==1 | detektor==5
			npclinje(kol,rad,fas(1,t),amplitud(1,t))
		end		
		if detektor==2 | detektor==5
			npclinje(kol,rad,fas(2,t),amplitud(2,t))
		end		
		if detektor==3 | detektor==5
			npclinje(kol,rad,fas(3,t),amplitud(3,t))
		end		
		if detektor==4 | detektor==5
			npclinje(kol,rad,fas(4,t),amplitud(4,t))
		end
	end
end		







