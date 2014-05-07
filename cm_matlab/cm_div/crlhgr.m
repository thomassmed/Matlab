%@(#)   crlhgr.m 1.2	 94/02/08     12:31:19
%
%function [flpd,ikan,nod,burn,lhgr,straf,dbur]=crlhgr(fil,burnboc,olburn,tmollhgr,maxnod,mult,dburn,straff,istraff,stypnum)
%Input:
%   fil   - distr.file
% burnboc - burnup when control rod is inserted, if burnboc is a scalar,
%           burnboc is set to readdist(fil,'burnup')
% crpos   - control position n by 2 vector of integers
%tmolburn - burnup points of "TMOL-curve", default = [10000 60000]
%tmollhgr - lhgr points of "TMOL-curve", default = [41500 26000]
%maxnod   - gives the node up to which the position is to be monitored,
%           if e.g. the control rod has been no deeper than 50 % inserted, only
%           the bottom 12 nodes are of interest, default = kmax (normally 25)
%mult     - Determines the type of fuel (for comparison with the appropriate TMOL-curve)
%dburn    - Elapsed time with control rod insertation
%straff   - Penalty matrix
%istraff  - Start index for penalty matrix
%stypnum  - 1 by kkan vector with index for type
%Gives flpd for each specified supercell
%called by simbilaga
%
%Output: 
% flpd - ncr (number of control rods) by 4 matrix with flpd values for each bundle
% ikan - ncr by 4 matrix with corresp. channel number
% nod  - ncr by 4 matrix with node for which max flpd occurs
% burn - burnup in worst node
% lhgr - burnup in worst node
% straf- penalty for worst node
% dbur - delta burnup with control rod inserted
%
function [flpd,ikan,nod,burn,lhgr,straf,dbur]=crlhgr(fil,burnboc,crpos,tmolburn,tmollhgr,maxnod,mult,dburn,straff,istraff,stypnum)
if nargin<8,
  strafflag=0;
else
  strafflag=1;
end
[dist,mminj,konrod,bb,hy,mz,ks,buntyp]=readdist(fil);
konrod=0*konrod;
crnum=crpos2crnum(crpos(:,1),crpos(:,2),mminj);
konrod(crnum)=ones(size(crnum));
ikan=filtcr(konrod,mminj,0.1,2);
[ncr,jk]=size(ikan);
if nargin<3,
  x=[10000 60000];
else
  x=tmolburn;
end
if nargin<4,
  y=[41500 26000];
else
  y=tmollhgr;
end
BURNUP=readdist(fil,'BURNUP');
if length(burnboc)==1,
  burnboc=BURNUP;
end
if nargin<5,
  maxnod=size(BURNUP,1)*ones(ncr,1);
end
if nargin<6,
  mult=ones(1,size(BURNUP,2));
end
LHGR=readdist(fil,'LHGR');
ntyp=size(mult,1);
flpd=zeros(ncr,jk);
if strafflag==1,
  lss=size(straff,2);
end
for k=1:ntyp
  fl=0*flpd;
  p=polyfit(x(k,:),y(k,:),1);
  test=p(1)*BURNUP+p(2);
  for i=1:ncr,
    for j=1:jk,
     i1=ikan(i,j);
     if strafflag==1,
       X=straff(istraff(stypnum(i1)),2:lss);
       Y=straff(istraff(stypnum(i1))+1:istraff(stypnum(i1)+1)-1,1);
       Z=straff(istraff(stypnum(i1))+1:istraff(stypnum(i1)+1)-1,2:lss);
       temp=interp2(X,Y,Z,dburn(1:maxnod(i),i1),burnboc(1:maxnod(i),i1));
       ian=~isnan(temp);
       stra=ones(size(temp));
       stra(ian)=temp(ian);
       [fl(i,j),nod(i,j)]=max(LHGR(1:maxnod(i),i1)./test(1:maxnod(i),i1)./stra);
       straf(i,j)=stra(nod(i,j));
       dbur(i,j)=dburn(nod(i,j),i1);
     else
       [fl(i,j),nod(i,j)]=max(LHGR(1:maxnod(i),i1)./test(1:maxnod(i),i1));
     end
     lhgr(i,j)=LHGR(nod(i,j),i1);
     burn(i,j)=BURNUP(nod(i,j),i1);
     fl(i,j)=fl(i,j)*mult(k,i1);
     flpd=max(flpd,fl);
    end
  end   
end
