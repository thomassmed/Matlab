%
%
% [h,dk,fd,nlp,lpnr,axpos,kpunkt]=dr_distplot(racsfil);
%
% Calculates decay-ratio for APRM and all LPRM:s on the file racsfil
% and displays the result on the current distplot-window
%
% Input: 
%  racsfil - name of racsfile (may be a .mat-file too)
%
% Output:
%  h - handle for text on the distplot window
%  dk - decayratio for all LPRM:s AND aprm (last in vector)
%  fd - frequency for all LPRM:s AND aprm (last in vector)
%  nlp,lpnr,axpos,kpunkt are outputs from racsb2lprm
%
%
% Alternative use: if You have made the timeconsuming drident-calculations
% and want to put the text-strings on another distplot-window,
% you can call dr_distplot like this:
%
%1:[h,dk,fd,nlp,lpnr,axpos,kpunkt]=dr_distplot(racsfil); (as before)
%  Then you realize you want to put the same text on a new plot
%  in the same or another distplot-window:
%2:h=dr_distplot(dk,fd,b);
% where 
%  dk - decayratio for all LPRM:s AND aprm (last in vector)
%  fd - frequency for all LPRM:s AND aprm (last in vector)
%   b - output from ldracs: [a,b,c]=ldracs(racsfil);

% Thomas Smed 1998-08-06
function [h,dk,fd,nlp,lpnr,axpos,kpunkt]=dr_distplot(x1,x2,x3);
hf=gcf;
ud=setprop;distfile=remblank(ud(5,:));
[dist,mminj,konrod,bb,hy,mz,ks,buntyp,bunref,...
distlist,staton]=readdist7(distfile);
staton=lower(staton);  
if isstr(x1), 
  if strcmp(staton,'f3'),
    [c,mtext,b,mvarb,sampl]=getf3(x1);
    f3=1;
  else
    [a,b,c]=ldracs(x1);
    f3=0;
  end
  idaprm=1;
  diary([strip(x1),'.lis']);
  disp(['Racsfil: ',x1]);
else
  if strcmp(staton,'f3'), f3=1; else f3=0; end
  dk=x1;
  fd=x2;
  b=x3;
  DK=dk(length(dk));
  FD=fd(length(fd));
  c=zeros(10,50);
  idaprm=0;;
end
% fixa outliers
[id,jd]=find(abs(c)>1e10);
c(id,jd)=(c(id+1,jd)+c(id-1,jd))/2;
if strcmp(staton,'f3');
  [nlp,lpnr,axpos,kpunkt,apnr]=racsb2lprm(b,f3,sampl);
else
  [nlp,lpnr,axpos,kpunkt,apnr]=racsb2lprm(b,f3);
end
%c=idresamp(c,2);
figure(hf);
distfil=setprop(5)

[d,mminj,konrod,bb,hy,mz,ks,buntyp,bunref,distlist,staton,masfil,rubrik,detpos,fu]=readdist(distfil);

ij=knum2cpos(detpos(lpnr),mminj);
if exist('sampl')==1,
  T=1/sampl(2,1);
else  
  T=c(3,1)-c(2,1);
end
if idaprm==1,
  APRMCH=['A' 'B' 'C' 'D'];
  for i=1:length(apnr),
    fprintf(1,'%s %s \n','Decay ratio for APRM',APRMCH(i));
    [DK,FD]=drident(c(:,apnr(i)),T);
  end
end

figure(hf);
h(length(nlp)+1)=text(1,28.5,sprintf('  APRM:\n DR= %4.2f  Fr= %5.2f Hz',DK,FD));
set(h(length(h)),'fontsize',13);

for i=1:length(nlp),
   if idaprm==1,
      fprintf(1,'%s %s %2i %s %2i\n',kpunkt(i,:),'LPRM nr',lpnr(i),'Axpos:',axpos(i));
     [dk(i),fd(i)]=drident(c(:,nlp(i)),T);
   end
   figure(hf);
   h(i)=text(ij(i,2),ij(i,1)-1.5+.5*axpos(i),sprintf('%4.2f%6.2f',dk(i),fd(i)));
   set(h(i),'fontsize',12);
   if idaprm==1,
     drawnow;
   end
end



if idaprm==1,
  diary off
  dk=[dk DK];
  fd=[fd FD];
end


%@(#)   dr_distplot.m 1.3   03/08/26     10:28:04
