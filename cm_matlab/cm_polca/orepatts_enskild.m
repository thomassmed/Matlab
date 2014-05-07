%@(#)   orepatts_enskild.m 1.1	 09/11/13     15:31:38
%
%function patts=orepatts_enskild(supfil,disfil,cmanfil,crsum,rod);
%
% crsum=styrstavssumma, rod=position av styrstav t ex U45
function patts=orepatts_enskild(supfil,disfil,cmanfil,crsum,rod);
t=readtextfile(supfil);
[name,nrod,rods]=readmangrp(cmanfil);
[d,mminj,konrod]=readdist7(disfil);
ssprocent=[0 10 15 20 25 30 35 40 50 60 80 100];
title=t(1,:);
row=2;
grpvec=[];
while str2num(t(row,17:23))<=crsum;
  grp=t(row,1:3);
  if isempty(strmatch(grp,grpvec)),grpvec=[grpvec; grp];end
  i=strmatch(grp,grpvec);
  grppos(i)=str2num(t(row,11:15));
  row=row+1;
end
refpatt=zeros(1,length(konrod));
rvec=[];
for i=1:size(grpvec,1)
   rodvec=[];
   if strcmp(grpvec(i,1),' ')==1
      igrp=strmatch(grpvec(i,2:3),name);
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
crnum=crpos2crnum(axis2crpos(rod),mminj);
rodrefpos=refpatt(crnum);
patts=[];
for i=1:length(ssprocent);
  if ssprocent(i)<=rodrefpos
    patt=refpatt;
    patt(crnum)=ssprocent(i);
    patts=[patts ; patt];
  end
end
