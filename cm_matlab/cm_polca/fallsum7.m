%@(#)   fallsum7.m 1.2	 06/01/02     15:39:20
%
%function fallsum7('sumfil',cases,crnums,'infil');
function fallsum7(sumfil,cases,crnums,infil);
tx=readtextfile(infil);
i=bucatch('PRIFIL',tx(:,1:6));
[t,n]=sscanf(tx(i,:),'%s');
printfile=t(7:length(t));
i=bucatch('REFDIS',tx(:,1:6));
[t,n]=sscanf(tx(i,:),'%s');
disfil=t(7:length(t));
[d,mminj]=dist2mlab7(disfil);
fid=fopen(printfile,'w');
s=sum2mlab7(sumfil);
ind=1;
fprintf(fid,'%10s %10s %10s %10s\n\n','Monster','Max pcm','Stav','keff');
for cas=1:length(cases)
   k=s(14,ind:ind+cases(cas)-1);
   [km,mpos]=min(k(2:cases(cas)));
   cr=crpos2axis(crnums(ind+mpos-cas,:),0);
   delta=1e5*(k(1)-km)/k(1);
   patt=s(51,ind);
   if cas==1, wpatt=patt; wdelta=delta; wcr=cr;end
   if delta > wdelta, wpatt=patt; wdelta=delta; wcr=cr;end
   fprintf(fid,'%10.0f %10.0f %10s %10.5f\n',patt,delta,cr,k(1));
   ind=ind+cases(cas);
end
fprintf(fid,'\n*%9.0f %10.0f %10s\n',wpatt,wdelta,wcr);
fclose(fid);
