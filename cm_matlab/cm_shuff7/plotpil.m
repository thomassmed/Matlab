%@(#)   plotpil.m 1.1	 05/07/13     10:29:36
%
%
function plotpil(to,mminj,ready)
setprop(16,'off');
mu=zeros(size(to));
i=find(to>0);mu(i)=ones(size(i));
mu=mu.*(1-ready);
i=find(mu>0);
ct=knum2cpos(to(i),mminj)+0.5;
cf=knum2cpos(i,mminj)+0.25;
xl=[cf(:,2)';ct(:,2)'];
yl=[cf(:,1)';ct(:,1)'];
line(xl,yl,'color','black','erasemode','none');
hold on
plot(cf(:,2),cf(:,1),'ob');
hold off
