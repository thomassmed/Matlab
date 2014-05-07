%@(#)   uxstr2mat.m 1.1	 97/02/04     10:40:03
%
%function mat=uxstr2mat(str)
function mat=uxstr2mat(str)
i=find(abs(str)==10);
i=[0 i];
mat=32*ones(length(i)-1,max(diff(i))-1);
for j=2:length(i)
  mat(j-1,1:i(j)-i(j-1)-1)=str(i(j-1)+1:i(j)-1);
end
