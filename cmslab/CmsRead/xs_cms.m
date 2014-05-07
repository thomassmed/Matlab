function varargout=xs_cms(varargin)
% Read cross section from library file
%
% Example:
% First call:
%
% [d1,d2,sigr,siga1,siga2,usig1,usig2,kap_ny,V2D,X2D,Y2D,V3D,X3D,Y3D,Z3D,X,Y,XS,XSEC_DX2]=xs_cms(resinfo,cd_file,dens,Tfm,knum);
% [d1,d2,sigr,siga1,siga2,usig1,usig2,kap_ny,V2D,X2D,Y2D,V3D,X3D,Y3D,Z3D,X,Y,XS,XSEC_DX2]=xs_cms(fue_new,cd_file,dens,Tfm,knum);
% [d1,d2,sigr,siga1,siga2,usig1,usig2,kap_ny,V2D,X2D,Y2D,V3D,X3D,Y3D,Z3D,X,Y,XS,XSEC_DX2]=xs_cms(restart_file,cd_file,dens,Tfm,knum);
%
%
% Subsequent calls for same case (assuming only Tfm and dens change)
%[d1,d2,sigr,siga1,siga2,usig1,usig2,kap_ny]=xs_cms(resinfo,dens,Tfm,V2D,X2D,Y2D,V3D,X3D,Y3D,Z3D,X,Y,XS,XSEC_DX2,knum)
%
% See also ReadRes, read_restart_bin

%%
%global polca

if nargin<13,           % Assume first call
    read_cd_file=1;
    resfile=varargin{1};
    cd_file=varargin{2};
    dens=varargin{3};
    Tfm=varargin{4};
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
        knum=fue_new.knum(:,1);
    else
        knum=varargin{5};
    end
    [segmnt,segpos,nseg,niseg]=read_cdfile(cd_file);
    if nargin>5,
        df=varargin{6};
    else
        df=0;
    end
else
    read_cd_file=0;
    resfile=varargin{1};
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
    if nargin>14,
        knum=varargin{15};
    else
        if max(strcmp('core',fieldnames(resfile)))
            knum=1:resinfo.core.kan;
        else
            knum=1:fue_new.kan;
        end
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

i_crd1=find(crdhist(:)>1);
crdhist(i_crd1)=1;
DIST{1}=burnup(:);
DIST{2}=dens(:);
DIST{3}=vhist(:);
DIST{4}=sqrt(Tfm(:));
DIST{5}=tfuhist(:);
DIST{8}=zer; %Boron TODO: fix this properly with Boron from the restartfile
DIST{10}=zer;
DIST{11}=crdhist(:);
DIST{18}=zer;

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
    df=XS.df;
    cr_gray=XS.cr_gray;
    ncrd_list=XS.ncrd_list;
    iseg=XS.seg_lib;
