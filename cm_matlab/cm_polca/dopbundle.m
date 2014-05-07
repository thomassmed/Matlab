%@(#)   dopbundle.m 1.3	 98/06/09     13:31:39
%
%function dopbundle(distfil,bunchoice,firstbun,SYMME,utfil);
%Function for giving names to new bundles
% Input:
%         distfil - distribution file for new cycle
%       bunchoice - BUNTYP, for which the names should be given
%        firstbun - name for first bundle
%        SYMME    - Symmetry according to POLCA, e.g. SYMME=1 for full core symmetry
%        utfil    - name on file where input to anaload should be printed
%
%
% Example: dopbundle('/cm/f1/c13/dist/boc13','E293','KU0739',3);
%
%
%
function dopbundle(distfil,bunchoice,firstbun,SYMME,utfil);
if nargin<5, utfil='buidnt.txt';disp('results will be printed on buidnt.txt');end;
fid=fopen(utfil,'w');
[buntyp,mminj]=readdist(distfil,'buntyp');
[kkan,sex]=size(buntyp);
bvec=filtbun(buntyp,bunchoice);
[right,left]=knumhalf(mminj);
rv=0*bvec;
rv(right)=ones(size(right));
ibun=find(rv.*bvec==1);
slutloop=fix(length(ibun)/5);
firstbun=sprintf('%6s',firstbun);
for nf=1:6,
 if str2num(firstbun(nf))>0, break;end
end
firstnum=str2num(firstbun(nf:6));
x=firstnum;
for i=1:10,
  x=x/10;
  if x<1, break;end
end  
tusen=10^i;
for i=1:length(ibun),
  nff=nf;
  cmp=0;
  if firstnum-1+2*i>=tusen, nff=nf-1;cmp=tusen;end
  if firstnum-1+2*i>=10*tusen, nff=nf-2;cmp=10*tusen;end
  if firstnum-1+2*i>=100*tusen, nff=nf-3;cmp=100*tusen;end
  if firstnum-1+2*i>=1000*tusen, nff=nf-4;cmp=1000*tusen;end
  nffr=nff;
  if firstnum-1+2*i==cmp, nffr=nff+1;end
  rbu(i,:)=[firstbun(1:nffr-1),sprintf('%i',firstnum-2+2*i)];
  lbu(i,:)=[firstbun(1:nff-1),sprintf('%i',firstnum-1+2*i)];
end
if SYMME==3,
  hbun=full2half(ibun,mminj);
  for i=1:slutloop
    i0=(i-1)*5;
    fprintf(fid,'\n');
    fprintf(fid,'%s','BUIDNT');
    for j=1:5,
      fprintf(fid,'%5i%7s%7s',hbun(i0+j),rbu(i0+j,:),lbu(i0+j,:));
    end
  end
  if length(hbun)>slutloop*5,
    i0=slutloop*5;
    fprintf(fid,'\n');
    fprintf(fid,'%s','BUIDNT');
    for j=1:length(hbun)-slutloop*5
      fprintf(fid,'%5i%7s%7s',hbun(i0+j),rbu(i0+j,:),lbu(i0+j,:));
    end
  end
elseif SYMME==1,
  slutloop=fix(length(ibun)/4);
  for i=1:slutloop
    i0=(i-1)*4;
    fprintf(fid,'\n');
    fprintf(fid,'%s','BUIDNT');
    for j=1:4,
      fprintf(fid,'%5i%7s%5i%7s',ibun(i0+j),rbu(i0+j,:),kkan+1-ibun(i0+j),lbu(i0+j,:));
    end
  end
  if length(ibun)>slutloop*4,
    i0=slutloop*4;
    fprintf(fid,'\n');
    fprintf(fid,'%s','BUIDNT');
    for j=1:length(ibun)-slutloop*4
      fprintf(fid,'%5i%7s%5i%7s',ibun(i0+j),rbu(i0+j,:),kkan+1-ibun(i0+j),lbu(i0+j,:));
    end
  end
end
fprintf(fid,'\n');
fclose(fid);
