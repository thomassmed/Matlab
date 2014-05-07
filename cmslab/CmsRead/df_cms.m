function varargout=df_cms(varargin)
% Read discontinuity factors from library file
%
% Example:
% First call:
% [f1w,f1s,f2w,f2s,V2Ddf,X2Ddf,Y2Ddf,V3Ddf,X3Ddf,Y3Ddf,Z3Ddf,Xdf,Ydf,XSdf,XSEC_DX2df]=df_cms(fue_new,cd_file,dens,Tfm,knum);
% or:
% [f1w,f1s,f2w,f2s,V2Ddf,X2Ddf,Y2Ddf,V3Ddf,X3Ddf,Y3Ddf,Z3Ddf,Xdf,Ydf,XSdf,XSEC_DX2df]=xs_cms(restart_file,cd_file,dens,Tfm,knum);
%
%
% Subsequent calls for same case (assuming only Tfm and dens change)
% [f1w,f1s,f2w,f2s]=xs_cms(fue_new,dens,Tfm,V2Ddf,X2Ddf,Y2Ddf,V3Ddf,X3Ddf,Y3Ddf,Z3Ddf,Xdf,Ydf,XSdf,XSEC_DX2df,knum)
%
% See also read_restart_bin, xs_cms

%%
%global polca

if nargin<13,           % Assume first call
    read_cd_file=1;
    resfile=varargin{1};
    cd_file=varargin{2};
    dens=varargin{3};
    Tfm=varargin{4};
    if isstruct(resfile)% take care of fue_new, resinfo or filename as input
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

    if nargin<5,
        knum=1:fue_new.kan;
    else
        knum=varargin{5};
    end
    [segmnt,segpos,nseg,niseg]=read_cdfile(cd_file);
else
    read_cd_file=0;
    fue_new=varargin{1};
    dens=varargin{2};
    Tfm=varargin{3};
    V2D=varargin{4};
    X2D=varargin{5};
    Y2D=varargin{6};
    V3D=varargin{7};
    X3D=varargin{8};
    Y3D=varargin{9};
    Z3D=varargin{10};
    X=varargin{11};
    Y=varargin{12};
    XS=varargin{13};
    XSEC_DX2=varargin{14};
    if nargin>14,
        knum=varargin{15};
    else
        knum=1:fue_new.kan;
    end
end

if size(knum,2)==2&&size(knum,1)>2, knum=knum(:,1); end

if max(dens)>100, dens=dens/1000; end

kan=fue_new.kan;kmax=fue_new.kmax;

%% Sort the Core Segments
w1=fue_new.Seg_w{1};w1=w1(:,knum);w1=w1(:);
w2=fue_new.Seg_w{2};w2=w2(:,knum);w2=w2(:);
cseg=fue_new.Core_Seg{1}(:,knum);cseg=cseg(:);
cseg2=fue_new.Core_Seg{2}(:,knum);cseg2=cseg2(:);
csegtot=[cseg;cseg2];
seg_list=unique(csegtot);ibort=find(seg_list==0);seg_list(ibort)=[];
%% Set up the independent variables
burnup=fue_new.burnup(:,knum);
vhist=fue_new.vhist(:,knum);
tfuhist=fue_new.tfuhist(:,knum);
crdhist=fue_new.crdhist(:,knum);
zer=zeros(size(dens(:)));

i_crd1= crdhist(:)>1;
crdhist(i_crd1)=1;
DIST=[burnup(:) dens(:) vhist(:) sqrt(Tfm(:)) tfuhist(:) zer crdhist(:)];
%TODO: DIST is presently hard-code on the "wrong level"

if read_cd_file,
    [cr,cr_w,cr_cusp,cr_gray]=konrod2crfrac(resfile);
    for i=1:3,
        cr{i}=cr{i}(:,knum);
        cr_gray{i}=cr_gray{i}(:,knum);
        cr_w{i}=cr_w{i}(:,knum);
    end
    cr_cusp=cr_cusp(:,knum);
    if size(dens,2)==1,
        cr_cusp=cr_cusp(:);
    end
    ncrd_list=unique([cr{1};cr{2};cr{3}]);
    ncrd_list=ncrd_list(find(ncrd_list));   % Remove zero entry
else
    cr=XS.cr;
    cr_w=XS.cr_w;
    cr_cusp=XS.cr_cusp;
    cr_gray=XS.cr_gray;
    ncrd_list=XS.ncrd_list;
    iseg=XS.seg_lib;
end
%%
zeroo=zeros(size(dens));
for ix=[1 2 5 6],
    XSEC{ix}=zeroo;
    if read_cd_file,
        XSEC_DX2{ix}=zeroo;
    end
    XSEC_DX{ix}=zeroo;
    XSEC_CR{ix}=zeroo;
