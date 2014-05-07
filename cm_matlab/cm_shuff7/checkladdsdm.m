%@(#)   checkladdsdm.m 1.1	 05/07/13     10:29:28
%
%
%function ok=checkladdsdm(resultfil,bocfil)
%Checks ALL bundle moves in laddsdm w.r.t:
%       1) destination channel number (as compared to boc-file)
%       2) control rod withdrawal
function ok=checkladdsdm(resultfil,bocfil)
[buidnt,mminj]=readdist7(bocfil,'asyid');
fid=fopen(resultfil);
fprintf('%s\n','Results will be printed on checkladdsdm.results');
fid1=fopen('checkladdsdm.results','w');
for i=1:1000,
  [ok(i),bumove(i,:)]=checkbp(fid,fid1,buidnt,mminj);
  if ok(i)==-1, break;end
  if i/100==round(i/100), 
     ifel=find(ok==0);
     itot=length(ifel);
     fprintf('%i%s%i%s\n',i,' moves checked, ',itot,' errors found');
  end
end
ok=ok(1:i-1);
ifel=find(ok==0);
fprintf('\n%s\n','***************  SUMMARY OF RESULTS *************');
if length(ifel)>0,
  for i=1:length(ifel),
    fprintf('%s%4i%s%s\n','Error in move ',ifel(i),' Buidnt: ',bumove(ifel(i),:));
  end
else
  fprintf('%s\n','No errors found');
end
fclose(fid);
end
