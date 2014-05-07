%@(#)   prilhgr.m 1.3	 97/02/13     14:33:21
%
function prilhgr(fil,wchannel,mminj,wtyp,typ,buntyp,LHGR,BURN,NOD,FLPD,STRAFF,DBURN,crstr,efph,titel)
if isstr(fil),
  fid=fopen(fil,'w');
  clos=1;
else
  fid=fil;
  clos=0;
end
if nargin>6,
  fprintf(fid,'\n');
  fprintf(fid,'\t%s',titel);
  fprintf(fid,'\n');
end
[nefph,ncr]=size(LHGR);
fprintf(fid,'\n');
fprintf(fid,'%s','EFPH');
fprintf(fid,'%10i',round(efph));
if length(STRAFF)>1, strafflag=1;else,strafflag=0;end
for i=1:ncr,
  wcpos=knum2cpos(wchannel(:,i),mminj);
  fprintf(fid,'\n\n%s',crstr(i,:));
  fprintf(fid,'\n%s\t','i,j,k');
  for j=1:nefph,
    fprintf(fid,'%2i,%2i,%2i  ',wcpos(j,1),wcpos(j,2),NOD(j,i));
  end
  fprintf(fid,'\n%s','TYP');
  for j=1:nefph,
    fprintf(fid,'%10s',buntyp(wchannel(j,i),:));
  end
  fprintf(fid,'\n%s','LHGR');
  fprintf(fid,'%10i',round(LHGR(:,i)));
  fprintf(fid,'\n%s','BURN');
  fprintf(fid,'%10i',round(BURN(:,i)));
  fprintf(fid,'\n%s','FLPD');
  fprintf(fid,'%10.3f',FLPD(:,i));
  if strafflag>0,
    fprintf(fid,'\n%s','Ostraffat');
    fprintf(fid,'%5.3f',FLPD(1,i)*STRAFF(1,i));
    fprintf(fid,'%10.3f',FLPD(2:nefph,i).*STRAFF(2:nefph,i));
    fprintf(fid,'\n%s','SSBURN');
    fprintf(fid,'%8i',round(DBURN(1,i)));
    fprintf(fid,'%10i',round(DBURN(2:nefph,i)));
  end
end
fprintf(fid,'\n');
if clos==1,
  fclose(fid);
end
