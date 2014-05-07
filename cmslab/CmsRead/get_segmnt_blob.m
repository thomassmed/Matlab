function [out1,X2D,Y2D,V3D,X3D,Y3D,Z3D,X,Y]=get_segmnt_blob(cdfile,iseg,xstype,nxsec,segpos,niseg)
% [V2D,X2D,Y2D,V3D,X3D,Y3D,Z3D,X,Y]=get_segmnt_blob(cdfile,iseg,xstype,nxsec,segpos,niseg)
%
%   cdfile - cd-filename
%   xstype - 3 - Macroscopic crosssections
%            4 - Discontinuity factors
%           92 - static info, #5 is weight
%
%   nxsec:  1 - D1
%           2 - D2
%           3 - SIGR
%           4 - SIGA1
%           5 - SIGA2
%           6 - NSIGF1
%           7 - NSIGF2
%           8 - KAP/NU
%
%
% Example: 
%
% [segmnt,segpos,nseg,niseg]=read_cdfile('cd-file.lib');
% [V2D,X2D,Y2D,V3D,X3D,Y3D,Z3D,X,Y]=get_segmnt_blob('cd-file.lib',82,3,1:8,segpos,niseg);
% Builds the matrices needed for interpolation for segment 82 on the
% cd-file
%
%

%
%

%%
if nargin<2, nxsec=(1:8)';xstype=3;end
if nargin<4, [segmnt,segpos,nseg,niseg]=read_cdfile(cdfile); end
if ischar(iseg), iseg=strmatch(iseg,segmnt);end
%% Initialize
fid=fopen(cdfile,'r','ieee-be');
nxsec=nxsec(:);
if any(nxsec==5),
    nxsec=[nxsec;5.02;5.04];
