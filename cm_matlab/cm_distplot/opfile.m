%@(#)   opfile.m 1.5	 05/12/08     08:32:56
%
function opfile
p7=0;
handles=get(gcf,'userdata');
hfil=handles(1);
distfile=get(hfil,'string');
distfile=distfile(1,:);
[dist,mminj,konrod,bb,hy,mz,ks,asytyp,asyref,distlist,...
staton,masfil,rubrik,detpos,fu,op,au,flopos,soufil]=readdist7(distfile);
test=get(handles(21),'userdata');
if size(test,2)~=mz(14)
  set(handles(21),'userdata',ones(1,mz(14)));
  set(handles(22),'userdata',ones(3,mz(14)));
  set(handles(24),'userdata',ones(1,mz(14)));
end
[li,lj]=size(distlist);
if lj==8,p7=1;end
if p7==0
  hpl=handles(2);
  h1=handles(6);
  hc=get(h1,'children');
  delete(hc);
  hsub1=uimenu(h1,'label','MATLAB','callback','MATLABvar');
  set(h1,'userdata',hsub1);
  if li>24,hsub1(2)=uimenu(h1,'label','more dist');ex=1; else ex=0;end
  for i=1+ex:li,
    dname=distlist(i,:);
    if i<25,hsub1(i+1)=uimenu(h1,'label',dname,'callback','init;');
    else hsub1(i+1)=uimenu(hsub1(2),'label',dname,'callback','init;');end
  end
  ud=get(hpl,'userdata');
  ud=str2mat(ud(1:4,:),distfile,ud(6:size(ud,1),:));
  set(hpl,'userdata',ud);
  statinfo=get(handles(61),'userdata');
  ml=size(statinfo,2);
  if ml==0 
    nod=['1:',num2str(mz(11))];
    ud=str2mat(ud(1:14,:),nod,ud(16:size(ud,1),:));
    set(hpl,'userdata',ud);
    [map,mpos]=cr2map(konrod,mminj);
    set(handles(31),'userdata',mpos);
    [psc,pcn]=plotcont(hpl,mminj,0);
    set(handles(34),'userdata',psc);
    set(handles(35),'userdata',pcn);
    set(gcf,'userdata',handles);
  elseif ~strcmp(statinfo(1:ml),staton)
    [map,mpos]=cr2map(konrod,mminj);
    set(handles(31),'userdata',mpos);
    [psc,pcn]=plotcont(hpl,mminj,0);
    set(handles(34),'userdata',psc);
    set(handles(35),'userdata',pcn);
    set(gcf,'userdata',handles);
  end
end
if p7==1
  noplot = [ 'FISID1  ';'FISID2  ';'FICOR1  ';'FICOR2  ';'CUSID1  ';...
  'CUSID2  ';'SCOR1   ';'SCOR2   ';'BURSID  ';'BURCOR  ';'FLWBYP  ';...
  'DNSBYP  ';'TMPBYP  ';'VOIBYP  ';'STQBYP  ';'ENTBYP  ';'PRSBYP  ';...
  'POWBYP  ';'ASYTYP  ';'ASYID   ';'CONDPR  ';'PCILHGR ';'PCIVIOL ';...
  'DETID   ';'DETTYP  ';'CRID    ';'CRTYP   ';'CRDENS  ';'BOXFLU  ';...
  'PINPOW  ';'PINLHR  ';'PINFIM  ';'PINBUR  ';'PINDRY  ';'PINBA140';...
  'PININD  ';'RAMALB  ';'RAMCOF  ';'RAMDISF '];
  isotop = [ 'U235    ';'U236    ';'U238    ';'PU238   ';'PU239   ';...
  'PU240   ';'PU241   ';'PU242   ';'AM241   ';'AM242   ';'NP239   ';...
  'RU103   ';'RH103   ';'RH105   ';'CE143   ';'PR143   ';'ND143   ';...
  'ND147   ';'PM147   ';'PM148   ';'PM148M  ';'PM149   ';'SM147   ';...
  'SM149   ';'SM150   ';'SM151   ';'SM152   ';'SM153   ';'EU153   ';...
  'EU154   ';'EU155   ';'GD155   ';'BAEFF   ';'BA140   ';'LA140   ';...
  'IODINE  ';'XENON   '];
  tm     = [ 'LHGR    ';'LHGR_PEL';'APLHGR  ';'SHF     ';'CPR     ';...
  'CPR_STAT';'FL_LHGR1';'FL_LHGR2';'FL_LHGR3';'FL_APLHG';'FL_SHF  ';...
  'FL_CPR  ';'FL_DNB  ';'THMARG  ';'CPRMOD  ';'LHGRMOD ';...
  'ALHGRMOD';'CONDPR  ';'PCILHGR ';'PCIVIOL ';'PCIMAX  ';'PCIRATE ';...
  'PCIMARG '];
  sond   = [ 'DETID   ';'DETTYP  ';'PRMNEU  ';'PRMMEA  ';'TIPNEU  ';...
  'TIPGAM  ';'TIPMEA  ';'TIPCOR  ';'TIPMC   ';'TIPNG   ';'TIPFI1  ';...
  'TIPFI2  ';'PRMEFPH ';'PRMU234 ';'PRMU235 ';'PRMUCAL ';'PRMCACOR'];
  cr     = [ 'CRID    ';'CRTYP   ';'CRWDR   ';'CRDENS  ';'CREFPH  ';...
  'CRDEPL  ';'CRDMAX  ';'CRFLUE  ';'SDM     ';'SDM3D   '];
  th     = [ 'CHFLOW  ';'FLWORI  ';'FLWFUE  ';'FLWWC   ';'FLWHOL  ';...
  'LEKBP2  ';'LEKBP3  ';'DENS    ';'TMOD    ';'TINLET  ';'TOUTL   ';...
  'VOID    ';'STQUAL  ';'STQOUT  ';'NESTQUAL';'ENTHAL  ';'TFUEL   ';...
  'BORC    ';'PRESS   ';'DPBOX   ';'DPWCWALL';'FLWBYP  ';'DNSBYP  ';...
  'TMPBYP  ';'VOIBYP  ';'STQBYP  ';'ENTBYP  ';'PRSBYP  ';'POWBYP  ';...
  'THRES   ';'BUNLIFT '];
  i=mbucatch(noplot,distlist);
  i=i(find(i));
  distlist(i,:)=[];
  i=mbucatch(isotop,distlist);
  i=i(find(i));
  list=distlist(i,:);
  distlist(i,:)=[];
  hpl=handles(2);
  h1=handles(6);
  hc=get(h1,'children');
  delete(hc);
  h=uimenu(h1,'label','MATLAB','callback','MATLABvar');
  set(h1,'userdata',h);
  if ~isempty(list),hsub=uimenu(h1,'label','Isotop');end
  for i=1:size(list,1),
    dname=list(i,:);
    h=uimenu(hsub,'label',dname,'callback','init;');
  end
  i=mbucatch(tm,distlist);
  i=i(find(i));
  list=distlist(i,:);
  distlist(i,:)=[];
  if ~isempty(list),hsub=uimenu(h1,'label','Margins');end
  for i=1:size(list,1)
    dname=list(i,:);
    h=uimenu(hsub,'label',dname,'callback','init;');
  end
  i=mbucatch(sond,distlist);
  i=i(find(i));
  list=distlist(i,:);
  distlist(i,:)=[];
  if ~isempty(list),hsub=uimenu(h1,'label','Sond');end
  for i=1:size(list,1)
    dname=list(i,:);
    h=uimenu(hsub,'label',dname,'callback','init;');
  end
  i=mbucatch(cr,distlist);
  i=i(find(i));
  list=distlist(i,:);
  distlist(i,:)=[];
  if ~isempty(list),hsub=uimenu(h1,'label','CRod');end
  for i=1:size(list,1)
    dname=list(i,:);
    h=uimenu(hsub,'label',dname,'callback','init;');
  end
  i=mbucatch(th,distlist);
  i=i(find(i));
  list=distlist(i,:);
  distlist(i,:)=[];
  if ~isempty(list),hsub=uimenu(h1,'label','TH');end
  for i=1:size(list,1)
    dname=list(i,:);
    h=uimenu(hsub,'label',dname,'callback','init;');
  end
  for i=1:size(distlist,1),
    dname=distlist(i,:);
    h=uimenu(h1,'label',dname,'callback','init;');
  end
  ud=get(hpl,'userdata');
  ud=str2mat(ud(1:4,:),distfile,ud(6:size(ud,1),:));
  set(hpl,'userdata',ud);
  statinfo=get(handles(61),'userdata');
  ml=size(statinfo,2);
  if ml==0 
    nod=['1:',num2str(mz(11))];
    ud=str2mat(ud(1:14,:),nod,ud(16:size(ud,1),:));
    set(hpl,'userdata',ud);
    [map,mpos]=cr2map(konrod,mminj);
    set(handles(31),'userdata',mpos);
    [psc,pcn]=plotcont(hpl,mminj,0);
    set(handles(34),'userdata',psc);
    set(handles(35),'userdata',pcn);
    set(gcf,'userdata',handles);
  elseif ~strcmp(statinfo(1:ml),staton)
    [map,mpos]=cr2map(konrod,mminj);
    set(handles(31),'userdata',mpos);
    [psc,pcn]=plotcont(hpl,mminj,0);
    set(handles(34),'userdata',psc);
    set(handles(35),'userdata',pcn);
    set(gcf,'userdata',handles);
  end
end
