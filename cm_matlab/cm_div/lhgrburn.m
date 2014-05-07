%@(#)   lhgrburn.m 1.3	 05/12/08     13:21:49
%
%function [lhgr,burn,ikan,ikancr,inod,kontot]=lhgrburn(distfiles,ifil,mink,maxk,powlim);
%finds worst lhgr for fuel in controlled positions in distfiles.
%Input:
%     distfiles - distribution files (each row contains a name)
%     ifil      - gives the number (row in distfiles) for which the
%                 studied supercells are determined. (default 1)
%     mink      - min control rod position in % , i.e. the supercell
%                 is studied if crod > mink (default 30%)
%     maxk      - max control rod position in % (default 90%)
%     powlim    - power limit on Qrel (default 0.0)
%
%Output:
%     lhgr      - max lhgr
%     burn      - burnup in corresponding nod
%     inod      - Node in which max lhgr occurs
%
function [l,b,ikan,ikancr,inod,kontot]=lhgrburn(distfiles,ifil,mink,maxk,powlim);
if nargin<5, powlim=0;end
if nargin<4, maxk=90;end
if nargin<3, mink=30;end
if nargin<2, ifil=1;end
if powlim>10, powlim=powlim/100;end
[id,jd]=size(distfiles);
l=[];
b=[];
inod=[];
filename=distfiles(ifil,:);i=find(filename==' ');filename(i)='';
[lhgr,mminj,konrod,bb,hy]=readdist7(filename,'lhgr');
[ikan1,ikancr]=filtcr(konrod,mminj,mink,maxk);
for i=1:size(ikan1,1);
   ikan(i*4-3:i*4)=ikan1(i,:);
end
lik=length(ikan);
l=zeros(1,lik);
b=zeros(1,lik);
inod=zeros(1,lik);
kontot=zeros(length(ikancr),id);
for i=1:id
  filename=distfiles(i,:);ii=find(filename==' ');filename(ii)='';
  [lhgr,mminj,konrod,bb]=readdist7(filename,'lhgr');
  kontot(:,i)=konrod(ikancr);
  knum=cpos2knum(16,16,mminj);
  if hy(1)>powlim
    [lhgr,imax]=max(lhgr);
    burnup=readdist7(filename,'burnup');
    l=[l;lhgr(ikan)];
    im=imax(ikan);
    inod=[inod;im];
    [ib,jb]=size(b);
     b=[b;zeros(1,lik)];
     for ii=1:lik
        b(ib+1,ii)=burnup(im(ii),ikan(ii));
     end
  end
end
[il,jl]=size(l);
l=l(2:il,:);
b=b(2:il,:);
inod=inod(2:il,:);
