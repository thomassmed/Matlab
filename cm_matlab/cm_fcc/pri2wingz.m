%@(#)   pri2wingz.m 1.2	 94/08/12     12:15:24
%
function pri2wingz(infil,buidclab,typ,bunclab,stav,enr,inut,burnclab,anm,unit);
fil=[infil,'.clab'];
disp(' ');
disp(['Input to Wingz will be printed on ',fil]);
fid=fopen(fil,'w');
ib=size(buidclab,1);
tab=9;setstr(tab);
%fprintf(fid,'\n');
%fprintf(fid,'\n%s%s\n\n\n\n',tab,unit);
%fprintf(fid,'%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s',tab,'Ident',tab,'Typ',tab,tab,'Projekt',tab,'Stavar',tab,'Anrikn.',tab,'Ins-Uttag',tab,'Utbr.',tab,'Box',tab,'Anm');
%fprintf(fid,'\n\n');
npage=fix(ib/17);
k=0;
for i=1:npage
   for j=1:17  
      k=k+1;
      fprintf(fid,'%s%6s%s%s%s%4s%s%i%s%5.2f%s',tab,buidclab(k,:),tab,typ(k,:),tab,bunclab(k,:),tab,stav(k),tab,enr(k),tab);
      fprintf(fid,'%s%s%6i%s%s%s%s\n',inut(k,:),tab,round(burnclab(k)),tab,'Ja',tab,anm(k,:));
   end
   fprintf(fid,'\n');
end
for j=1:ib-npage*17
   k=k+1;
   fprintf('%s%6s%s%4s%s%%i%s%f5.2%s',tab,buidclab(k,:),tab,typ(k,:),tab,bunclab(k,:),tab,stav(k,:),tab,enr(k),tab);
   fprintf('%s%s%6i%s%s%s%s\n',inut(k,:),tab,burnclab(k,:),tab,'Ja',tab,anm(k,:));
   fprintf(fid,'\n');
end
