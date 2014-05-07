% plots the contour for a core
%
function [hsc,hcont]=plotcont(hplott,mminj,plotta,irmx)

if nargin<4, irmx=floor(length(mminj)/2);end

ll=length(mminj);

pcntx=[mminj(1) mminj(1)];pcnty=[1 2];

pcntx=[pcntx;[ll+2-mminj(1) ll+2-mminj(1)]];pcnty=[pcnty;[1 2]];
for i=2:ll,
    if mminj(i)>1,
        pcntx=[pcntx;[mminj(i) mminj(i)]];pcnty=[pcnty;[i i+1]];
        pcntx=[pcntx;[ll+2-mminj(i) ll+2-mminj(i)]];pcnty=[pcnty;[i i+1]];
    end
    if mminj(i-1)~=mminj(i),
        pcntx=[pcntx;[mminj(i-1) mminj(i)]];pcnty=[pcnty;[i i]];
        pcntx=[pcntx;[ll+2-mminj(i-1) ll+2-mminj(i)]];pcnty=[pcnty;[i i]];
    end
end



if ll>(irmx+2), % BWR
    lind=1;
    off_set=ll/2-irmx;
    for i=3-off_set:2:ll-1,
        mm=max(mminj(i-1:i));
        pscx(lind,:)=[mm ll+2-mm];
        pscy(lind,:)=[i i];
        lind=lind+1;
    end
else
   lind=1;
   for i=2:ll-1,
        mm=max(mminj(i-1:i));
        pscx(lind,:)=[mm ll+2-mm];
        pscy(lind,:)=[i i];
        lind=lind+1;
   end
end


pscxp=[pscx;pscy];pscyp=[pscy;pscx];
if nargin==2,plotta=1;end
if plotta==1,
  axes(hplott)
  hsc=line(pscxp',pscyp','color','white','erasemode','none');
  hcont=line(pcntx',pcnty','color','white','Erasemode','none');
else
  hsc=[pscxp';pscyp'];
  hcont=[pcntx';pcnty'];
end
