%@(#)   seklista.m 1.3	 01/04/05     13:32:02
%function seklista(sumfil,sekvens,block)
%ex seklista('sum.dat','19v-10','F2')
%default är utskrift på seklista.lis
function seklista(sumfil,sekvens,block)

  
sumfilsdata=sum2mlab7(sumfil);
keff=(sumfilsdata(14,:));
ssmonster=(sumfilsdata(51,:));
fl_lhgr1=(sumfilsdata(25,:));
fl_cpr1=(sumfilsdata(26,:));
ppf=(sumfilsdata(19,:));
effekt=(sumfilsdata(9,:))*100;
flotot=(sumfilsdata(10,:));
efphcyc=(sumfilsdata(82,:));
temp=(sumfilsdata(11,:));

% pcm/monster

for i= 2:length(keff)
	ssmonsterpcm(i)=((keff(i)-keff(i-1)))*100000';
end

rad1=['1     - SEKVENSBERAKNING   ',block,' SEKVENS    ',sekvens];
rad2='        -------------------------------------------------------------';
rad3='EFFEKT:          ', effekt(1),' %';              
rad4='HC-FLODE:        ', flotot(1),'  kg/s';
rad5='TEMP:            ', temp(1),'  C';                        
rad6='UTBRANNING:      ',efphcyc(1),' EFPH';                
rad7='        SSUM  pcm/monster  Keff   FL_LHGR    FL_CPR     PPF';
rad8='          %%       -          -      %%          %%         - ';
antal=1;

% skriva till fil
prifil='seklista.lis';
fid=fopen(prifil,'w');

%skapa filhuvud

sidor=ceil(length(keff)/36);
for b=1:sidor;
	fprintf(fid,'%23s%3s%27s%12s\n','1       - SEKVENSBERAKNING   ',block,' SEKVENS    ',sekvens);
	fprintf(fid,'        -------------------------------------------------------------'); fprintf(fid,'\n');
	fprintf(fid,'%33s%3.1f%5s\n','EFFEKT:           ', effekt(1),' %');
	fprintf(fid,'%33s%5.0f%5s\n','HC-FLODE:         ', flotot(1),'  kg/s');
	fprintf(fid,'%33s%3.1f%5s\n','TEMP:             ', temp(1),'  C');
	fprintf(fid,'%33s%5.0f%6s\n','UTBRANNING:       ',efphcyc(1),' EFPH');
        fprintf(fid,'%37s%1.0f','    MÖNSTER PER POLCAFALL:',antal);
	fprintf(fid,'\n');
	fprintf(fid,rad2); fprintf(fid,'\n');
	fprintf(fid,rad7); fprintf(fid,'\n');
	fprintf(fid,rad8); fprintf(fid,'\n');
	fprintf(fid,rad2); fprintf(fid,'\n');
	fprintf(fid,'\n');
	   for a=((36*b)-35):(36*b);
           	if length(keff)<a; break;end;
		fprintf(fid,'%13.0f%7.0f%11.5f%9.3f%11.3f%9.2f\n',ssmonster(a),ssmonsterpcm(a),keff(a),fl_lhgr1(a),fl_cpr1(a),ppf(a));
	   end	
end
fclose(fid);
