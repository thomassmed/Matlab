%@(#)   preed7.m 1.4	 09/05/05     07:47:48
%
function preed7(i,par)
hval=get(gcf,'userdata');
load sim/simfile;
if ~exist('sdmfiles','var'),sdmfiles=[];end
efph=str2num(get(hval(21),'string'));
point=find(efph==blist);
if i<9                                            % Ändra manövergrupp
  g=zeros(1,8);
  w=100*ones(1,8);
  k=find(conrod(point,:)==',');
  j=find(conrod(point,:)=='=');
  k=[0 k length(conrod(point,:))+1];
  for ii=1:length(j)
    g(ii)=str2num(conrod(point,k(ii)+1:j(ii)-1));
    w(ii)=str2num(conrod(point,j(ii)+1:k(ii+1)-1));
  end
  s=str2num(get(hval(i),'string'));
  if isempty(s),g(i)=0;else g(i)=s;end
  r='';
  for ii=1:8
    if g(ii)~=0
      r=[r ',' num2str(g(ii)) '=' num2str(w(ii))];
    end
  end
  sc=size(conrod);
  if length(r)-1>sc(2),conrod=[conrod setstr(32*ones(sc(1),length(r)-1-sc(2)))];end
  if length(r)-1<sc(2),r=[r setstr(32*ones(1,sc(2)-length(r)+1))];end
  conrod(point,:)=r(2:length(r));
  save sim/simfile conrod bustep tlowp hc pow filenames sdmfiles mangrpfile blist bocfile;
end
if (i>8 & i<17) | (i>21 & i<30)                   % Ändra Styrstavsläge
  g=zeros(1,8);
  w=100*ones(1,8);
  k=find(conrod(point,:)==',');
  j=find(conrod(point,:)=='=');
  k=[0 k length(conrod(point,:))+1];
  for ii=1:length(j)
    g(ii)=str2num(conrod(point,k(ii)+1:j(ii)-1));
    w(ii)=str2num(conrod(point,j(ii)+1:k(ii+1)-1));
  end
  if i>21 & i<30
    svalue=get(hval(i),'value');
    if svalue>1-w(i-21)/100 & svalue<=1
      while svalue>1-w(i-21)/100,w(i-21)=w(i-21)-1;end
      svalue=1-w(i-21)/100;
      set(hval(i),'value',svalue);
      set(hval(i-13),'string',num2str(100-100*svalue));
    end
    if svalue<1-w(i-21)/100 & svalue>=0
      while svalue<1-w(i-21)/100,w(i-21)=w(i-21)+1;end
      svalue=1-w(i-21)/100;
      set(hval(i),'value',svalue);
      set(hval(i-13),'string',num2str(100-100*svalue));
    end
    i=i-13;
  end
  s=str2num(get(hval(i),'string'));
  if isempty(s),w(i-8)=100;else w(i-8)=s;set(hval(i),'value',1-w(i-8)/100);end
  r='';
  for ii=1:8
    if g(ii)~=0
      r=[r ',' num2str(g(ii)) '=' num2str(w(ii))];
    end
  end
  sc=size(conrod);
  if length(r)-1>sc(2),conrod=[conrod setstr(32*ones(sc(1),length(r)-1-sc(2)))];end
  if length(r)-1<sc(2),r=[r setstr(32*ones(1,sc(2)-length(r)+1))];end
  conrod(point,:)=r(2:length(r));
  save sim/simfile bustep conrod tlowp hc pow filenames sdmfiles mangrpfile blist bocfile;
end
if i>16 & i<21
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
  save sim/simfile bustep conrod tlowp hc pow filenames sdmfiles mangrpfile blist bocfile;
end
if i==21 | i==30
  if i==30
    svalue=get(hval(30),'value');
%    if svalue>blist(point)/blist(length(blist)-1)
    if svalue>(point-1)/(length(blist)-2)
%      while svalue>blist(point)/blist(length(blist)-1),point=point+1;end
      while svalue>(point-1)/(length(blist)-2),point=point+1;end
%      svalue=blist(point)/blist(length(blist)-1);
      svalue=(point-1)/(length(blist)-2);
      set(hval(30),'value',svalue);
    end
%    if svalue<blist(point)/blist(length(blist)-1)
    if svalue<(point-1)/(length(blist)-2)
%      while svalue<blist(point)/blist(length(blist)-1),point=point-1;end
      while svalue<(point-1)/(length(blist)-2),point=point-1;end
%      set(hval(30),'value',blist(point)/blist(length(blist)-1));
      set(hval(30),'value',(point-1)/(length(blist)-2));
    end
  end
  g=[];
  w=[];
  i=find(conrod(point,:)==',');
  j=find(conrod(point,:)=='=');
  i=[0 i length(conrod(point,:))+1];
  for ii=1:length(j)
    g=[g str2num(conrod(point,i(ii)+1:j(ii)-1))];
    w=[w str2num(conrod(point,j(ii)+1:i(ii+1)-1))];
  end
  for ii=1:8
    if ii<=length(g)
      set(hval(ii),'string',num2str(g(ii)));
      set(hval(ii+8),'string',num2str(w(ii)));
      set(hval(ii+21),'value',1-w(ii)/100);
    else
      set(hval(ii),'string','');
      set(hval(ii+8),'string','');
      set(hval(ii+21),'value',0);
    end
  end
  set(hval(19),'string',tlowp(point,:));
  set(hval(18),'string',hc(point,:));
  set(hval(17),'string',pow(point,:));
  set(hval(30),'value',(point-1)/(length(blist)-2));
  set(hval(21),'String',num2str(blist(point)));
  set(hval(20),'String',mangrpfile);
end

if exist('polcacmd')
  save -append sim/simfile polcacmd
end