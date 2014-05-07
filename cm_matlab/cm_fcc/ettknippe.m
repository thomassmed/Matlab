%@(#)   ettknippe.m 1.2	 94/08/12     12:15:02
%
bui=input('Ge knippe:','s');
bui=sprintf('%6s',bui);
num=bucatch(bui,BUIDNT);
priknippe(BUIDNT(num,:),BUNTYP(num,:),BUSYM(num,ITOT(num)*6-5:ITOT(num)*6),...
kinf(num),burnup(num),CYCNAM(ICYC(num,ITOT(num)),:),ITOT(num),...
ONSITE(num)*(1+(max(lastcyc)==lastcyc(num))),DISTFIL(1,:));
