%@(#)   dist2mlab7.m 1.7	 11/01/27     13:18:37
%
%function [dist,mminj,konrod,bb,hy,mz,ks,asytyp,asyref,distlist...
%,staton,masfil,rubrik,detpos,fu,op,au,flopos,soufil]=dist2mlab7(filename,distname);
function [dist,mminj,konrod,bb,hy,mz,ks,asytyp,asyref,distlist...
   ,staton,masfil,rubrik,detpos,fu,op,au,flopos,soufil]=dist2mlab7(filename,distname);

if nargin >0
  filename=deblank(filename);
  if nargin >1
    distname=upper(deblank(distname));
  else
    distname=[];
  end
end

ascdist=['ASYTYP';'ASYID ';'CRID  ';'CRTYP ';];
lstr=[4 16 16 4];

integerdist=['PINGRD';'PININD'];

i=strmatch(distname,ascdist);
if ~isempty(i),lstr=lstr(i);end

fid=fopen(expand(filename,'dat'),'r','b');
ind=fread(fid,50,'int32');
if ind(1)~=1
  fclose(fid);
  fid=fopen(expand(filename,'dat'),'r','l');
  ind=fread(fid,50,'int32');
end

distlist=setstr(fread(fid,[8,ind(46)]));
distlist=flipud(rot90(distlist));

fseek(fid,4*ind(3)-4,-1);
iadr=fread(fid,3*ind(46),'int32');
fseek(fid,4*ind(7)-4,-1);
rubrik=setstr(fread(fid,80))';
fseek(fid,4*ind(8)-4,-1);
mz=fread(fid,200,'int32');
ks=fread(fid,200,'int32');
op=fread(fid,150,'int32');
bb=fread(fid,200,'float32');
hy=fread(fid,250,'float32');
au=fread(fid,100,'float32');
fu=fread(fid,100,'float32');
fseek(fid,4*ind(16)-4,-1);
konrod=10*fread(fid,mz(69),'float32');
fseek(fid,4*ind(19)-4,-1);
mminj=fread(fid,2*mz(13),'int32');
mminj=mminj(1:2:length(mminj));
mminjrefl=mminj;
fseek(fid,4*ind(23)-4,-1);
detpos=fread(fid,mz(14),'int32');
fseek(fid,4*ind(25)-4,-1);
flopos=fread(fid,2*mz(97),'int32');
fseek(fid,4*ind(28)-4,-1);
soufil=remblank(setstr(fread(fid,80))');
fseek(fid,4*ind(30)-4,-1);
masfil=remblank(setstr(fread(fid,80))');
fseek(fid,4*ind(31)-4,-1);
asyref=setstr(fread(fid,4*mz(44)));
asyref=reshape(asyref,4,mz(44))';
asyref(strmatch(char(32),asyref),:)=[];
fseek(fid,4*48-4,-1);
staton=remblank(setstr(fread(fid,4))');

inddis=strmatch('ASYTYP',distlist);

fseek(fid,4*(iadr(inddis*3-2)-1),-1);
fseek(fid,5*4,0);
dsize=fread(fid,1,'int32');
subsize=fread(fid,1,'int32');
kmxval=fread(fid,1,'int32');
kmxnod=fread(fid,1,'int32');
isym=fread(fid,1,'int32');
fseek(fid,4,0);
sidref=fread(fid,1,'int32');

if sidref==1
  mminjrefl=[mminj(1:mz(12)/2); mminj(mz(12)/2); mminj(mz(12)/2+1); mminj(mz(12)/2+1:mz(12))];
  reflec=sort(findrefl(mminjrefl));

  kfullh=half2full(1:mz(20)/2,mminjrefl);
  kfullq=quart2full(1:mz(20)/4,mminjrefl);
else
  reflec=[];
  kfullh=half2full(1:mz(14)/2,mminj);
  kfullq=quart2full(1:mz(14)/4,mminj);
end

if nargout>7

  fseek(fid,4*(iadr(inddis*3-2)-1)+4*subsize,-1);

  asytyp=char(fread(fid,4*dsize))';
  if isym==3
    asyfull=setstr(32*ones(1,2*length(asytyp)));
    for i=1:4
      asyfull((kfullh(:,1)-1)*4+i)=asytyp((i:4:end));
      asyfull((kfullh(:,2)-1)*4+i)=asytyp((i:4:end));
    end
    asytyp=asyfull;
  end
  if isym==5
    asyfull=setstr(32*ones(1,2*length(asytyp)));
    for i=1:4
      asyfull((kfullq(:,1)-1)*4+i)=asytyp((i:4:end));
      asyfull((kfullq(:,2)-1)*4+i)=asytyp((i:4:end));
      asyfull((kfullq(:,3)-1)*4+i)=asytyp((i:4:end));
      asyfull((kfullq(:,4)-1)*4+i)=asytyp((i:4:end));
    end
    asytyp=asyfull;
  end
  if sidref==1
    pos=4*(reflec-1)+1;
    for i=length(pos):-1:1
      asytyp(pos(i):(pos(i)+4-1))=[];
    end
  end
end

if ~isempty(distname)
  inddis=strmatch(distname,distlist,'exact');
  if ~isempty(inddis)

    fseek(fid,4*(iadr(inddis*3-2)-1),-1);
    fseek(fid,5*4,0);
    dsize=fread(fid,1,'int32');
    subsize=fread(fid,1,'int32');
    kmxval=fread(fid,1,'int32');
    kmxnod=fread(fid,1,'int32');
    isym=fread(fid,1,'int32');
    
    fseek(fid,4*(iadr(inddis*3-2)-1)+4*subsize,-1);
    
    if strmatch(distname,ascdist)
      if strcmp(distname,'ASYTYP') & nargout>7
        dist=asytyp;
      else
        dist=char(fread(fid,4*dsize))';
        if isym==3
          asyfull=setstr(32*ones(1,2*length(dist)));
          for i=1:lstr
            asyfull((kfullh(:,1)-1)*lstr+i)=dist((i:lstr:end));
            asyfull((kfullh(:,2)-1)*lstr+i)=dist((i:lstr:end));
          end
          dist=asyfull;
        end
        if sidref==1 & size(dist,2)==lstr*mz(20)
          pos=lstr*(reflec-1)+1;
          for i=length(pos):-1:1
            dist(pos(i):(pos(i)+lstr-1))=[];
          end
        end
      end
    else
      if strmatch(distname,integerdist)
        dist=fread(fid,dsize,'int');
      else
        dist=fread(fid,dsize,'float32');
      end
      dist=reshape(dist,kmxval,dsize/kmxval);
      if isym==3
        distfull=zeros(kmxval,2*dsize/kmxval);
        for i=1:kmxval
          distfull((kfullh(:,1)-1)*kmxval+i)=dist((i:kmxval:end));
          distfull((kfullh(:,2)-1)*kmxval+i)=dist((i:kmxval:end));
        end
        dist=distfull;
      end
      if isym==5
        distfull=zeros(kmxval,4*dsize/kmxval);
        for i=1:kmxval
          distfull((kfullq(:,1)-1)*kmxval+i)=dist((i:kmxval:end));
          distfull((kfullq(:,2)-1)*kmxval+i)=dist((i:kmxval:end));
          distfull((kfullq(:,3)-1)*kmxval+i)=dist((i:kmxval:end));
          distfull((kfullq(:,4)-1)*kmxval+i)=dist((i:kmxval:end));
        end
        dist=distfull;
      end
      if size(dist,2)==mz(20),dist(:,reflec)=[];end
    end
  else
    fprintf(1,'\n%s no such distribution in file %s\n',distname,filename);
    distname=[];
  end
end  
[tmp,i]=sortrows(-asyref(:,3:4));
asyref=asyref(i,:);
asyref=reshape(rot90(asyref,-1),1,size(asyref,1)*size(asyref,2));

if nargin==1|isempty(distname)
  dist=-1;
  distlist=sortrows(distlist);
  distlist=reshape(rot90(distlist,-1),1,size(distlist,1)*size(distlist,2));
  fclose(fid);
  return;
end

distlist=sortrows(distlist);
distlist=reshape(rot90(distlist,-1),1,size(distlist,1)*size(distlist,2));

fclose(fid);
