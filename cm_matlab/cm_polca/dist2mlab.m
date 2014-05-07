%@(#)   dist2mlab.m 1.3	 10/06/29     08:41:14
%
%[dist,mminj,konrod,bb,hy,mz,ks,buntyp,bunref,...
%distlist,staton,masfil,rubrik,detpos,fu,au]=dist2mlab(f_polca,distname);

function [dist,mminj,konrod,bb,hy,mz,ks,buntyp,bunref,...
distlist,staton,masfil,rubrik,detpos,fu,au]=dist2mlab(f_polca,distname);

ascdist=['BUNTYP';'BUIDNT';'CRIDNT';'CRTYP ';];

if nargin >0
  f_polca=deblank(f_polca);
  if nargin >1
    distname=deblank(distname);
  end
end

fid=fopen(expand(f_polca,'dat'),'r','b');
ind=fread(fid,50,'int32');
if ind(1)~=1
  fclose(fid);
  fid=fopen(expand(f_polca,'dat'),'r','l');
  ind=fread(fid,50,'int32');
end

credat=setstr(fread(fid,80));

distlist=setstr(fread(fid,[12,ind(48)])');
distlist(:,[3 4 7 8 11 12])=[];

fseek(fid,4*ind(4)-4,-1);
iadr=fread(fid,ind(48),'int32');
fseek(fid,4*ind(8)-4,-1);
staton=ascch2(setstr(fread(fid,20)))';
fseek(fid,4*ind(9)-4,-1);
masfil=deblank(setstr(fread(fid,100))');
fseek(fid,4*ind(10)-4,-1);
mz=fread(fid,200,'int32');
ks=fread(fid,200,'int32');
bb=fread(fid,200,'float32');
hy=fread(fid,200,'float32');
mminj=fread(fid,mz(3),'int32');
fseek(fid,4*ind(16)-4,-1);
detpos=fread(fid,mz(5),'int32');
bunref=ascch2(setstr(fread(fid,400)));
bunref=reshape(bunref,4,50)';
bunref(strmatch(char(32),bunref),:)=[];
fseek(fid,4*ind(18)-4,-1);
rubrik=deblank(ascch2(setstr(fread(fid,80)))');
fseek(fid,4*ind(19)-4,-1);
konrod=fread(fid,mz(7),'int32');
fseek(fid,4*ind(29)-4,-1);
fu=fread(fid,100,'float32');
fseek(fid,4*ind(31)-4,-1);
au=fread(fid,100,'float32');



inddis=strmatch('BUNTYP',distlist);
fseek(fid,(iadr(inddis)-1)*4*128,-1);
buntyp=bunref(fread(fid,mz(22),'int32'),:);


[tmp,i]=sortrows(-bunref(:,3:4));
bunref=bunref(i,:);
bunref=reshape(rot90(bunref,-1),1,size(bunref,1)*size(bunref,2));
buntyp=reshape(rot90(buntyp,-1),1,size(buntyp,1)*size(buntyp,2));

if nargin==1|isempty(distname)
  dist=-1;
  distlist=sortrows(distlist);
  distlist=reshape(rot90(distlist,-1),1,size(distlist,1)*size(distlist,2));
  fclose(fid);
  return;
else
  inddis=strmatch(upper(distname),distlist);
end

if isempty(inddis)
  dist=-1;
elseif strcmp(upper(distname),'BUNTYP')
  dist=buntyp;
else
  fseek(fid,(iadr(inddis)-1)*4*128-512,-1);
  fseek(fid,6*4,0);
  dsize=fread(fid,1,'int32');

  fseek(fid,(iadr(inddis)-1)*4*128,-1);
  if ~strcmp(upper(distname),'BUNTYP')
    if dsize>12 | strmatch(upper(distname),ascdist)
      if strcmp(upper(distname),'FUEROD')
        dist=fread(fid,[mz(4),mz(22)],'int32');
      else
        if strmatch(upper(distname),ascdist)
          if strcmp(upper(distname), 'CRIDNT') | strcmp(upper(distname), 'CRTYP')
            dist = ascch2(setstr(fread(fid,12*mz(7))))';
          else
            dist=ascch2(setstr(fread(fid,12*mz(22))))';
          end
        else
          dist=fread(fid,[mz(4),mz(22)],'float32');
        end
      end
    else
      dist=fread(fid,mz(22),'float32')';
    end 
  end 
end

distlist=sortrows(distlist);
distlist=reshape(rot90(distlist,-1),1,size(distlist,1)*size(distlist,2));

fclose(fid);
