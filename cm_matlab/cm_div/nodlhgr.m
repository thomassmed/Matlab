%@(#)   nodlhgr.m 1.3	 05/12/08     13:21:49
%
%function nodlhgr(i,j,k,infil)
%Prepares plot of lhgr in given node  from distr.-files
%Example: prepare an input file as /cm/f3/c9/dist/indata-sim.txt and type
%         nodlhgr(8,14,4)
%

% Written: Thomas Smed 931015 
%
%
%
function nodlhgr(I,J,k,infil)
if nargin<4,
  infil='indata-sim.txt';disp('Indata will be read from indata-sim.txt');
end
[distfiler,efph,crpos,crstr,titel,typ,typer,tmolburn,tmollhgr,reffile,styp,straff,istraff]=...
readindatasim(infil);
ndist=size(distfiler,1);
buntyp=readdist7(distfiler(1,:),'asytyp');
[burnup,mminj,konrod]=readdist7(distfiler(1,:),'burnup');
[kmax,kkan]=size(burnup);
ntyp=size(typ,1);
typnum=zeros(1,kkan);
for i=1:ntyp
  eval(['mult(i,:)=mfiltbun(buntyp,',remblank(typer(i,:)),');']);
  ityp=find(mult(i,:));
  typnum(ityp)=ones(size(ityp))*i;
end
knum=cpos2knum(I,J,mminj);
for i=1:ndist,
  bu=readdist7(distfiler(i,:),'burnup');
  lh=readdist7(distfiler(i,:),'lhgr');
  lhgr(i,:)=lh(k,knum)';
  burn(i,:)=bu(k,knum)';
end
clhg=figure('position',[300 0 560 840]);
plottyp=['- '
         '--'
         ': '
         '-.'
         '- '
         '--'
         ': '
         '-.'
         '- '
         '--'
         ': '
         '-.'
         '- '
         '--'
         ': '
         '-.'];
for j=1:length(k),
  [xx,yy] = stairs(burn(:,j),lhgr(:,j));
  plot(xx,yy,plottyp(j,:));
  ind=min(ndist,j);
  if j==1,
    hold on
  end
end  
ax=axis;
title(['LHGR vs burnup for i,j=',sprintf('%i,%i, k=',I,J),sprintf('%i,',k)]);
plot(tmolburn(typnum(knum),:),tmollhgr(typnum(knum),:));
ax1=axis;
axis([ax(1:2) min(ax1(3),ax(3)) max(ax(4),35000)]);
set(gcf,'papertype','A4');
set(gcf,'paperpos',[0.1 1 8 10]);
end
