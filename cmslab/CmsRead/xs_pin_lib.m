function [xs,xsd,xst,XS,xsdd]=xs_pin_lib(cd_file,resfile,dens,Tfm,knum,XS,icol)
% Reads delayed groups from pin library in library file
%
% [xs,xsd,xst,XS,xsdd]=xs_pin_lib(cd_file,resinfo,dens,Tfm)
% [xs,xsd,xst,XS,xsdd]=xs_pin_lib(cd_file,fue_new,dens,Tfm)
% [xs,xsd,xst]=xs_pin_lib(cd_file,RestartFile,dens,Tfm,knum,XS) %for speed
% alb=xs_pin_lib(LibFile,fue_new,dens,Tfm+273.13,1:kan,1:12);
% 
%
% Input
%   cd_file - Library file
%   fue_new - core properties, output of read_restart_bin or resinfo output
%             ReadRes
%   dens    - density g/cm^3
%   Tfm     - Fuel temperature, K
%
% Output:
%   xs - Cross sections, default [d1 d2 
%
%
% Example:
%    alb=xs_pin_lib(msopt.LibFile,resinfo,dens,Tfm+273.13,geom.knum(:,1),XS,1:12);
%    al=alb(:,7:12)';
%    b=alb(:,1:6)'; % This gives delayed groups
% If XS has not been read before:
%    alb=xs_pin_lib(msopt.LibFile,fue_new,dens,Tfm+273.13,geom.knum(:,1),1:12);
%    al=alb(:,7:12)';b=alb(:,1:6)';
%
%   
%

% Written Thomas Smed 2009-03-10

% From SUBROUTINE SIGDAT (Ask Tamer Bahadir for details)
% IOFF   = (9+4*NDET+NPINXY)
% NDET   = LIBPNS(5)
% NPINXY = LIBPNS(8)
%                                             I
%                                             I
%                   IOFF                      V
%     --------------------------------------+---
%     I
%     I
%NROW I
%     I
%     I
%     I
%     I
%
%
%           1    2    3    4    5    6     7     8
% NROW-1  NEXP NRES NTAB NRODS NDET ISYM NPIDS NPINXY
% NROW    Exposure list      Res List        SIMID    BASE
%             NEXP            NRES           NTAB     NTAB


%%
read_cd_file=1;
get_cr_w=1;
icol_default=1;

if isstruct(resfile) % take care of fue_new, resinfo or filename as input
    if max(strcmp('core',fieldnames(resfile)))
        % resinfo
        resinfo = resfile;
        dat = ReadRes(resinfo,{'LIBRARY','BURNUP','VHIST','TFUHIST','CRDHIST','XENON','SAMARIUM'},1);
        fue_new = catstruct(dat.library,dat.resinfo.core);
        fue_new.burnup = dat.burnup;
        fue_new.vhist = dat.vhist;
        fue_new.tfuhist = dat.tfuhist;
        fue_new.crdhist = dat.crdhist;
        fue_new.xenon = dat.xenon;
        fue_new.samarium = dat.samarium;
    else
      % fue_new
      fue_new = resfile;
    end

elseif ischar(resfile)
      % filename
        resinfo = ReadRes(resfile,'full');
        dat = ReadRes(resinfo,{'LIBRARY','BURNUP','VHIST','TFUHIST','CRDHIST','XENON','SAMARIUM'},1);
        fue_new = catstruct(dat.library,dat.resinfo.core);
        fue_new.burnup = dat.burnup;
        fue_new.vhist = dat.vhist;
        fue_new.tfuhist = dat.tfuhist;
        fue_new.crdhist = dat.crdhist;
        fue_new.xenon = dat.xenon;
        fue_new.samarium = dat.samarium;

end


if nargin<5,
    knum=1:fue_new.kan;
end
if size(knum,2)==2&&size(knum,1)>2, knum=knum(:,1); end
if nargin>5,
    if isstruct(XS),
        if nargin>6, %If 6:th input argument is XS, icol would be given as 7:th 
            icol_default=0;
        end
        if isfield(XS,'cr'),
            get_cr_w=0;
            cr=XS.cr;
            cr_w=XS.cr_w;
            cr_cusp=XS.cr_cusp;
            if length(cr{1}(:))>length(Tfm(:)),
                for i=1:3,
                    cr{i}=cr{i}(:,knum);
                    cr_w{i}=cr_w{i}(:,knum);
                end
            end
        end
        if isfield(XS,'segmnt'),
            read_cd_file=0;
            segmnt=XS.segmnt;
            segpos=XS.segpos;
            nseg=XS.nseg;
            niseg=XS.niseg;
        end
    else
        icol=XS; %If icol is given as the 6:th input argument
        icol_default=0;
    end
end


if get_cr_w, %Read cr_w info if neccesary
    [cr,cr_w,cr_cusp]=konrod2crfrac(resfile);
    for i=1:3,
        cr{i}=cr{i}(:,knum);
        cr_w{i}=cr_w{i}(:,knum);
    end
    cr_cusp=cr_cusp(:,knum);
end


tweekd=0;
if icol_default,
    icol=[19:26 33 35];
    tweekd=1;
end

%%
burnup=fue_new.burnup(:,knum);
vhist=fue_new.vhist(:,knum);
tfuhist=fue_new.tfuhist(:,knum);
crdhist=fue_new.crdhist(:,knum);
ncol=length(icol);
burnup=burnup(:);
ntot=length(burnup);
zer=zeros(ntot,ncol);
DIST=[burnup(:) dens(:) vhist(:) sqrt(Tfm(:)) tfuhist(:)];
%%
if read_cd_file,
    [segmnt,segpos,nseg,niseg]=read_cdfile(cd_file);
end

ncrd_list=unique([cr{1};cr{2};cr{3}]);
ncrd_list=ncrd_list(find(ncrd_list));   % Remove zero entry
%% Sort the Core Segments
w1=fue_new.Seg_w{1};w1=w1(:,knum);w1=w1(:);
w2=fue_new.Seg_w{2};w2=w2(:,knum);w2=w2(:);
cseg=fue_new.Core_Seg{1}(:,knum);cseg=cseg(:);
cseg2=fue_new.Core_Seg{2}(:,knum);cseg2=cseg2(:);
csegtot=[cseg;cseg2];
seg_list=unique(csegtot);ibort=find(seg_list==0);seg_list(ibort)=[];
%%
xs=zer;
xsd=xs;xst=xs;xsdd=xsd;
fid=fopen(cd_file,'r','ieee-be');
%%
for i=1:length(seg_list),
  isegtmp=strmatch(fue_new.Segment(seg_list(i),:),segmnt);
  iseg(i)=isegtmp(1);
  if niseg{iseg(i)}(3,3)>2, is_water=0; else is_water=1;end
    iseg1=find(cseg==seg_list(i));
    iseg2=find(cseg2==seg_list(i));    
    ind_seg=[iseg1;iseg2];
    lseg=length(ind_seg);
    seg_logic=zeros(ntot,1);seg_logic(ind_seg)=1;
    seg_w=zer;seg_w(iseg1,1)=w1(iseg1);
    seg_w(iseg2,1)=w2(iseg2);
    for iw=2:ncol,
        seg_w(:,iw)=seg_w(:,1);
    end
    ipos=find(niseg{iseg(i)}(1,:)==10);
    if ~isempty(ipos),
    fseek(fid,segpos(iseg(i),ipos),-1);
    dimen=fread(fid,5,'int');
    pin_data=fread(fid,dimen(2)*dimen(3),'float');
    pin_data=reshape(pin_data,dimen(3),dimen(2))';
    dimen1=round(pin_data(dimen(2)-1,1:10));
    nexp=dimen1(1);
    nrst=dimen1(2);
    nx=dimen1(3);
    exposur=pin_data(end,1:nexp);
    res_exp=pin_data(end,nexp+1:nexp+nrst);
    x_id=round(pin_data(end,nexp+nrst+1:nexp+nrst+nx));
    bas=pin_data(end,nexp+nrst+nx+1:nexp+nrst+nx+dimen1(3));
    index=dimen1(8)+9+4*dimen1(5);
    j_dens=find(x_id==2);
    j_denshis=find(x_id==3);
    if is_water,
        j_low_void=j_dens(1);
        j_high_void=j_dens(2);
    else
        j_low_void=[j_dens(1) j_denshis(1)];
        j_high_void=[j_dens(2) j_denshis(2)];
        j_tfu=find(x_id==4);
        j_tfuhist=find(x_id==5);
    end
    if ~exist('invA','var'),
        bas0=bas(j_dens(1));
        %A=[.1-bas0 1;.77-bas0 1];
        invA=-[1 -1;bas0-.77 .1-bas0]/.67;
    end
    ilow=find(DIST(ind_seg,x_id(j_dens(1)))>=bas(j_dens(1)));
    ihigh=find(DIST(ind_seg,x_id(j_dens(1)))<bas(j_dens(1)));
    % base XS
    xs(ind_seg,:)=xs(ind_seg,:)+seg_w(ind_seg,:).*interp1(exposur,pin_data(1:nexp,index+icol),burnup(ind_seg),'linear','extrap');
    % Low void XS adjustment
    j=j_low_void(1);
    Lilow=length(ilow);
    xlo=zeros(Lilow,ncol);
    xlo(:,1)=DIST(ind_seg(ilow),x_id(j));
    for iw=2:ncol,
        xlo(:,iw)=xlo(:,1);
    end
    x=zeros(lseg,7);
    x(:,1)=DIST(ind_seg,x_id(j));
    for iw=1:7,
        x(:,iw)=x(:,1);
    end
    DyDxl=interp1(res_exp,pin_data(nexp+(j-2)*nrst+1:nexp+(j-1)*nrst,index+icol),burnup(ind_seg),'linear','extrap');
    jh=j_high_void(1);
    DyDxh=interp1(res_exp,pin_data(nexp+(jh-2)*nrst+1:nexp+(jh-1)*nrst,index+icol),burnup(ind_seg),'linear','extrap');    
    if tweekd,
        DyDxh1=DyDxh(:,1:7);
        DyDxl1=DyDxl(:,1:7);
        ab=[DyDxh1(:) DyDxl1(:)]*invA';
        A=reshape(ab(:,1),lseg,7);
        B=reshape(ab(:,2),lseg,7);
        DyDxd=2*A.*(x-bas(j))+B;
        xsdd(ind_seg,1:7)=xsdd(ind_seg,1:7)+seg_w(ind_seg,1:7).*DyDxd;
    end
    xsd(ind_seg(ilow),:)=xsd(ind_seg(ilow),:)+seg_w(ind_seg(ilow),:).*DyDxl(ilow,:);
    xs(ind_seg(ilow),:)=xs(ind_seg(ilow),:)+(xlo-bas(j)).*seg_w(ind_seg(ilow),:).*DyDxl(ilow,:);
    % High void XS adjustment
    j=j_high_void(1);
    Lihigh=length(ihigh);
    xhi=zeros(Lihigh,2);
    xhi(:,1)=DIST(ind_seg(ihigh),x_id(j));
    for iw=2:ncol,
        xhi(:,iw)=xhi(:,1);
    end
    xsd(ind_seg(ihigh),:)=xsd(ind_seg(ihigh),:)+seg_w(ind_seg(ihigh),:).*DyDxh(ihigh,:);
    xs(ind_seg(ihigh),:)=xs(ind_seg(ihigh),:)+(xhi-bas(j)).*seg_w(ind_seg(ihigh),:).*DyDxh(ihigh,:);    
    % Low void dnshis adjustment
    if ~is_water,
        j=j_low_void(2);
        DyDx=interp1(res_exp,pin_data(nexp+(j-2)*nrst+1:nexp+(j-1)*nrst,index+icol),burnup(ind_seg(ilow)),'linear','extrap');
        xs(ind_seg(ilow),:)=xs(ind_seg(ilow),:)+seg_w(ind_seg(ilow),:).*(xlo-bas(j)).*DyDx;
        % High void dnshis adjustment
        j=j_high_void(2);
        DyDx=interp1(res_exp,pin_data(nexp+(j-2)*nrst+1:nexp+(j-1)*nrst,index+icol),burnup(ind_seg(ihigh)),'linear','extrap');
        if ~isempty(ihigh),
            xs(ind_seg(ihigh),:)=xs(ind_seg(ihigh),:)+seg_w(ind_seg(ihigh),:).*(xhi-bas(j)).*DyDx;
        end
        % Tfuel XS adjustment
        j=j_tfu;
        x=zeros(length(ind_seg),2);
        x(:,1)=DIST(ind_seg,x_id(j));
        for iw=2:ncol,
            x(:,iw)=x(:,1);
        end
        DyDx=seg_w(ind_seg,:).*interp1(res_exp,pin_data(nexp+(j-2)*nrst+1:nexp+(j-1)*nrst,index+icol),burnup(ind_seg),'linear','extrap');
        xst(ind_seg,:)=xst(ind_seg,:)+DyDx;
        xs(ind_seg,:)=xs(ind_seg,:)+(x-bas(j)).*DyDx;
        % Tfuhis XS adjustment
        j=j_tfuhist;
        if ~isempty(j),
        x(:,1)=DIST(ind_seg,x_id(j));
        for iw=2:ncol,
            x(:,iw)=x(:,1);
        end
        DyDx=interp1(res_exp,pin_data(nexp+(j-2)*nrst+1:nexp+(j-1)*nrst,index+icol),burnup(ind_seg),'linear','extrap');
        xs(ind_seg,:)=xs(ind_seg,:)+seg_w(ind_seg,:).*(x-bas(j)).*DyDx;
        end
        % CRDhist
        j=find(x_id==11);j=j(1);      % crdhist
        x(:,1)=crdhist(ind_seg);
        for iw=2:ncol,
            x(:,iw)=x(:,1);
        end       
        Dydx=interp1(res_exp,pin_data(nexp+(j-2)*nrst+1:nexp+(j-1)*nrst,index+icol),burnup(ind_seg),'linear','extrap');
        xs(ind_seg,:)=xs(ind_seg,:)+seg_w(ind_seg,:).*(x-bas(j)).*Dydx;
    %end
    % CRD    
    jcrd=find(x_id==10);
    for i1=1:length(ncrd_list),
        for j1=1:2,
            ind_cr=find(seg_logic&cr{j1}(:)==ncrd_list(i1)); % Find the nodes with ncrd_list(i1) & segment i
            if ~isempty(ind_cr),
                %icrd_lib=find(X{i}.x{ind_x}==ncrd_list(i1))-1; % Find pos of cr-typ in lib-file
                icrd_lib=ncrd_list(i1)/10;
                j=jcrd(icrd_lib);
                Dydx=interp1(res_exp,pin_data(nexp+(j-2)*nrst+1:nexp+(j-1)*nrst,index+icol),burnup(ind_cr),'linear','extrap');
                cr_weight=zeros(length(ind_cr),2);
                cr_weight(:,1)=cr_w{j1}(ind_cr);
                for iw=2:ncol,
                    cr_weight(:,iw)=cr_weight(:,1);
                end
                xs(ind_cr,:)=xs(ind_cr,:)+seg_w(ind_cr,:).*cr_weight.*Dydx;
            end
        end
    end
    end
    end
end

isiga2=find(icol==23);
if ~isempty(isiga2), %If siga2 is calculated, look for xenon and samarium corrections
    idxe=find(icol==33);
    if ~isempty(idxe),
        xenon=fue_new.xenon(:,knum);xenon=xenon(:);
        dxe=xenon.*xs(:,idxe);
        xs(:,isiga2)=xs(:,isiga2)+dxe;
    end
    isam=find(icol==35);
    if ~isempty(isam),
        samarium=fue_new.samarium(:,knum);samarium=samarium(:);
        dsam=samarium.*xs(:,isam);
        xs(:,isiga2)=xs(:,isiga2)+dsam;
    end
end

if nargout>3,
    XS.cr=cr;
    XS.cr_w=cr_w;
    XS.cr_cusp=cr_cusp;
    XS.segmnt=segmnt;
    XS.segpos=segpos;
    XS.nseg=nseg;
    XS.niseg=niseg;
end
fclose(fid);