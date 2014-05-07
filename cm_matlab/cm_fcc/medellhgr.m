%function x=medellhgr(disfil)
function x=medellhgr(disfil)
[dist,mminj,konrod,bb,hy,mz,ks,buntyp,bunref,distlist,staton,masfil,rubrik,detpos,fu]=readdist(disfil);
block=masfil(5:6);
batchfil=['/p4/cm/' block '/div/bunhist/batch-data.txt'];
[eladd,garburn,antal,levyear,enr,buntot,weight,eta,typ,stav]=readbatch(batchfil);
irad=findeladd(buntyp,buntot,levyear);
stavtot=sum(stav(irad));
powtot=bb(5)/1e3;
langd=stavtot*bb(15)*mz(4)/100;
x=powtot/langd;
fprintf(1,'\n%s%5.0f%s','Antagen reaktoreffekt är',bb(5)/1e6,' MW');
