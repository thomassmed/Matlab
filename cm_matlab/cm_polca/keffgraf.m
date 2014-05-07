%@(#)   keffgraf.m 1.1	 01/01/24     13:08:53
%
%function keffgraf(sumfile,efphstart)
function keffgraf(sumfile,efphstart)
if nargin<2,efphstart=0;end
figure;
s=sum2mlab7(sumfile);
subplot(2,1,1)
plot(s(82,:)+efphstart,s(14,:))
axis([0 8000 0.99 1.01]);
title('k-effektiv')
xlabel('EFPH')
grid
subplot(2,1,2)
j=0;
e=s(82,:);
k=zeros(1,size(s,2)/2-1);
for i=1:2:size(s,2)-3
  j=j+1;
  k(j)=1e5*(s(14,i+1)-s(14,i))/(s(82,i+1)-s(82,i));
end
plot(e(1:2:size(s,2)-2)+efphstart,k)
axis([0 8000 -2 1]);
ylabel('pcm/EFPH')
xlabel('EFPH')
title('Utbränningskoefficient')
grid
