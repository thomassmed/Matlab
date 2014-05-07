function dstart=tidsdiff_mvd_vs_matdat(ds,ttid)

tti=double(ttid);
tMVD=datenum(tti(3),tti(2),tti(1),tti(4),tti(5),tti(6)+tti(7)/1000);
tmatdat=datenum(ds.tid(1),ds.tid(2),ds.tid(4),ds.tid(5),ds.tid(6),ds.tid(7)+ds.tid(8)/1000);
dstart=(tmatdat-tMVD)*24*3600;