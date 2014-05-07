function [al,Beta]=read_beta_sim3(cd_file,resfile,dens,Tfm,XS,X,knum)
% Reads delayed groups from pin library in library file
%
% [al,Beta]=read_beta_sim3(cd_file,resinfo,dens,Tfm,XS,X,knum)
% or:
% [al,Beta]=read_beta_sim3(cd_file,fue_new,dens,Tfm,XS,X,knum)
%
% Input
%   cd_file - Library file
%   resfile - core properties, output of read_restart_bin or resinfo output
%             ReadRes
%   dens    - density g/cm^3
%   Tfm     - Fuel temperature, K
%   XS      - output from xs_cms
%   X       - output from xs_cms

% From SUBROUTINE TODO: Ask Tamer
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
if isstruct(resfile) % take care of fue_new, resinfo or filename as input
    if max(strcmp('core',fieldnames(resfile)))
        % resinfo
        resinfo = resfile;
        dat = ReadRes(resinfo,{'LIBRARY','BURNUP','VHIST','TFUHIST','CRDHIST'},1);
        fue_new = catstruct(dat.library,dat.resinfo.core);
        fue_new.burnup = dat.burnup;
        fue_new.vhist = dat.vhist;
        fue_new.tfuhist = dat.tfuhist;
        fue_new.crdhist = dat.crdhist;

    else
      % fue_new
      fue_new = resfile;
    end

elseif ischar(resfile)
      % filename
        resinfo = ReadRes(resfile,'full');
        dat = ReadRes(resinfo,{'LIBRARY','BURNUP','VHIST','TFUHIST','CRDHIST'},1);
        fue_new = catstruct(dat.library,dat.resinfo.core);
        fue_new.burnup = dat.burnup;
        fue_new.vhist = dat.vhist;
        fue_new.tfuhist = dat.tfuhist;
        fue_new.crdhist = dat.crdhist;
end



read_cd_file=1;
if nargin<7,
    knum=1:fue_new.kan;
end
if size(knum,2)==2&&size(knum,1)>2, knum=knum(:,1); end
if nargin>4,
    cr=XS.cr;
    cr_w=XS.cr_w;
    cr_cusp=XS.cr_cusp;
    if isfield(XS,'segmnt'),
        read_cd_file=0;
        segmnt=XS.segmnt;
        segpos=XS.segpos;
        nseg=XS.nseg;
        niseg=XS.niseg;
    end
else
    [cr,cr_w,cr_cusp]=konrod2crfrac(resfile);
    for i=1:3,
        cr{i}=cr{i}(:,knum);
        cr_w{i}=cr_w{i}(:,knum);
    end
    cr_cusp=cr_cusp(:,knum);
end

