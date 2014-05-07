function p=findflank(t,x,niv,s)
% p=findflank(t,x,niv,s)
% hittar tid f�r flanker i pulssignalen x
% flanken defineras av att signalen passerar niv
% p inneh�ller tider d� niv passeras
% Om s ges hittas positiv flank (+) eller negativ flank (-)
% exemplel p=findflank(t,prbs,69,'+') 

if nargin<4, s=[]; end

if strcmp(s,'+') | isempty(s)
  % Positiv flank
  bniv=find(x<=niv);
  ib=bniv(find(diff(bniv)>1)); % niv �ndring
  p=zeros(1,length(ib));
  for k=1:length(ib)
    i=ib(k);
    p(k)=(t(i+1)-t(i))/(x(i+1)-x(i))*(niv-x(i))+t(i);
  end
end

if strcmp(s,'-') | isempty(s)
  % Negativ flank
  bniv=find(x>=niv);
  ib=bniv(find(diff(bniv)>1)); % niv �ndring
  pn=zeros(1,length(ib));
  for k=1:length(ib)
    i=ib(k);
    pn(k)=(t(i+1)-t(i))/(x(i+1)-x(i))*(niv-x(i))+t(i);
  end
end

if isempty(s)
  % sl� ihop och sortera tidpunkterna f�r flankerna
  p=sort([p pn]);
elseif strcmp(s,'-')
  p=pn;
end
  
  
