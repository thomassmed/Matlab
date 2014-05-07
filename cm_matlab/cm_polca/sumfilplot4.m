%@(#)   sumfilplot4.m 1.1	 01/10/09     15:12:52
%
%function sumfilplot4(sumfil,starttid,sluttid)
function sumfilplot4(sumfil,starttid,sluttid)
s=sum2mlab(sumfil);
t1=dat2tim(starttid);
t2=dat2tim(sluttid);
man=['Jan';'Feb';'Mar';'Apr';'Maj';'Jun';'Jul';'Aug';'Sep';'Okt';'Nov';'Dec'];
ind=1;x=[];y=[];
for i=1:size(s,2)
  tsum=dat2tim([s(6,i) s(5,i) s(4,i) s(3,i) s(2,i)]);
  if tsum>=t1 & tsum<=t2
    x(ind)=tsum;
    y(ind)=s(9,i)*100;
    ind=ind+1;
  end
end
plot(x,y);
label=[];
xt=get(gca,'xtick');
ll=length(xt);
while ll>6, xt=xt(1:2:length(xt));ll=length(xt);end
set(gca,'xtick',xt);
for i=1:length(xt)
  xtick=tim2dat(xt(i));
  label=[label; sprintf('%2i%3s %2i:%2i',xtick(3),man(xtick(2),:),xtick(4),xtick(5))];
end
ylabel('Power %');
set(gca,'xticklabel',label);
grid;
