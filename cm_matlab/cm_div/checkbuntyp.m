%@(#)   checkbuntyp.m 1.4	 05/12/08     13:18:31
%
%function checkbuntyp(sourcefile,distfile,prifil)
% Compares the buntyp distr. given in a source- or complement-
% file with the buntyp distr. in a distr.file
%
% Input: sourcefile - source- or complement-file
%        distfile   - distr. file
%        prifil     - printfile, optional default = screen
%
%Example: checkbuntyp('/cm/f3/c7/pol/source.txt','/cm/f3/c7/dist/eoc7')
%         reads the BUNTYP given in /cm/f3/c7/pol/source.txt and compares it to
%         the BUNTYP-distr. in /cm/f3/c7/dist/eoc7.dat
function checkbuntyp(sourcefile,distfile,prifil)
buntyp=readbuntyp(sourcefile);
buntyp1=readdist7(distfile,'asytyp');
m=max(abs(abs(buntyp)'-abs(buntyp1)'))';
if nargin>2,
  fid=fopen(prifil,'w');
else
  fid=1;
end
if max(m)==0,
  disp('There are no differences in the BUNTYP-distributions of');
  disp([sourcefile,' and ',distfile]);
else
  [buidnt,mminj]=readdist7(distfile,'asyid');
  kkan=size(buntyp,1);
  fprintf(fid,'\n%s','The following differences in the buntyp distributions were found:');
  l=find(m);
  ij=knum2cpos(l,mminj);
  fprintf(fid,'\n%s%s%s%s','SOURCE: ',sourcefile,'  DISTR.FILE: ',distfile);
  fprintf(fid,'\n%7s%7s%5s%5s%6s%9s%7s%8s','BUIDNT','SOURCE','DIST','KNUM','I,J','BUIDSYM','SOUSYM','DISTSYM');
  for i=1:length(l),
    fprintf(fid,'\n%7s%7s%5s%5i%4i%s%2i%8s%7s%8s',buidnt(l(i),:),buntyp(l(i),:),buntyp1(l(i),:),l(i),ij(i,1),',',ij(i,2),buidnt(kkan+1-l(i),:),buntyp(kkan+1-l(i),:),buntyp1(kkan+1-l(i),:));
  end
  fprintf(fid,'\n');
end
if fid~=1, fclose(fid);end
