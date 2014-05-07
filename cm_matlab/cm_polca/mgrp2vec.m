%function vec=mgrp2vec(mangrpfile)
function vec=mgrp2vec(mangrpfile)
fid=fopen(mangrpfile,'r');
while 1
  rad=fgetl(fid);
  if rad==-1,break;end
  if strcmp('MANGRP',rad(1:6))
    i=find(rad=='=');
    j=find(rad==',');
    ll=length(rad);
    m=remblank(rad(8:i-1));
    j=[i j length(rad)+1];
    for k=2:length(j)
      ind=str2num(rad(j(k-1)+1:j(k)-1));
      vec(ind)=str2num(m);
    end
  end
end
fclose(fid);
