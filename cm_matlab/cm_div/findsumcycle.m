%@(#)   findsumcycle.m 1.2   05/12/08     15:55:24
%function sumfiles=findsumcycle(cycles,sumtemp)
function sumfiles=findsumcycle(cycles,sumtemp)
ic=size(cycles,1);
sumfiles=zeros(ic,size(sumtemp,2));

for i=1:size(sumtemp,1),
  id=find(sumtemp(i,:)=='/');
  cykel=sumtemp(i,id(3)+1:id(4)-1);
  cykel=[cykel setstr(32*ones(1,size(cycles,2)-length(cykel)))];
  ib=findstring(cykel,cycles);
  if length(ib)>0,
     sumfiles(ib,:)=sumtemp(i,:);
  end 
end   
