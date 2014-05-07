function [tiprat2,lprmmat2]=lprm2tiprat2(lprmmat,tiprat,det_axloc,hz)
%%
if isstruct(det_axloc) % take care of fue_new, resinfo or filename as input
    if max(strcmp('core',fieldnames(resfile)))
        % resinfo
        resinfo = det_axloc;
        dims = ReadRes(resinfo,'DIMS',1);
        det_axloc = resinfo.core.detloc;
        hz = dims.hz;
    else
        % fue_new
        fue_new = det_axloc;

        det_axloc = fue_new.det_axloc;
    end

elseif ischar(det_axloc)
      % filename
        resinfo = ReadRes(det_axloc,'full');
        dims = ReadRes(resinfo,'DIMS',1);
        det_axloc = resinfo.core.detloc;
        hz = dims.hz;
end

%%
kmax=size(tiprat,1);
nod_axloc=det_axloc/hz;
x=0.5:1:kmax;
lprmmat0=interp1(x',tiprat,nod_axloc');
iskip=find(lprmmat<0);
lprmmat(iskip)=0;
lprmmat(iskip)=lprmmat0(iskip)*mean(lprmmat(:))/mean(tiprat(:));
lprmmat2=lprmmat./lprmmat0;
%%
nod_axloc=[0 nod_axloc kmax];
[naxlp,nlp]=size(lprmmat);
Lprmmat=[lprmmat2(1,:);lprmmat2;lprmmat2(naxlp,:)];
tiprat2=interp1(nod_axloc',Lprmmat,x');


