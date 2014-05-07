function [nfl,flnr,kpunkt]=racsb2flow(b)
% [nfl,flnr]=racsb2lflow(b)
nyrad=findstr(b,10);
nnfl=findstr(b,'211K3');
for i=1:length(nnfl),
    knr=str2num(b(nnfl(i)+4:nnfl(i)+6));
    nrtest=ceil((knr-800)/4);
    if nrtest<37,
      flnr(i)=ceil((knr-800)/4);
      nfl(i)=max(find(nnfl(i)>nyrad))-1;
      kpunkt(i,:)=b(nnfl(i):nnfl(i)+6);
    end
end
