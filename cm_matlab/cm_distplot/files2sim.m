%@(#)   files2sim.m 1.1	 07/02/15     13:24:58
%
%function files2sim(files[,utfil])
function files2sim(files,utfil)
if nargin<2, utfil='sim.txt';end
fid=fopen(utfil,'w');
s=size(files);
l=s(1);
fprintf(fid,'STEPS\n%i\n',l-1);
fprintf(fid,'BLIST\n');
for i=1:l
  [efph,mminj,konrod,bb,hy,mz,ks,asytyp,asyref,distlist,...
    staton,masfil,rubrik,detpos,fu,op,au,flopos,soufil]=readdist7(files(i,:),'efph');
  fprintf(fid,'%i\n',min(efph));
end
fprintf(fid,'BOCFILE\n%s\n',files(1,:));
fprintf(fid,'MANGRPFILE\nsim/mangrp.txt\n');
fprintf(fid,'CONROD\n',files(1,:));
z=struct2cell(src2mlab(soufil,'MANGRP'));
grp=[];lgrp=[];
for i=1:size(z,3)
  s=cell2mat(z(1,1,i));
  a1=find(s=='=');
  a2=find(s==',');
  grp=[grp; s(1:a1-1)];
  lgrp=[lgrp length(a2)+1];
end
[sgrp,q]=sort(-lgrp);
z(:,:,:)=z(:,:,q);
grp=grp(q,:);
for i=2:l
  [dist,mminj,konrod]=readdist7(files(i,:));
  konrod=konrod/10;
  for j=1:size(grp,1)
    s=cell2mat(z(1,1,j));
    a1=find(s=='=');
    a2=find(s==',');
    a3=[a1 a2 length(s)+1];
    rods=[];
    for k=1:length(a3)-1
      rods=[rods str2num(s(a3(k)+1:a3(k+1)-1))];
    end
    if max(konrod(rods))==min(konrod(rods))
      if max(konrod(rods))<100
        str=sprintf('%s=%i',grp(j,:),max(konrod(rods)));
        fprintf(fid,'%s',remblank(str));
        konrod(rods)=100*ones(size(rods));
        if length(find(konrod<100))>0
          fprintf(fid,',');
        else
          fprintf(fid,'\n');
        end
      end
    end
  end
end
fprintf(fid,'FILENAMES\n');
for i=2:l
  fprintf(fid,'%s\n',files(i,:));
end
fprintf(fid,'SDMFILES\ndist/sdm-boc.dat\n');
for i=2:l-1
  efph=readdist7(files(i,:),'efph');
  fprintf(fid,'%s\n',['dist/sdm-' num2str(min(efph)) '.dat']);
end
fprintf(fid,'HC\n');
for i=2:l
  [dist,mminj,konrod,bb,hy]=readdist7(files(i,:));
  fprintf(fid,'%7.1f\n',hy(2));
end
fprintf(fid,'POWER\n');
for i=2:l
  [dist,mminj,konrod,bb,hy]=readdist7(files(i,:));
  fprintf(fid,'%6.1f\n',100*hy(11));
end
fprintf(fid,'TLOWP\n');
for i=2:l
  [dist,mminj,konrod,bb,hy]=readdist7(files(i,:));
  fprintf(fid,'%6.1f\n',hy(14));
end
fprintf(1,'\nFile written: %s\n',utfil);
fprintf(1,'Input card MANGRP taken from: %s\n',soufil);
fprintf(1,'Note that CR-patterns with all rods in 100%% are left out.\n');
fclose(fid);
