function [black,white,test]=super_chess(mminj,offset)
if nargin<2, offset=0;end
kan=sum(length(mminj)-2*(mminj-1));
j=(1:kan)';
ij=knum2cpos(j,mminj);
ij(:,1)=ij(:,1)+2*(offset>0);
test=4*mod(ij(:,1),2)+mod(ij(:,1)+ij(:,2),4);
for i=1:4,
    white{i}=find(test==1+(i-1)*2);
    black{i}=find(test==(i-1)*2);
end
