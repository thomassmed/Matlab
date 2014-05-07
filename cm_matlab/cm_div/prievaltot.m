%@(#)   prievaltot.m 1.7	 97/02/13     14:07:27
%
function prievaltot(unit,cycles,keffcc,globkeff,keffc,keofpc,nodc,radc,axc,chdevc);
fil=['eval-',unit,'-tot.lis'];
fid=fopen(fil,'w');
fprintf(fid,'\n\n\n');
fprintf(fid,'\t%s','Reactor');      
fprintf(fid,'\n');
fprintf(fid,'\t%s\t%s\t%5i',upper(unit));      
fprintf(fid,'\n\n');
fprintf(fid,'\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s','Cycle','Keff','Cold',' ','Keff','Hot','  ','TIP','nodal','RMS','TIP','radial','RMS','TIP','axial','RMS','Chann.','Flow');
fprintf(fid,'\n');
fprintf(fid,'\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s',' ','Global',' Aver ',' RMS ','EOFP','Aver',' RMS','Aver','Max','Min','Aver',' Max',' Min',' Aver',' RMS',' Max','std','Max','dev %');
ic=size(keffcc,1);
fprintf(fid,'\n');
for i=1:ic,
  fprintf(fid,'\t%3s',cycles(i,:));
  if globkeff(i)>0,
    fprintf(fid,'\t%.5f',globkeff(i));
  else
    fprintf(fid,'\t%7s','   -   ');
  end
  if mean(keffcc(i,:))>0,
    fprintf(fid,'\t%.5f\t%.5f',keffcc(i,:));
  else
    fprintf(fid,'\t   -   \t   -   ');
  end
  fprintf(fid,'\t%.5f\t%.5f\t%.5f',keofpc(i),keffc(i,:));
  fprintf(fid,'\t%4.1f\t%4.1f\t%4.1f',nodc(i,:));
  fprintf(fid,'\t%4.1f\t%4.1f\t%4.1f',radc(i,:));
  fprintf(fid,'\t%4.1f\t%4.1f\t%4.1f',axc(i,:));
  fprintf(fid,'\t%4.1f\t%4.1f\t%4.1f',chdevc(i,:));
  fprintf(fid,'\n');
end
fprintf(fid,'\n');
fprintf(fid,'\t%s','Aver');
igb=find(globkeff>0);
if length(igb)==0,
  fprintf(fid,'\t%s','   -   ');
else
  fprintf(fid,'\t%.5f',mean(globkeff(igb)));
end
ic=find(chdevc(:,1)>0);
icb=find(keffcc(:,1)>0);
fprintf(fid,'\t%.5f',mean(keffcc(icb,1)));
fprintf(fid,'\t%.5f',mean(keffcc(icb,2)));
fprintf(fid,'\t%.5f',mean(keofpc));
fprintf(fid,'\t%.5f',mean(keffc(:,1)));
fprintf(fid,'\t%.5f',mean(keffc(:,2)));
fprintf(fid,'\t%4.1f',mean(nodc(:,1)));
fprintf(fid,'\t%4.1f',mean(nodc(:,2)));
fprintf(fid,'\t%4.1f',mean(nodc(:,3)));
fprintf(fid,'\t%4.1f',mean(radc(:,1)));
fprintf(fid,'\t%4.1f',mean(radc(:,2)));
fprintf(fid,'\t%4.1f',mean(radc(:,3)));
fprintf(fid,'\t%4.1f',mean(axc(:,1)));
fprintf(fid,'\t%4.1f',mean(axc(:,2)));
fprintf(fid,'\t%4.1f',mean(axc(:,3)));
if length(ic)>0,
  fprintf(fid,'\t%4.1f',mean(chdevc(ic,1)));
  fprintf(fid,'\t%4.1f',mean(chdevc(ic,2)));
  fprintf(fid,'\t%4.1f',mean(chdevc(ic,3)));
else
  fprintf(fid,'\t%s\t%s\t%s','-','-','-');
end
fprintf(fid,'\n');
fprintf(fid,'\t%s','RMS');
igb=find(globkeff>0);
if length(igb)<2,
  fprintf(fid,'\t%s','   -   ');
else
  fprintf(fid,'\t%.5f',rms(globkeff(igb)-mean(globkeff(igb))));
end
fprintf(fid,'\t%.5f',rms(keffcc(icb,1)-mean(keffcc(icb,1))));
fprintf(fid,'\t%s',' ');
fprintf(fid,'\t%.5f',rms(keofpc-mean(keofpc)));
fprintf(fid,'\t%.5f',rms(keffc(:,1)-mean(keffc(:,1))));
if length(ic)>0,
  for ii=1:11, fprintf(fid,'\t');end
  fprintf(fid,'\t%4.1f',rms(chdevc(ic,2)));
  fprintf(fid,'\t%4.1f',rms(chdevc(ic,3)));
end
fprintf(fid,'\n');
fclose(fid);
