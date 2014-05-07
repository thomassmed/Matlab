%@(#)   flowprint.m 1.2	 94/02/08     12:31:29
%
%function flowprint7(distfile,printfile)
%
function flowprint7(distfile,printfile)
if nargin<2,
  disp('Result is printed on flowprint.lis');
  printfile='flowprint.lis';
end
fid=fopen(printfile,'w');
[chflow,mminj,konrod,bb,hy,mz,ks,asytyp,asyref,distlist,...
 staton,masfil,rubrik,detpos,fu,op,au,floposvar]=readdist7(distfile,'flwori');
ii=find(masfil=='/');
unit=masfil(ii(2)+1:ii(3)-1);
[chnum,knam]=flopos(unit);
[kname,ik]=ascsort(knam);
knum=chnum(ik);
if length(bucatch('FLEAK2  ',distlist))>0,
  fleak2=readdist7(distfile,'fleak2');
  chflow=chflow+fleak2;
  fprintf(fid,'\n\n');
  fprintf('%s\n','Fleak2 is included in printed numbers');
  fprintf(fid,'%s','Fleak2 is included in printed numbers');
end
fprintf(fid,'\n\n');
fprintf(fid,'\t%s%s','Channel flow in measurement-position on distr.file ',distfile);
fprintf(fid,'\n\n');
for i=1:length(knum),
   fprintf(fid,'%8s%9.2f\n',kname(i,:),chflow(knum(i)));
end
fprintf(fid,'\n%9s%9.2f','Summa:',sum(chflow(knum)));
fprintf(fid,'\n\n');
fclose(fid);
fprintf('\n\n');
fprintf('\t%s%s','Channel flow in measurement-position on distr.file ',distfile);
fprintf('\n\n');
for i=1:length(knum),
   fprintf('%8s%9.2f\n',kname(i,:),chflow(knum(i)));
end
fprintf('\n%9s%9.2f','Summa:',sum(chflow(knum)));
fprintf('\n\n');
