%@(#)   readdist.m 1.13	 10/06/29     08:44:21
%
%function [dist,mminj,konrod,bb,hy,mz,ks,buntyp,bunref,...
% distlist,staton,masfil,rubrik,detpos,fu]=readdist(filename,distname)
%
%Denna funktion klarar POLCA7filer men endast COMMON parametrar
%relevanta för distplot är konverterade
%
%För övrig läsning av POLCA7filer hänvisas till readdist7
function [dist,mminj,konrod,bb,hy,mz,ks,buntyp,bunref,...
 distlist,staton,masfil,rubrik,detpos,fu]=readdist(filename,distname)
filename=remblank(filename);
if isempty(find(filename=='.')),filename=[filename '.dat'];end
fid=fopen(filename,'r','b');
ind=fread(fid,50,'int32');
if ind(1)~=1
  fclose(fid);
  fid=fopen(filename,'r','l');
  ind=fread(fid,50,'int32');
end
if ind(50)==12348
  if nargin==1,
    [dist,mminj,konrod,bb,hy,mz,ks,buntyp,bunref,...
    distlist,staton,masfil,rubrik,detpos,fu]=dist2mlab(filename);
  else [dist,mminj,konrod,bb,hy,mz,ks,buntyp,bunref,...
    distlist,staton,masfil,rubrik,detpos,fu]=dist2mlab(filename,distname);
  end
  if dist==-2,
    dist=sum2mlab(filename);
  end
  if nargin==2,
    if strcmp(upper(distname),'BUNTYP'),
      dist=flipud(rot90(reshape(dist,4,mz(22))));
    end
    if isstr(dist)&~strcmp(upper(distname),'BUNTYP'),
      ll=length(dist)/6;
      dist=flipud(rot90(reshape(dist,6,ll)));
    end
  end
  if nargout>7,
    if ~isempty(buntyp),
      buntyp=flipud(rot90(reshape(buntyp,4,mz(22))));
    end
  end
  if nargout>8,
    ll=length(bunref)/4;
    bunref=rot90(reshape(bunref,4,ll));
  end
  if nargout>9,
    ll=length(distlist)/6;
    distlist=rot90(reshape(distlist,6,ll));
  end
else
  if ind(50)==92348
    if nargin==1,
      [dist,mminj,konrod,bb,hy,mz,ks,buntyp,bunref,distlist,...
      staton,masfil,rubrik,detpos,fu,op,au,flopos]=dist2mlab7(filename);
    end
    if nargin==2,
      if strcmp(upper(distname),'BUNTYP'),distname='ASYTYP';end
      if strcmp(upper(distname),'BUIDNT'),distname='ASYID';end
      if strcmp(upper(distname),'CRIDNT'),distname='CRID';end
      [dist,mminj,konrod,bb,hy,mz,ks,buntyp,bunref,distlist,...
      staton,masfil,rubrik,detpos,fu,op,au,flopos]=dist2mlab7(filename,distname);
      if (strcmp(upper(distname),'ASYTYP') | strcmp(upper(distname),'CRTYP'))
        dist=flipud(rot90(reshape(dist,4,mz(14))));
      end
      if (strcmp(upper(distname),'ASYID') | strcmp(upper(distname),'CRID'))
        ll=length(dist)/16;
        dist=flipud(rot90(reshape(dist,16,ll)));
%        dist=dist(:,1:6);
      end
      if (strcmp(upper(distname),'SSHIST') | strcmp(upper(distname),'VHIST'))
        [dist,mminj,konrod,bb,hy,mz,ks,buntyp,bunref,distlist,...
         staton,masfil,rubrik,detpos,fu,op,au,flopos]=dist2mlab7(filename);
        dist=zeros(mz(11),mz(14));
      end
    end
    if nargout>7,
      ll=length(buntyp)/4;
      buntyp=rot90(reshape(buntyp,4,ll));
    end
    if nargout>8,
      ll=length(bunref)/4;
      bunref=rot90(reshape(bunref,4,ll));
    end
    if nargout>9,
      ll=length(distlist)/8;
      distlist=rot90(reshape(distlist,8,ll));
    end
    v=[bb' hy' mz' ks' fu'];
    sort=[211 202 203 204 5 201 206 213 9 214 31 32 33 14 15 13 17:50 91 52:55 100 57:64 18 66:88 45 90:200 201:282 349 284 346 314 287:400 401 402 412 411 487 490 469 408 441 410:420 427 414 423:664 734 735 736 737 738 739 740 671:900];
    v=v(sort);
    bb=v(1:200);
    bb(55)=0;
    bb(89)=bb(89)*1e3;
    hy=v(201:400);
    hy(85)=hy(85);
    mz=v(401:600);
    mz(23)=mz(4)*mz(22);
    ks=v(601:800);
    fu=v(801:900);
    i=find(detpos);
    for j=1:length(i)/4
      k=find(detpos==j);
      detpos(k(2:4))=zeros(1,3);
    end
    detpos=find(detpos);
  end
end
%fclose(fid);
