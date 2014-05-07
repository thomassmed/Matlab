%@(#)   flerknippen.m 1.2	 94/08/12     12:15:10
%
%function flerknippen(buidnt,matfil,prifil)
%function flerknippen(buidnt,matfil,fid)
%function flerknippen(num,matfil,prifil)
%function flerknippen(num,matfil,fid)
%Input:
%   buidnt/num - Bundle identities/Number on matfil
%   matfil     - output from matlab command bunhist default='/cm/fx/div/bunhist/utfil.mat'
%   prifil/fid - Print result on this file/file identifier (default = screen)
%
%  Examples: buid=readdist('/cm/f2/c12/dist/boc12','buidnt');
%            flerknippen(buid,0,'prifil.lis')
%            flerknippen(str2mat('19101','19100','19102'));
%            flerknippen((1:10),'/cm/f2/div/bunhist/kinf.mat')
%
function flerknippen(num,matfil,prifil)
if nargin<2, matfil=0;end
if ~isstr(matfil),
  reakdir=findreakdir;
  matfil=[reakdir,'div/bunhist/utfil.mat'];
end
load(matfil);
if isstr(num)
  [in,jn]=size(num);
  if jn<6
    spac=setstr(32*ones(in,6-jn));
    num=[spac num];
  end
  num=mbucatch(num,BUIDNT);
else
  if size(num,1)==1, num=num';end
end
if nargin<3, 
  fid=1;
elseif isstr(prifil),
  fid=fopen(prifil,'w');
else
  fid=prifil;
end
ett=ones(size(num));
for i=1:length(num),
  it=ITOT(num(i));
  busym(i,:)=BUSYM(num(i),6*it-5:6*it);
end
loc=ONSITE(num).*(ett+(ett*max(lastcyc)==lastcyc(num)));
priknippe(BUIDNT(num,:),BUNTYP(num,:),busym,kinf(num),...
burnup(num),CYCNAM(lastcyc(num),:),ITOT(num),loc,DISTFIL(1,:),fid);
