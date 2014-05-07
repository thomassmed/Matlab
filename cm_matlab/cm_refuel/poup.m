%@(#)   poup.m 1.3	 94/03/16     14:39:51
%
function poup
h=get(gcf,'userdata');
hpar=h(length(h));
hand=get(hpar,'userdata');
pool=get(hand(111),'userdata');
pos=str2num(pool(size(pool,1),:));
pos=pos-1;
pool=pool(1:size(pool,1)-1,:);
if pos>0
  for i=pos:pos+17
    set(h(i-pos+42),'string',sprintf('%4s%7s%8s',pool(size(pool,1)-i+1,14:17),pool(size(pool,1)-i+1,8:13),pool(size(pool,1)-i+1,1:7)))
  end
end
if pos==0,pos=1;end
s='00000000000000000';
s(18-length(num2str(pos)):17)=num2str(pos);
pool(size(pool,1)+1,:)=s;
set(hand(111),'userdata',pool)
