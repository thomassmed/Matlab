%@(#)   prievalcyc.m 1.6	 94/04/27     13:00:00
%
function prievalcyc(unit,cycle,date,pow,keff,dev,efph,hc,chdev,efboc,cckeff);
fil=['eval-',unit,'-',remblank(cycle),'.lis'];
fid=fopen(fil,'w');
fprintf(fid,'\n\n\n');
fprintf(fid,'\t%s\t%s\t%s','Reactor','Cycle','Total EFPH at start');      
fprintf(fid,'\n');
fprintf(fid,'\t%s\t%s\t%5i',upper(unit),upper(cycle),round(efboc));      
efph=efph-efboc;
fprintf(fid,'\n\n\n');
fprintf(fid,'\t%s','Cold Critical');
fprintf(fid,'\n');
fprintf(fid,'\t%s','Measurem.');
for i=1:length(cckeff),
  fprintf(fid,'\t%4i',i);
end
fprintf(fid,'\n\t%s','Keff     ');
for i=1:length(cckeff),
  fprintf(fid,'\t%.5f',cckeff(i));
end
fprintf(fid,'\n\n\n');
fprintf(fid,'\t%s\t%s\t%.5f','Keff','Aver.',mean(cckeff));
fprintf(fid,'\n');
fprintf(fid,'\t%s\t%s\t%.5f','    ','RMS',rms(cckeff-mean(cckeff)));
fprintf(fid,'\n');
fprintf(fid,'\t%s\t%s\t%.5f','    ','Max-Min',max(cckeff)-min(cckeff));
fprintf(fid,'\n');
fprintf(fid,'\n\n');
fprintf(fid,'\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s','TIP-','Meas.',' ',' ',' ','POLCA','-TIP','Dev.',' ',' ',' ','Chann.','Flow');
fprintf(fid,'\n');
fprintf(fid,'\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s','Date','EFPH','POWER','Core-','Keff','  Nodal',' ',' Radial',' ','    Axial');
fprintf(fid,'\n');
fprintf(fid,'\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s',' ','    ','     ','Flow','    ',' RMS',' Max',' RMS',' Max',' RMS',' Max',' Std',' Max','dev %');
ic=length(keff);
fprintf(fid,'\n');
for i=1:ic,
  fprintf(fid,'\t%6s',date(i,:));
  fprintf(fid,'\t%i',round(efph(i)));
  fprintf(fid,'\t%.1f',pow(i)*100);
  fprintf(fid,'\t%5i',round(hc(i)));
  fprintf(fid,'\t%.5f',keff(i));
  for j=1:6,
    fprintf(fid,'\t%5.1f',dev(i,j));
  end
  for j=1:3,
    if chdev(i,j)==0,
      fprintf(fid,'\t%5s','  -  ');
    else
      fprintf(fid,'\t%5.2f',chdev(i,j));
    end
  end
  fprintf(fid,'\n');
end
fprintf(fid,'\n');
fprintf(fid,'\t%s\t\t\t\t%.5f','Aver',mean(keff));
ich=find(chdev(:,1)>0);
if length(ich)==0,ich=1;end
for i=1:6,
  fprintf(fid,'\t%5.1f',mean(dev(:,i)));
end
if all(chdev(:,1)==0),
  fprintf(fid,'\t%5s','  -  ');
  fprintf(fid,'\t%5s','  -  ');
  fprintf(fid,'\t%5s','  -  ');
else
  for i=1:3,
    fprintf(fid,'\t%5.1f',mean(chdev(ich,i)));
  end
end
fprintf(fid,'\n');
fprintf(fid,'\t%s\t\t\t\t%.5f','Max',max(keff));
for i=1:6,
  fprintf(fid,'\t%5.1f',max(abs(dev(:,i))));
end
if all(chdev(:,1)==0),
  fprintf(fid,'\t%5s','  -  ');
  fprintf(fid,'\t%5s','  -  ');
  fprintf(fid,'\t%5s','  -  ');
else
  for i=1:3,
    fprintf(fid,'\t%5.1f',max(abs(chdev(ich,i))));
  end
end
fprintf(fid,'\n');
fprintf(fid,'\t%s\t\t\t\t%.5f','Min',min(keff));
for i=1:6,
  fprintf(fid,'\t%5.1f',min(abs(dev(:,i))));
end
if all(chdev(:,1)==0),
  fprintf(fid,'\t%5s','  -  ');
  fprintf(fid,'\t%5s','  -  ');
  fprintf(fid,'\t%5s','  -  ');
else
  for i=1:3,
    fprintf(fid,'\t%5.1f',min(abs(chdev(ich,i))));
  end
end
fprintf(fid,'\n');
fprintf(fid,'\t%s\t\t\t\t%.5f','RMS',rms(keff-mean(keff)));
for i=1:6,
  fprintf(fid,'\t%5.1f',rms(dev(:,i)-mean(dev(:,i))));
end
if all(chdev(:,1)==0),
  fprintf(fid,'\t%5s',' -  ');
  fprintf(fid,'\t%5s',' -  ');
  fprintf(fid,'\t%5s',' -  ');
else
  for i=1:3,
    fprintf(fid,'\t%5.1f',rms(chdev(ich,i)-mean(chdev(ich,i))));
  end
end
fprintf(fid,'\n');
fclose(fid);
