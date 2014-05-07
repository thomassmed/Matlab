%@(#)   lng2comp.m 1.3	 97/02/27     16:49:15
%
%function lng2comp(cyc,lngsumfile,date,ttime,compfile,filtyp)
%
% Man måste stå i ett directory under /cm/fx vid körning
% Datum på formen yyyy-mm-dd  hh.mm.ss
% Tid för Xenon-transient (dygn)
% Filtyp kan vara lngsum (default), sum eller lngasc
function lng2comp(cyc,lngsumfile,date,ttime,compfile,filtyp)
if nargin<6, filtyp='lngsum';end
[xtid,pow,konrod,hc,tlowp,mminj]=lng2polca(cyc,lngsumfile,date,ttime,filtyp);
fid=fopen(compfile,'w');
tid=dat2tim([str2num(date(1:4)) str2num(date(6:7)) str2num(date(9:10)) str2num(date(13:14)) str2num(date(16:17))]);
fprintf(fid,'TITLE   Jämviktfall');
fprintf(fid,'\nMASFIL  ??');
fprintf(fid,'\nPRIFIL  ??');
fprintf(fid,'\nIDENT   ??');
fprintf(fid,'\nOPTION  POWER,TLOWP');
fprintf(fid,'\nINIT    ??=BURNUP');
fprintf(fid,'\nSAVE    ??=POWER,XENON,IODINE');
fprintf(fid,'\nPRINT');
fprintf(fid,'\nINCLUD  ??=BUNTYP');
fprintf(fid,'\nSUMFIL  ??=RESET');
fprintf(fid,'\nCONROD');
ascmap=crwd2ascmap(konrod(1,:),mminj,80);
for j=1:size(ascmap,1)
  fprintf(fid,'\n');
  fprintf(fid,ascmap(j,:));
end
fprintf(fid,'\nPROSIM  %5.1f,%7.0f, 70.0, 0.30,%6.1f',pow(1),hc(1),tlowp(1));
for i=1:length(xtid)
  ascmap=crwd2ascmap(konrod(i,:),mminj,80);
  fprintf(fid,'\nTITLE   Tidssteg %i',i);
  if i==1,fprintf(fid,'\nOPTION  TLOWP,XETRAN');end
  fprintf(fid,'\nCONROD');
  for j=1:size(ascmap,1)
    fprintf(fid,'\n');
    fprintf(fid,ascmap(j,:));
  end
  fprintf(fid,'\nPROSIM   %5.1f,%6.0f, 70.0, 0.3,%6.1f',pow(i),hc(i),tlowp(i));
  if i<length(xtid)
    fprintf(fid,'\nXETRAN   %5.2f',(xtid(i+1)-xtid(i))*24);
  else
    fprintf(fid,'\nXETRAN   %5.2f',(tid-xtid(i))*24);
  end
end
fprintf(fid,'\nEND\n');
fclose(fid);