%%
burnup=fue_new.burnup(:,knum);
vhist=fue_new.vhist(:,knum);
tfuhist=fue_new.tfuhist(:,knum);
crdhist=fue_new.crdhist(:,knum);
zer=zeros(size(dens(:)));
burnup=burnup(:);
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
Beta=zeros(length(zer),6);
al=Beta;
fid=fopen(cd_file,'r','ieee-be');
%%
for i=1:length(seg_list),
  isegtmp=strmatch(fue_new.Segment(seg_list(i),:),segmnt);
  iseg(i)=isegtmp(1);
  if niseg{iseg(i)}(3,3)>2,         % Check that it is not water!
    iseg1=find(cseg==seg_list(i));
    iseg2=find(cseg2==seg_list(i));    
    ind_seg=[iseg1;iseg2];
    seg_logic=zer;seg_logic(ind_seg)=1;
    seg_w=zer;seg_w(iseg1)=w1(iseg1);
    seg_w(iseg2)=w2(iseg2);
    ipos=find(niseg{iseg(i)}(1,:)==10);
    fseek(fid,segpos(iseg(i),ipos),-1);
    dimen=fread(fid,5,'int');
    ifloat=dimen(5)/dimen(3)/dimen(2);
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
    j_low_void=[j_dens(1) j_denshis(1)];
    j_high_void=[j_dens(2) j_denshis(2)];
    for ig=1:6,
        Beta(ind_seg,ig)=Beta(ind_seg,ig)+seg_w(ind_seg).*interp1(exposur,pin_data(1:nexp,index+ig),burnup(ind_seg),'linear','extrap');
        al(ind_seg,ig)=al(ind_seg,ig)+seg_w(ind_seg).*interp1(exposur,pin_data(1:nexp,index+ig+6),burnup(ind_seg),'linear','extrap');
        for j=j_low_void,              % check which one should be used for dens and denshis, first the low-void ones
            ival=find(DIST(ind_seg,x_id(j))>=bas(j));
            if ~isempty(ival),
                x=DIST(ind_seg(ival),x_id(j));
                Dydx=interp1(res_exp,pin_data(nexp+(j-2)*nrst+1:nexp+(j-1)*nrst,index+ig),burnup(ind_seg(ival)),'linear','extrap');
                Beta(ind_seg(ival),ig)=Beta(ind_seg(ival),ig)+seg_w(ind_seg(ival)).*(x-bas(j)).*Dydx;
                Dydx=interp1(res_exp,pin_data(nexp+(j-2)*nrst+1:nexp+(j-1)*nrst,index+ig+6),burnup(ind_seg(ival)),'linear','extrap');
                al(ind_seg(ival),ig)=al(ind_seg(ival),ig)+seg_w(ind_seg(ival)).*(x-bas(j)).*Dydx;
            end
        end
        for j=j_high_void,          % Then the high void ones
            ival=find(DIST(ind_seg,x_id(j))<bas(j));
            if ~isempty(ival),
                x=DIST(ind_seg(ival),x_id(j));
                Dydx=interp1(res_exp,pin_data(nexp+(j-2)*nrst+1:nexp+(j-1)*nrst,index+ig),burnup(ind_seg(ival)),'linear','extrap');
                Beta(ind_seg(ival),ig)=Beta(ind_seg(ival),ig)+seg_w(ind_seg(ival)).*(x-bas(j)).*Dydx;
                Dydx=interp1(res_exp,pin_data(nexp+(j-2)*nrst+1:nexp+(j-1)*nrst,index+ig+6),burnup(ind_seg(ival)),'linear','extrap');
                al(ind_seg(ival),ig)=al(ind_seg(ival),ig)+seg_w(ind_seg(ival)).*(x-bas(j)).*Dydx;
            end
        end
        j_tfu=find(x_id==4);
        j_tfuhist=find(x_id==5);
        for j=[j_tfu(1) j_tfuhist],              % Then tfu and tfuhist 
            x=DIST(ind_seg,x_id(j));
            Dydx=interp1(res_exp,pin_data(nexp+(j-2)*nrst+1:nexp+(j-1)*nrst,index+ig),burnup(ind_seg),'linear','extrap');
            Beta(ind_seg,ig)=Beta(ind_seg,ig)+seg_w(ind_seg).*(x-bas(j)).*Dydx;
            Dydx=interp1(res_exp,pin_data(nexp+(j-2)*nrst+1:nexp+(j-1)*nrst,index+ig+6),burnup(ind_seg),'linear','extrap');
            al(ind_seg,ig)=al(ind_seg,ig)+seg_w(ind_seg).*(x-bas(j)).*Dydx;
        end
        j=find(x_id==11);j=j(1);      % crdhist
        x=crdhist(ind_seg);
        Dydx=interp1(res_exp,pin_data(nexp+(j-2)*nrst+1:nexp+(j-1)*nrst,index+ig),burnup(ind_seg),'linear','extrap');
        Beta(ind_seg,ig)=Beta(ind_seg,ig)+seg_w(ind_seg).*(x-bas(j)).*Dydx;
        Dydx=interp1(res_exp,pin_data(nexp+(j-2)*nrst+1:nexp+(j-1)*nrst,index+ig+6),burnup(ind_seg),'linear','extrap');
        al(ind_seg,ig)=al(ind_seg,ig)+seg_w(ind_seg).*(x-bas(j)).*Dydx;
        jcrd=find(x_id==10);
        for i1=1:length(ncrd_list),
             for j1=1:2, 
                ind_cr=find(seg_logic&cr{j1}(:)==ncrd_list(i1)); % Find the nodes with ncrd_list(i1) & segment i
                if ~isempty(ind_cr),
                    x=cr{j1}(ind_cr);
                    ind_x=find(X{i}.id==1010);
                    icrd_lib=find(X{i}.x{ind_x}==ncrd_list(i1))-1; % Find pos of cr-typ in lib-file
                    j=jcrd(icrd_lib);
                    Dydx=interp1(res_exp,pin_data(nexp+(j-2)*nrst+1:nexp+(j-1)*nrst,index+ig),burnup(ind_cr),'linear','extrap');
                    Beta(ind_cr,ig)=Beta(ind_cr,ig)+seg_w(ind_cr).*cr_w{j1}(ind_cr).*Dydx;
                    Dydx=interp1(res_exp,pin_data(nexp+(j-2)*nrst+1:nexp+(j-1)*nrst,index+ig+6),burnup(ind_cr),'linear','extrap');
                    al(ind_cr,ig)=al(ind_cr,ig)+seg_w(ind_cr).*cr_w{j1}(ind_cr).*Dydx;
                end
             end
        end
    end
  end
end
al=al';
Beta=Beta';
fclose(fid);