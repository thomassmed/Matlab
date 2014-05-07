%@(#)   kvotmovie.m 1.2	 94/08/12     12:10:37
%
%function M=kvotmovie(distfil1,distfil2,dist1,dist2)
%function M=kvotmovie(distfil,distname
%function M=kvotmovie(distfil,matlabvar)
%Creates a movie for the ratio
%  dist1(distfil1)/dist1(distfil2)/(dist2(distfil1)/dist2(distfil2))
% or if no 2:nd distr. is given,
%  dist1(distfil1)/dist1(distfil2)
%  Input:
%      distfil1 - distr.-file 1
%      distfil1 - distr.-file 1
%      dist1    - distr. 1, default='power'
%      dist2    - distr. 2
% Example: M=kvotmovie('ventprov-0919-1','ventprov-0919','shfupd','shf');
%          M=kvotmovie('ventprov-0919-1','ventprov-0919','shfupd');
%          M=kvotmovie('ventprov-0919-1','burnup');
function M=kvotmovie(distfil1,distfil2,dist1,dist2)
if nargin<3,
  if isstr(distfil2),
    kvot=readdist(distfil1,distfil2);
  else
    kvot=distfil2;
  end
elseif nargin>2,
  powupd=readdist(distfil1,dist1);
  updok=readdist(distfil2,dist1);
  kvot=powupd./updok;
end
if nargin>3,
  pow=readdist(distfil1,dist2);
  powok=readdist(distfil2,dist2);
  kvot=powupd./updok./(pow./powok);
end
kmax=size(kvot,1);
kvplan=100*kvot(kmax,:);
distplot(distfil1,'kvplan',upright,kvplan);
makv=max(max(100*kvot));
mikv=min(min(100*kvot));
setprop(7,sprintf('%f',mikv));
setprop(8,sprintf('%f',makv));
setprop(9,'yes');
ccplot(kvplan);
M=moviein(kmax);
for j=1:kmax
    kvplan=kvot(kmax+1-j,:)*100;
    ccplot(kvplan);
    h=get(gcf,'userdata');
    plmat=get(h(3),'cdata');
    plmat(j+2)=11.5;
    set(h(3),'cdata',plmat);
    text(1.05,j+2.5,num2str(kmax+1-j));
    M(:,j)=getframe;
end
movie(M,-2);
