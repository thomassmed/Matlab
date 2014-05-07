%@(#)   patroninfo.m 1.2	 10/09/21     15:47:29
%
function patroninfo(fx,id)
% patroninfo(fx,id)

%indata
eocfil=['/cm/' fx '/div/multi/eocfiles'];
a=readtipfiles(eocfil);

prifil=[id,'.txt'];
fid=fopen(prifil,'w');
fprintf(fid,'\n');
fprintf(fid,['PATRONDATA   ']);
fprintf(fid,id);
fprintf(fid,'\n');
fprintf(fid,'\n');
fprintf(fid,['CYCLE    BURNUP   KANNR']);
fprintf(fid,'\n');

for i =1:length(a);
  disfil=a(i,:);
  s=find(disfil=='/');
  cycle=disfil(s(3)+1:s(4)-1);
  
  [asyid,mminj,konrod,bb,hy,mz,ks]=readdist7(disfil,'asyid');
  
  if isempty(strmatch(id,asyid))
  else 
    %från polca7
    burnup=(readdist7(disfil,'burnup'))*1000;
    asyid=(readdist7(disfil,'asyid'));
    kannr=strmatch(id,asyid);
    burnup=burnup';

    % skriva till fil
    fprintf(fid,'%5s  %8.0f\t   %4.0f\n',cycle,mean(burnup(kannr,:)), kannr);
  end
end

fclose(fid);
text=['informationen levereras på fil ' id '.txt'];
disp(text);



