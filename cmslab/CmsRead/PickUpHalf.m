function vec=PickUpHalf(core,indx,TEXT,strlen,skpend,skpstart)
if nargin<4, strlen=7;end
if nargin<5, skpend=5;end
if nargin<6, skpstart=0;end
iafull=core.iafull;
istart=core.istart;
jstart=core.jstart;
mminj=core.mminj;
N=size(core.knum,1);
vecl=nan(1,N/2);
vecr=nan(1,N/2);
vec=nan(1,N);
icount=0;
% Left half first
ivec=0;
for i=istart:iafull,
    icount=icount+1;
    row=TEXT{indx+1+icount}(1+skpstart:end-skpend);
    Row=sscanf(row,'%g');
    vecl(ivec+1:ivec+length(Row))=Row';
    ivec=ivec+length(Row);
end
% Then right half
icount=icount+1;
ivec=0;
for i=istart:iafull,
    icount=icount+1;
    row=TEXT{indx+1+icount}(1+skpstart:end-skpend);
    Row=sscanf(row,'%g');
    vecr(ivec+1:ivec+length(Row))=Row';
    ivec=ivec+length(Row);
end

[right,left]=knumhalf(mminj);
vec(right)=vecr;
vec(sort(left))=vecl;