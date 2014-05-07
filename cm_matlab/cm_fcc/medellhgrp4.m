%@(#)   medellhgrp4.m 1.1	 00/08/01     08:57:13
%
%function x=medellhgrp4('disfil')
function x=medellhgr(disfil)
[dist,mminj,konrod,bb,hy,mz,ks,buntyp,bunref,distlist,staton,masfil,rubrik,detpos,fu]=readdist(disfil);
block=masfil(8:9);
batchfil=['/p4/cm/' block '/div/bunhist/batch-data.txt'];
[eladd,garburn,antal,levyear,enr,buntot,weight,eta,typ,stav]=readbatch(batchfil);
irad=findeladd(buntyp,buntot,levyear);
stavtot=sum(stav(irad));
%powtot=(2711*1.08)*1e3 full effekt F1/F2
powtot=bb(5)/1e3;
langd=stavtot*bb(15)*mz(4)/100;
x=powtot/langd;
fprintf(1,'\n%s%5.0f%s','Antagen reaktoreffekt är',bb(5)/1e6,' MW');
