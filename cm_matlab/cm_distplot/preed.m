%@(#)   preed.m 1.3	 98/04/15     13:36:30
%
function preed(i,par)
hval=get(gcf,'userdata');
load simfile;
efph=str2num(get(hval(6),'string'));
point=find(efph==blist);
if i~=6
  str=get(hval(i),'string');
  evsiz=sprintf('%s%s%s','s=size(',par,');');
  eval(evsiz);
  ld=length(str)-s(2);
  if ld>0
    evstr=sprintf('%s%s%s%s',par,'=[',par,' setstr(32*ones(s(1),ld))];');
    eval(evstr);
  end
  eval(evsiz);
  evstr=sprintf('%s%s%s',par,'(point,:)=setstr(32*ones(1,s(2)));');
  eval(evstr);
  evstr=sprintf('%s%s%s',par,'(point,1:length(str))=str;');
  eval(evstr);
  save simfile conrod tlowp hc pow filenames blist bocfile;
else
  set(hval(1),'string',conrod(point,:));
%  set(hval(2),'string',bustep(point,:));
  set(hval(3),'string',tlowp(point,:));
  set(hval(4),'string',hc(point,:));
  set(hval(5),'string',pow(point,:));
end
