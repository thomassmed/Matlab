%@(#)   crid2crtyp.m 1.2	 08/03/26     16:20:08
%
%function [crtypmap,cridmap,distcrid]=crid2crtyp(distfil,prifil,cridon,criddist)
%
% Generates CRTYP map based on distribution file CRID distribution
%
% Input: 
%        distfil  - distribution file with CRID data
%        prifil   - name of printout file for generated CRTYP (and 
%                   CRID, see below) data [optional]
%        cridon   - CRID printout off/on (0/1) [optional, default off]
%        criddist - printout of distribution file CRID data [optional]
%                   
% Output variables:
%        crtypmap - character array with CRTYP map
%        cridmap  - character array with CRID map
%        distcrid - character array with distribution file CRID data
function [crtypmap,cridmap,distcrid]=crid2crtyp(distfil,prifil,cridon,criddist)

if nargin<1,
  disp(' ')
  disp('---------------------------------------------------------------------------')
  disp('No distribution file given! Execution aborted.')
  disp('---------------------------------------------------------------------------')
  disp(' ')
  return
end

%load cr definitions
reakdir=findreakdir;
crdefpath=[reakdir 'div/sshist'];
crdeffile='cridcrtyp.txt';
crdef=[crdefpath '/' crdeffile]
[crid0,crtyp0]=textread(crdef,'%s%s','delimiter',' ','headerlines',1);
crid0=char(crid0);
lcrid0=size(crid0,2);
crtyp0=char(crtyp0);
lcrtyp0=size(crtyp0,2);

%get asyid map from distfil
[crid,mminj]=readdist7(distfil,'CRID');
crid=deblank(crid);
crmminj = mminj2crmminj(mminj);
crant=length(crid);
lcrid=size(crid,2);
if lcrid~=lcrid0 %check CRID string lengths between def & dist data
  if lcrid>lcrid0
    tcrid=crid;
    llcrid=lcrid0;
  else
    tcrid=crid0;
    llcrid=lcrid;
  end
  for i=1:crant
    if length(deblank(tcrid(i,:)))>llcrid
      brki(i)=1;
    end
  end
  brks=find(brki~=0);
  disp(' ')
  disp('---------------------------------------------------------------------------')
  disp('Error!!!')
  disp('CRID string lengths differ between definition and distribution files.')
  disp(' ')
  disp('Affected CRID:')
  disp(tcrid(brks,:))
  disp(' ')
  disp('Execution aborted.')
  disp('---------------------------------------------------------------------------')
  disp(' ')
%  global crid crid0
  return
end

%reality check
[a,b]=charmatch(crid,crid0);
if ~isempty(find(a==0))
  crnf=find(a==0);
  disp(' ')
  disp('---------------------------------------------------------------------------')
  disp('Warning!!!')
  disp('Please update CR definition file. One or more CRID from distribution file ')
  disp(['NOT FOUND in CR definition file: "' crdef '".'])
  disp(' ')
  disp('CRID missing in definition file:')
  disp(crid(crnf,:))
  disp(' ')
  disp('These CR will for now be given CRTYP "XXXX". Needs to be changed manually.')
  disp('---------------------------------------------------------------------------')
  disp(' ')
end

%create CRID & CRTYP map
clear cridmap crid0map crtypmap;
idestr='';
idxstr='';
for l=1:lcrid
  idestr=[idestr ' '];
  idxstr=[idxstr 'X'];
end
typestr='';
typxstr='';
for m=1:lcrtyp0
  typestr=[typestr ' '];
  typxstr=[typxstr 'X'];
end
cridstr='';
crid0str=cridstr;
crtypstr=cridstr;
lcrgrid=length(crmminj);
k=1;
for i=1:lcrgrid
  for j=1:lcrgrid
    if (j<crmminj(i))||(j>lcrgrid-crmminj(i)+1)
      cridstr=[cridstr idestr ' '];
      crid0str=[crid0str idestr ' '];
      crtypstr=[crtypstr typestr ' '];
    else
      if a(k)==0
        cridstr=[cridstr idxstr ' '];
        crid0str=[crid0str crid(k,:) ' '];
        crtypstr=[crtypstr typxstr ' '];
      else
        cridstr=[cridstr crid(k,:) ' '];
        crid0str=[crid0str crid0(a(k),:) ' '];
        crtypstr=[crtypstr crtyp0(a(k),:) ' '];
      end
      cridmap{i}=cridstr;
      crid0map{i}=crid0str;
      crtypmap{i}=crtypstr;
      k=k+1;
    end
  end
  cridstr='';
  crid0str=cridstr;
  crtypstr=cridstr;
end
cridmap=char(cridmap);
crid0map=char(crid0map);
distcrid=crid0map;
crtypmap=char(crtypmap);

%optional output
if exist('prifil')
  fid=fopen(prifil,'w');
  if exist('cridon')
    if cridon~=0
      fprintf(fid,'CRID\n');
      for j=1:lcrgrid
        fprintf(fid,'%s\n',cridmap(j,:));
      end
      fprintf(fid,'\n\n');
      if criddist~=0
        fprintf(fid,'CRID\n');
        for j=1:lcrgrid
          fprintf(fid,'%s\n',crid0map(j,:));
        end
        fprintf(fid,'\n\n');
      end
    end
  end
  fprintf(fid,'CRTYP\n');
  for i=1:lcrgrid
    fprintf(fid,'%s\n',crtypmap(i,:));
  end
end