end
int='int32';float='float32';ifloat=4;
n_xstype=find(niseg{iseg}(1,:)==xstype);
fseek(fid,segpos(iseg,n_xstype),-1);
nnseg=fread(fid,3,int);         % Should be the same as niseg(:,iseg)!!
blk_size=nnseg(2)*ifloat;
fseek(fid,8,0);
%%
    n_x=0;
    n_y=0;
    n3D=0*ones(size(nxsec));n1D=n3D;
    n2D=0*ones(size(nxsec));
    i1plus=0;
    for i1=1:nnseg(3),
        if (i1+i1plus)>nnseg(3), break;end
        id_num(i1+i1plus)=round(100*fread(fid,1,float))/100;
        if id_num(i1+i1plus)>1000&&id_num(i1+i1plus)<1100,          %independent variabel
            n_x=n_x+1;
            id_x(n_x)=id_num(i1+i1plus);
            nx(n_x)=fread(fid,1,float);
            x{n_x}=fread(fid,nx(n_x),float);
            nbas(n_x)=round(fread(fid,1,float));
            xcasmo{n_x}=fread(fid,nx(n_x),float);
            xbas(n_x)=x{n_x}(nbas(n_x));
            fseek(fid,blk_size-4*(2*nx(n_x)+3),0);
        else
            in_list=find(abs(id_num(i1+i1plus))==nxsec);
            if ~isempty(in_list),
                n_y=n_y+1;
                id_y(n_y)=id_num(i1+i1plus);
                firstrow=fread(fid,4,float);
                if length(find(firstrow(1:3)))==3,              %3D-interpolation
                    n3D(in_list)=n3D(in_list)+1;
                    intp_ind_3D{in_list}(n3D(in_list),1:3)=firstrow(1:3);
                    interp_typ(n_y)=3;
                    nx1=nx(find((id_x-1000)==firstrow(1)));
                    nx2=nx(find((id_x-1000)==firstrow(2)));
                    nx3=nx(find((id_x-1000)==firstrow(3)));                    
                    npoints(n_y)=nx1*nx2*nx3;
                    data{n_y}=zeros(1,npoints(n_y));
                    n_iter=1; %TODO: check the logic in SUBROUTINE STDATA in CMSLINK if this casuses problems
                    if npoints(n_y)>(nnseg(2)-5), n_iter=nx3;end 
                    i1plus=i1plus+n_iter-1;
                    start_index=1;stop_index=nx1*nx2;
                    data{n_y}(start_index:stop_index)=fread(fid,stop_index-start_index+1,float);
                    if (nnseg(2)-5)>nx1*nx2, fseek(fid,blk_size-(5+nx1*nx2)*ifloat,0); end
                    for i2=2:n_iter,
                        fseek(fid,5*ifloat,0);
                        start_index=stop_index+1;
                        stop_index=stop_index+nx1*nx2;
                        data{n_y}(start_index:stop_index)=fread(fid,stop_index-start_index+1,float);
                        if (nnseg(2)-5)>nx1*nx2, fseek(fid,blk_size-(5+nx1*nx2)*ifloat,0); end
                    end
                elseif length(find(firstrow(1:3)))==2                            %2D-interpolation
                    n2D(in_list)=n2D(in_list)+1;
                    intp_ind_2D{in_list}(n2D(in_list),1:2)=firstrow(1:2);
                    interp_typ(n_y)=2;
                    nx1=nx(find((id_x-1000)==firstrow(1)));
                    nx2=nx(find((id_x-1000)==firstrow(2)));
                    npoints(n_y)=nx1*nx2;
                    data{n_y}=zeros(1,npoints(n_y));
                    if npoints(n_y)>nnseg(2)-5,   
                        n_iter=ceil(npoints(n_y)/(nnseg(2)-5));
                        i1plus=i1plus+n_iter-1;
                        start_index=1;stop_index=nnseg(2)-5;
                        data{n_y}(start_index:stop_index)=fread(fid,stop_index-start_index+1,float);
                        for i2=2:n_iter,
                            fseek(fid,5*ifloat,0);
                            start_index=stop_index+1;stop_index=stop_index+nnseg(2)-5;
                            data{n_y}(start_index:stop_index)=fread(fid,stop_index-start_index+1,float);
                        end
                    else
                        start_index=1;stop_index=nx1*nx2;
                        data{n_y}(start_index:stop_index)=fread(fid,stop_index-start_index+1,float);                        
                        fseek(fid,blk_size-(5+nx1*nx2)*ifloat,0);
                    end
                elseif length(find(firstrow(1:3)))==1,                            %1D-interpolation
                    n1D(in_list)=n1D(in_list)+1;
                    interp_typ(n_y)=1;
                    i_f_row=find(firstrow(1:3));
                    nx1=nx(find((id_x-1000)==firstrow(i_f_row)));
                    intp_ind_1D{in_list}(n1D(in_list),1:2)=firstrow(i_f_row);
                    npoints(n_y)=nx1;
                    start_index=1;stop_index=nx1;
                    data{n_y}(start_index:stop_index)=fread(fid,stop_index-start_index+1,float);                        
                    fseek(fid,blk_size-(5+nx1)*ifloat,0);
                end
            else
                fseek(fid,blk_size-ifloat,0);
            end
        end
    end
%% All read is done, close the file
fclose(fid);

%%  First set up all 3D-tables 