end
for i=1:length(seg_list),
    iseg1=find(cseg==seg_list(i));
    iseg2=find(cseg2==seg_list(i));    
    ind_seg{i}=[iseg1;iseg2];
    seg_logic=zer;seg_logic(ind_seg{i})=1;
    seg_w=zer;seg_w(iseg1)=w1(iseg1);
    seg_w(iseg2)=w2(iseg2);
    if read_cd_file,
        iseg_i=strmatch(fue_new.Segment(seg_list(i),:),segmnt);
        iseg(i)=iseg_i(1);
    end
    if read_cd_file,
        [V2D{i},X2D{i},Y2D{i},V3D{i},X3D{i},Y3D{i},Z3D{i},X{i},Y{i}]=...
            get_segmnt_blob(cd_file,iseg(i),4,1:6,segpos,niseg);
    end
   if isempty(V3D{i}),
        for ix=[1 2 5 6],
            indx=ind_seg{i};
            if ~isempty(indx),
                XSEC{ix}(indx)=XSEC{ix}(indx)+seg_w(indx).*interp1(X2D{i}{1}',V2D{i}{ix},dens(indx),'linear','extrap');
            end
        end        % Water XS
   else
    for ix=[1 2 5 6],
        X0=xsinterp3(X3D{i}{1},Y3D{i}{1},Z3D{i}{1},V3D{i}{ix,1},DIST(ind_seg{i},X{i}.ix(1,1)),...
            DIST(ind_seg{i},X{i}.ix(1,2)),DIST(ind_seg{i},X{i}.ix(1,3)));
        XSEC{ix}(ind_seg{i})=XSEC{ix}(ind_seg{i})+seg_w(ind_seg{i}).*X0;
    end
    for j=2:size(V3D{i},2),
        if iscell(V3D{i}{1,j}),         % CR 2D interpolation
            ix1=V3D{i}{1,j}{1}(1);ix2=V3D{i}{1,j}{1}(2);
            for i1=1:length(ncrd_list), % Loop over number of cr-types
                for j1=1:2,             % Loop over possible cr contents in a node
                    icrd0=find(seg_logic&cr{j1}(:)==ncrd_list(i1));
                    if max(icrd0)>0,
                        ind_x=find(X{i}.id==1010);
                        iv3d=find(X{i}.x{ind_x}==ncrd_list(i1))+1; % +1, since the index-info is in pos 1
                        for ix=[1 2 5 6],   % Now weigh the content of the particular segment
                            XSEC_CR{ix}(icrd0)=XSEC_CR{ix}(icrd0)+cr_gray{j1}(icrd0).*cr_w{j1}(icrd0).*seg_w(icrd0).*...
                            xsinterp2(X3D{i}{j},Y3D{i}{j},V3D{i}{ix,j}{iv3d},DIST(icrd0,ix1),DIST(icrd0,ix2));
                        end                                         
                    end                 
                end
            end
            id_x1=X{i}.id(ix1);id_x2=X{i}.id(ix2);
            if (id_x1==1011||id_x2==1011),  % crdhist for non-controlled nodes
                icrd0=find(seg_logic&cr{1}(:)==0);
                for ix=[1 2 5 6],
                    XSEC_CR{ix}(icrd0)=XSEC_CR{ix}(icrd0)+seg_w(icrd0).*...
                        xsinterp2(X3D{i}{j},Y3D{i}{j},V3D{i}{ix,j}{2},DIST(icrd0,ix1),DIST(icrd0,ix2));
                end
            end
        else                                     % True 3D interpolation
            for ix=[1 2 5 6],
                XSEC_DX{ix}(ind_seg{i})=XSEC_DX{ix}(ind_seg{i})+...
                    seg_w(ind_seg{i}).*xsinterp3(X3D{i}{j},Y3D{i}{j},Z3D{i}{j},V3D{i}{ix,j},...
                    DIST(ind_seg{i},X{i}.ix(j,1)),DIST(ind_seg{i},X{i}.ix(j,2)),DIST(ind_seg{i},X{i}.ix(j,3)));
            end
        end
    end
    if read_cd_file,
        for ix=[1 2 5 6],
            X0=xsinterp2(X2D{i}{1},Y2D{i}{1},V2D{i}{ix},DIST(ind_seg{i},X{i}.ix2(1,1)),DIST(ind_seg{i},X{i}.ix2(1,2)));
            XSEC_DX2{ix}(ind_seg{i})=XSEC_DX2{ix}(ind_seg{i})+seg_w(ind_seg{i}).*X0;
        end
    end
   end
end
%% Now, collect the XS for all segments and put them in the appropriate position in the core


 % Take care of water XS first




%% Set up the output variables
icount=1;
for ix=[1 2 5 6],
    XSEC_CR{ix}=XSEC_CR{ix}.*cr_cusp;
    varargout{icount}=XSEC{ix}+XSEC_DX2{ix}+XSEC_DX{ix}+XSEC_CR{ix};
    icount=icount+1;
end

if read_cd_file,
    varargout{5}=V2D;
    varargout{6}=X2D;
    varargout{7}=Y2D;
    varargout{8}=V3D;
    varargout{9}=X3D;
    varargout{10}=Y3D;
    varargout{11}=Z3D;
    varargout{12}=X;
    varargout{13}=Y;
    XS.cr=cr;
    XS.cr_w=cr_w;
    XS.cr_cusp=cr_cusp;
    XS.cr_gray=cr_gray;
    XS.ncrd_list=ncrd_list;
    XS.seg_lib=iseg;
    XS.seg_rst=seg_list';
    XS.seg_CMSXS=1:length(seg_list);
    varargout{14}=XS;
    varargout{15}=XSEC_DX2;
end