end
%%
zeroo=zeros(size(dens));
for ix=1:10,
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
            get_segmnt_blob(cd_file,iseg(i),3,1:8,segpos,niseg);
        X{i}.segment=deblank(fue_new.Segment(seg_list(i),:));
    end
   if isempty(V3D{i}),
        for ix=1:length(V2D{i})
            indx=ind_seg{i};
            if ~isempty(indx),
                XSEC{ix}(indx)=XSEC{ix}(indx)+seg_w(indx).*interp1(X2D{i}{1}',V2D{i}{ix},dens(indx),'linear','extrap');
            end
        end        % Water XS
   else
    for ix=1:size(V3D{i},1),
        X0=xsinterp3(X3D{i}{1},Y3D{i}{1},Z3D{i}{1},V3D{i}{ix,1},DIST{X{i}.id(X{i}.ix(1,1))-1000}(ind_seg{i}),...
                   DIST{X{i}.id(X{i}.ix(1,2))-1000}(ind_seg{i}),DIST{X{i}.id(X{i}.ix(1,3))-1000}(ind_seg{i}));
        XSEC{ix}(ind_seg{i})=XSEC{ix}(ind_seg{i})+seg_w(ind_seg{i}).*X0;
    end
    for j=2:size(V3D{i},2),
        if iscell(V3D{i}{1,j}),         % CR 2D interpolation
            ix1=X{i}.id(V3D{i}{1,j}{1}(1))-1000;ix2=X{i}.id(V3D{i}{1,j}{1}(2))-1000;
            for i1=1:length(ncrd_list), % Loop over number of cr-types
                for j1=1:2,             % Loop over possible cr contents in a node
                    icrd0=find(seg_logic&cr{j1}(:)==ncrd_list(i1));
                    if max(icrd0)>0,
                        ind_x=find(X{i}.id==1010);
                        iv3d=find(X{i}.x{ind_x}==ncrd_list(i1))+1; % +1, since the index-info is in pos 1
                        for ix=1:size(V3D{i},1),   % Now weigh the content of the particular segment
                            XCR=DIST{ix1}(icrd0);
                            YCR=DIST{ix2}(icrd0);
                            XSEC_CR{ix}(icrd0)=XSEC_CR{ix}(icrd0)+cr_gray{j1}(icrd0).*cr_w{j1}(icrd0).*seg_w(icrd0).*...
                            xsinterp2(X3D{i}{j},Y3D{i}{j},V3D{i}{ix,j}{iv3d},XCR,YCR);
                        end                                         
                    end                 
                end
            end
            if (ix1==1011||ix2==1011),  % crdhist for non-controlled nodes
                icrd0=find(seg_logic&cr{1}(:)==0);
                for ix=1:size(V3D{i},1),
                    XCR=DIST{ix1}(icrd0);
                    YCR=DIST{ix2}(icrd0);
                    XSEC_CR{ix}(icrd0)=XSEC_CR{ix}(icrd0)+seg_w(icrd0).*...
                        xsinterp2(X3D{i}{j},Y3D{i}{j},V3D{i}{ix,j}{2},XCR,YCR);
                end
            end
        else                                     % True 3D interpolation
            for ix=1:size(V3D{i},1),
                X0=xsinterp3(X3D{i}{j},Y3D{i}{j},Z3D{i}{j},V3D{i}{ix,j},DIST{X{i}.id(X{i}.ix(j,1))-1000}(ind_seg{i}),...
                           DIST{X{i}.id(X{i}.ix(j,2))-1000}(ind_seg{i}),DIST{X{i}.id(X{i}.ix(j,3))-1000}(ind_seg{i}));
                XSEC_DX{ix}(ind_seg{i})=XSEC_DX{ix}(ind_seg{i})+seg_w(ind_seg{i}).*X0;     
            end
        end
    end
    if read_cd_file,
         for ix=1:size(V2D{1},1),
            X0=xsinterp2(X2D{i}{1},Y2D{i}{1},V2D{i}{ix},DIST{X{i}.id(X{i}.ix2(1,1))-1000}(ind_seg{i}),...
                DIST{X{i}.id(X{i}.ix2(1,2))-1000}(ind_seg{i}));
            XSEC_DX2{ix}(ind_seg{i})=XSEC_DX2{ix}(ind_seg{i})+seg_w(ind_seg{i}).*X0;
        end
    end
   end
end
%% Now, collect the XS for all segments and put them in the appropriate position in the core


 % Take care of water XS first




%% Set up the output variables

for ix=1:8,
    XSEC_CR{ix}=XSEC_CR{ix}.*cr_cusp;
    varargout{ix}=XSEC{ix}+XSEC_DX2{ix}+XSEC_DX{ix}+XSEC_CR{ix};
end



xenon=fue_new.xenon(:,knum);
samarium=fue_new.samarium(:,knum);
%xenon=10e-24*polca.Xenon;
%xenon=xenon(:,knum);
if size(varargout{1},2)==1,
    xenon=xenon(:);
    samarium=samarium(:);
end

varargout{5}=varargout{5}+(XSEC{9}+XSEC_DX2{9}+XSEC_DX{9}+XSEC_CR{9}).*xenon;
varargout{5}=varargout{5}+(XSEC{10}+XSEC_DX2{10}+XSEC_DX{10}+XSEC_CR{10}).*samarium;



% Fudge disc factors for 1.5 group
if df,
    wcr=cr_w{1}.*(cr{1}>0)+cr_w{2}.*(cr{2}>0)+cr_w{3}.*(cr{3}>0);
    df1=1+(wcr>0.5)*.1;
    for i=[1 3 4 6]
        varargout{i}=varargout{i}./df1;
    end
    
    df2=1+(wcr>0.5)*.25;
    for i=[2 5 7]
        varargout{i}=varargout{i}./df2;
    end
end

if read_cd_file,
    varargout{9}=V2D;
    varargout{10}=X2D;
    varargout{11}=Y2D;
    varargout{12}=V3D;
    varargout{13}=X3D;
    varargout{14}=Y3D;
    varargout{15}=Z3D;
    varargout{16}=X;
    varargout{17}=Y;
    XS.cr=cr;
    XS.cr_w=cr_w;
    XS.cr_cusp=cr_cusp;
    XS.df=df;
    XS.cr_gray=cr_gray;
    XS.ncrd_list=ncrd_list;
    XS.seg_lib=iseg;
    XS.seg_rst=seg_list';
    XS.seg_CMSXS=1:length(seg_list);
    XS.segmnt=segmnt;
    XS.segpos=segpos;
    XS.nseg=nseg;
    XS.niseg=niseg;
    varargout{18}=XS;
    varargout{19}=XSEC_DX2;
%     varargout{20}=
end



