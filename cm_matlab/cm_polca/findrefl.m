%@(#)   findrefl.m 1.1	 05/12/08     12:17:38
%
%function krefl=findrefl(mminjrefl);
function krefl=findrefl(mminjrefl);
kanr(1)=length(mminjrefl)-2*mminjrefl(1)+2;
kanl(1)=1;
hr=[];hl=[];
for i=2:length(mminjrefl)
  kanr(i)=sum([kanr(i-1) length(mminjrefl)-2*mminjrefl(i)+2]);
  kanl(i)=kanr(i-1)+1;
  d=mminjrefl(i)-mminjrefl(i-1);
  if d<0
    hr=[hr kanr(i)+d:kanr(i)-1];
    hl=[hl kanl(i)+1:kanl(i)-d];
  end
  if d>0
    hr=[hr kanr(i-1)-d:kanr(i-1)-1];
    hl=[hl kanl(i-1)+1:kanl(i-1)+d];
  end
end
krefl=[kanr kanl hr hl kanl(1)+1:kanr(1)-1 kanl(end)+1:kanr(end)-1];
