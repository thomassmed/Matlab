%@(#)   createpatts.m 1.5	 05/12/08     10:31:35
%
%function [cnums,patts]=createpatts(supfil,row,disfil,cmanfil,sym)
%
%The only thing used from disfil is length(konrod) and mminj.
function [cnums,patts]=createpatts(supfil,row,disfil,cmanfil,sym)
t=readtextfile(supfil);
[name,nrod,rods]=readmangrp(cmanfil);
[d,mminj,konrod]=readdist7(disfil);
grpvec=t(2,1:3);
title=t(1,:);
row=row+1;
for irow=2:row
   grp=t(irow,1:3);
   if isempty(bucatch(grp,grpvec)),grpvec=[grpvec; grp];end
   i=bucatch(grp,grpvec);
   grppos(i)=str2num(t(irow,11:15));
end
refpatt=zeros(1,length(konrod));
rvec=[];
for i=1:size(grpvec,1)
   rodvec=[];
   if strcmp(grpvec(i,1),' ')==1
      igrp=bucatch(grpvec(i,2:3),name);
      for j=1:nrod(igrp)
         pos=(j-1)*6+1;
         rodvec=[rodvec; rods(igrp,pos:pos+2)];
      end
   else rodvec=grpvec(i,1:3);
   end
   rvec=[rvec; rodvec];
   for j=1:size(rodvec,1)
      crpos=axis2crpos(rodvec(j,:));
      crnum=crpos2crnum(crpos,mminj);
      refpatt(crnum)=grppos(i);
   end
end
cnums=[];
ind=0;
for j=1:size(rvec,1)
   crpos=axis2crpos(rvec(j,:));
   if sym==1 | crpos(2)>8 | (crpos(2)>7 & crpos(1)<9)
      crnum=crpos2crnum(crpos,mminj);
      cnums=[cnums; crnum2crpos(crnum,mminj)];
      ind=ind+1;
      patts(ind,:)=refpatt;
      patts(ind,crnum)=0;
   end
end
patts=[refpatt; patts];
%Om nedanstående rad används i s f ovanstående så erhålles
%en komplementfil med endast de mönster som står i crsup-filen.
%
%patts=refpatt;