if exist('intp_ind_3D','var'),
  for i=1:length(intp_ind_3D),
    i00=find(abs(id_y)==nxsec(i)&interp_typ==3);
    for ii=1:size(intp_ind_3D{i},1)
        v2dcr={};
        if ~isempty(intp_ind_3D{i})
            ix1=find((id_x-1000)==intp_ind_3D{i}(ii,1));
            ix2=find((id_x-1000)==intp_ind_3D{i}(ii,2));
            ix3=find((id_x-1000)==intp_ind_3D{i}(ii,3));
            i_data=i00(ii);
            if intp_ind_3D{i}(ii,2)==10,      % Not truly 3-D interpolation, make several 2D instead
                v2dcr{1}=[ix1 ix3];           % Makes it real easy to figure out the independent variables later on
                for i2=1:length(x{ix2}),
                    for i3=1:nx(ix3)
                        i1=1:nx(ix1);
                        index=(i3-1)*nx(ix2)*nx(ix1)+(i2-1).*nx(ix1)+i1;
                        v2dcr{i2+1}(i3,i1)=data{i_data}(index);
                    end
                end
                V3D{i,ii}=v2dcr;
            elseif intp_ind_3D{i}(ii,3)==10,                        % Not truly 3-D interpolation, make several 2D instead
                v2dcr{1}=[ix1 ix2];
                for i3=1:length(x{ix3}),
                    for i2=1:nx(ix2)
                        i1=1:nx(ix1);
                        index=(i3-1)*nx(ix2)*nx(ix1)+(i2-1).*nx(ix1)+i1;
                        v2dcr{i3+1}(i2,i1)=data{i_data}(index);
                    end
                end                
                V3D{i,ii}=v2dcr;
            else
                V3D{i,ii}=zeros(nx(ix2),nx(ix1),nx(ix3));
                for i3=1:nx(ix3)
                    i2=1:nx(ix2);
                    i1=1:nx(ix1);
                    [I2,I1]=meshgrid(i2,i1);
                    index=(i3-1)*nx(ix2)*nx(ix1)+(I2-1).*nx(ix1)+I1;
                    V3D{i,ii}(i2,i1,i3)=data{i_data}(index)';
                end;
            end
        end
    end
  end
%% Set up independent variables for 3D interpolation
  for i=1:size(V3D,2),
   ix(i,1)=find((id_x-1000)==intp_ind_3D{1}(i,1));
   ix(i,2)=find((id_x-1000)==intp_ind_3D{1}(i,2));
   ix(i,3)=find((id_x-1000)==intp_ind_3D{1}(i,3));
    if ~iscell(V3D{1,i})
        [X3D{i},Y3D{i},Z3D{i}]=meshgrid(x{ix(i,1)},x{ix(i,2)},x{ix(i,3)});
    else
        [X3D{i},Y3D{i}]=meshgrid(x{V3D{1,i}{1}(1)},x{V3D{1,i}{1}(2)});
    end
  end
%%    Then set up all 2D-tables
  for i=1:length(intp_ind_2D),
    i00=find(abs(id_y)==nxsec(i)&interp_typ==2);
    for ii=1:size(intp_ind_2D{i},1)
        ix1=find((id_x-1000)==intp_ind_2D{i}(ii,1));
        ix2=find((id_x-1000)==intp_ind_2D{i}(ii,2));
        i_data=i00(ii);
        for i2=1:nx(ix2),
                i1=1:nx(ix1);
                index=(i2-1)*nx(ix1)+i1;
                V2D{i,ii}(i2,i1)=data{i_data}(index);
        end
    end
  end
%% Set up independent variables for 2D interpolation
  for i=1:size(V2D,2),
    ix2(i,1)=find((id_x-1000)==intp_ind_2D{1}(i,1));
    ix2(i,2)=find((id_x-1000)==intp_ind_2D{1}(i,2));
    [X2D{i},Y2D{i}]=meshgrid(x{ix2(i,1)},x{ix2(i,2)});
  end
else
    % Water
    V3D={};
    X3D={};
    Y3D={};
    Z3D={};
    Y2D={};
    ix=[];
    intp_ind_3D={};
    intp_ind_2D={};
    ix2(1,1)=find((id_x-1000)==intp_ind_1D{1}(1,1));
    X2D=x;
    for i=1:length(data)
        V2D{i}=data{i};
    end          
end        

%% Prepare output variables
% Independent variables
X.id=id_x;
X.x=x;
X.nx=nx;
X.xbas=xbas;
X.casmo=xcasmo;
X.ix=ix;
X.ix2=ix2;
% Dependent variables
Y.id=id_y;
Y.int3D=intp_ind_3D;
Y.int2D=intp_ind_2D;
Y.interp_typ=interp_typ;
Y.npoints=npoints;
if nargout==1,
    out1.V2D=V2D;
    out1.X2D=X2D;
    out1.Y2D=Y2D;
    out1.V3D=V3D;
    out1.X3D=X3D;
    out1.Y3D=Y3D;
    out1.Z3D=Z3D;
    out1.X=X;
    out1.Y=Y;
else
    out1=V2D;
end
