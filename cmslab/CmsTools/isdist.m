function isdst=isdist(dist,mminj)
isdst=1;

[id,jd]=size(dist);
mxid=max(id,jd);
mnid=min(id,jd);
iafull=length(mminj);
kan=sum(iafull-2*(mminj-1));

if mxid<(iafull/2-1), isdst=0; return; end

if (mxid<kan/4) && (mnid<iafull/2), isdst=0; return; end



