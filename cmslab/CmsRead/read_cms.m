% Reads .cms output files from cms. Reads files both with and without node-distributed data.
%
% [cmsinfo,ScalarData,NodeData,ScalarStruct,dim,info] = read_cms(filename);
%
% Input:
%   filename - cms input file
% 
% Output:
%   cmsinfo - info about cms file:
%             cmsinfo.ScalarNames - cell array with names on scalar quantities
%             cmsinfo.DistNames   - cell array with names on 2D and 3D distributions
%             cmsinfo.constants - genaral info on core
%             cmsinfo.filters - general filter info for scalars
%             cmsinfo.serial - cell array of serial numbers of assemblies in core
%             cmsinfo.core - general info about core
%             cmsinfo.file - info about addresses on file
%   ScalarData - Matrix with numerical values on scalars for each state point 
%   NodeData   - Cell aray with 2D and 3D distributions
%   ScalarStruct - Same data as in ScalarData, but in a strucrured variable
%   dim        - dimension information
%   info       - detailed information for each state point
%
% Examples:
% [cmsinfo,ScalarData]=read_cms('0000-4000.cms'); % Reads scalar data
% [cmsinfo,ScalarData,NodeData]=read_cms('0000-4000.cms'); % Reads scalar and Nodal data
% [cmsinfo,ScalarData,NodeData,ScalarStruct]=read_cms('0000-4000.cms');
%  plot(ScalarStruct.ElapsedTime_sec,ScalarStruct.RelativePower);
%
% See also read_cms_scalar, read_cms_dist, s3kexample

% ReadCMS, Version: 0.1                                              
% 2009-07-17                                                                 
% Forsmarks Kraftgrupp AB                                           
% Written by: Erik Wejander, contact: erik@wejander.se            
%  Modified by Thomas Smed August 2009
%  Modified by Dan Hagrman Nov 2009


function  [varargout] = read_cms(filename,varargin)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Part 1 - Check file permissions, versions, determine actions and retrieve some dim info
if isempty(strfind(filename,'.cms')),
    [path,name,ext]=fileparts(filename);
    %filename=[filename,'.cms'];
end
fid = fopen(filename, 'r','ieee-be'); %Open file for reading with BIG endian.

if fid == -1
  error(['Could not open file: ',filename]);
end

if nargout<2,
    readScalar=0;
else
    readScalar=1;
end
if nargout<3,
    read3D=0;
else
    read3D=1;
end

if nargin == 1
  only_matrix = 0;   %lots of things as output
 elseif nargin == 2;
   only_matrix = 1; % only matrices as output
 else
   fprintf('Too many input arguments.\n');
   return
end

fseek(fid,0,1);
eof=ftell(fid);
fseek(fid,0,-1); % go to beginning of file.

version = fread(fid, 8, '*char')';
% Since the CMS-View file has not changed in >4 years, all we need here is
% To check it's correct, otherwise return an error
% older versions changed endian based on platform, or lacked important info
version = char(version);
%TODO if version not XXXXX end

plotFileType = fread(fid, 1, 'int' ); %Identify type of File read
%CASMO = 3
%S3K = 4
%S3 = 1
% Other - files not intended for current support.
% comment out the following block to work on CASMO Files
if plotFileType ~= 1 && plotFileType ~= 4
  error(['Unsuported CMS-View File type (CASMO?)',plotFileType,filename]);
end

count_sp = fread(fid,1, 'int');    % Number of statepoints in file
count_pm = fread(fid, 1, 'int');   % Number of parameters
count_in = fread(fid, 1, 'int');
count_dm = fread(fid, 1, 'int');   % Number of Dimension quantities (Map Layouts)
no_sclabels1 = fread(fid,1,'int'); % Number of level one labels (CASMO Depletions, S3 and S3K variables)
no_sclabels2 = fread(fid,1,'int'); % Number of Level 2 Labels (CASMO Branch Calc)
no_sclabels3 = fread(fid,1,'int'); % Number of Level 3 Labels (CASMO Branch Branches)
count_filters = fread(fid,1,'int');% Number Filters used by CMS-View to group Scalar data.
fileMarker = fread(fid,1,'int');   % Unused
fileMask = fread(fid,1,'int');
qa_position = fread(fid,1,'int'); % Location of Fixed header information
position = fread(fid,1,'int');    % Location of begining of first statepoint data.

%% Structs and cell arrays to be filled with data.
stp_labels1 = cell(count_pm,1);
scalar_mask = struct();
core = struct();
variables = struct();
data = NaN(count_pm, count_sp-1);
PosData=NaN(1,count_sp);
%data_names=cell(nn,count_sp-1);
info = cell(1,count_sp);
statepoint = cell(count_sp,1);
DataSize=zeros(count_sp,1);

cur_sp = 1; %the current statepoint to be read
cur_dims=0; % These all start at 0 and are incremented by what's added in a sp
cur_filters=0;  % (All is defaulted by no filter)
cur_labels1=0;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Part 2 Read Header Data, and initial

if qa_position,
  fseek(fid, qa_position, -1);
 HeaderCount = fread(fid, 1, 'int');
end

HeaderLabel = cell(HeaderCount,1);

for index = 1:HeaderCount,
    slength = fread(fid, 1, 'int');
    stot = ceil(slength/4)*4;
%     % TA BORT DETTA !!!!!!!!!!!!!!!!!!!!!!!
%     if stot == 84,
%         stot = 82;
%     end
    fseek(fid,4,0);
    HeaderLabel{index} = fread(fid, slength-1, '*char')';
    fseek(fid,stot-slength+1,0);
end

HeaderValues=fread(fid,HeaderCount,'float'); % (Rated Power, etc.)
% Part 2.5 This is the initial dimension info
core.height = fread(fid,1,'float');  
core.iimin = fread(fid, 1, 'int');
core.iimax = fread(fid, 1, 'int');
core.mminj = fread(fid, (core.iimax - core.iimin + 1), 'int');
core.mmaxj = fread(fid, (core.iimax - core.iimin + 1),'int');
core.kan = sum(core.mmaxj - core.mminj + 1);
core.integers=fread(fid,3,'int');
core.floats = fread(fid, 9, 'float');  %% What is read here?
number = sum(core.iimax - 2*(core.mminj -1));
ident = cell(number,1);

for ii =1:number
  slength = fread(fid, 1, 'int');
  ident{ii} = fread(fid, slength, '*char')';
  stot = ceil(slength/4)*4;
  fseek(fid, stot - slength, 0);
end

core.serial = ident;

varv = 1; % the number of rounds run in the loop. varv = round or lap
          % (swedish). This should be able to be replaced with cur_sp

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Part 3 Read a statepoint

count_new_scalars=0;
data_name={};
while(position),  %start reading data in the statepoints
    
    fseek(fid, position , -1);
    
    new_arrays = fread(fid, 1, 'int');
    na(varv)=new_arrays;
    scalar_count = fread(fid, 1, 'int');
    new_dims = fread(fid, 1, 'int');
    new_scalars = fread(fid, 1, 'int');
    new_labels1 = fread(fid, 1, 'int');
    new_labels2 = fread(fid, 1, 'int');
    new_labels3 = fread(fid, 1, 'int');
    new_filters = fread(fid, 1, 'int');
    
    if (fileMask && new_scalars)
        count_new_scalars=count_new_scalars+1;
        scalar_mask.p1{count_new_scalars} = fread(fid, new_scalars,'int') + 1; %ushort in c
        scalar_mask.p2{count_new_scalars} = fread(fid, new_scalars,'int') + 1; %ushort in c
        scalar_mask.p3{count_new_scalars} = fread(fid, new_scalars,'int') + 1; %ushort in c
        scalar_mask.f{count_new_scalars} = fread(fid, new_scalars,'int') + 1; %ushort in c    
    end
     
    DataSize(cur_sp) = scalar_count;
    
    if (scalar_count),
        PosData(varv)=ftell(fid);
        if readScalar,
            statepoint{cur_sp}.data = fread(fid, scalar_count, 'float'); %% The
            %data for
            %the statepoint
            if (fileMarker)
                statepoint{cur_sp}.i = fread(fid, scalar_count, 'int');
            end
            if (fileMask),
                statepoint{cur_sp}.marker = fread(fid, scalar_count, 'int');
                %short in c -code. ...    Marker  specifies where each unique scalar is stored on file
                %for example, if new variables are added in the simulation, it is not neccesarily in the
                %end of the variable list
            end
        else
            fseek(fid,scalar_count*4*2,0);
        end
    end
    
    cur_sp = cur_sp + 1;
    
    fseek(fid,4,0);
    %pos(varv,1)=fread(fid, 1, 'int'); %address to previous read distribution
    for ii = 1:new_labels1,
        sln = fread(fid,1,'uint32');
        stp_labels1{cur_labels1 + ii} = fread(fid, sln,'*char')';
        stot=ceil((sln)/4)*4;
        fseek(fid,4 + (stot - sln),0);
    end
    cur_labels1 = cur_labels1 + new_labels1;
    if plotFileType == 4
    %%%%%% Only Used in CASMO
      ii=1;
      for ii = 1:new_labels2,
         sln = fread(fid,1,'uint32');
         stp_labels2{cur_labels2 + ii} = fread(fid, sln,'*char')';
         stot=ceil((sln)/4)*4;
         fseek(fid,4 + stot-(sln),0);
      end
    
      cur_labels2 = cur_labels2 + new_labels2;
    
      %%%%% NOT used if s3k file, s3k only uses #1, no branches
      ii=1;
      for ii = 1:new_labels3,
         sln = fread(fid,1,'uint32');
         stp_labels3{cur_labels3 + ii} = fread(fid, sln,'*char')';
         stot=ceil((sln)/4)*4;
         fseek(fid,4 + stot-(sln),0);
      end
    
    cur_labels3 = cur_labels3 + new_labels3;
    end

    for ii = 1:new_filters,
        sln = fread(fid,1,'uint32');
        stp_filters{cur_filters + ii} = fread(fid, sln,'*char')';
        stot=ceil((sln)/4)*4;
        fseek(fid,4 + stot - (sln),0);
    end
    
    
    cur_filters = cur_filters + new_filters;
       
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Part 4
    
    for ii = 1:new_arrays,    
        if varv>1,
            if ii>1,
                pos(ii,varv-1) = fread(fid, 1,'int');  %This is the position of where data that are
                % characterized below is located
            else
                fseek(fid,-4,0);
                pos(1,varv-1)=fread(fid, 1, 'int'); %address to previous read distribution
            end;

        end
        infopos = fread(fid, 1, 'int');
        sln = fread(fid, 1, 'int');
        dataname = fread(fid,sln,'*char')';
        stot = ceil((sln)/4)*4; 
        if varv>1,
            dataname(dataname==0)=[];
            data_name{ii,varv-1}=dataname;
        end
        if readScalar&&nargout>5,
            info{varv}.position(ii)=infopos;
            info{varv}.name=dataname;
            fseek(fid, stot - sln ,0);        
            info{varv}.map_type(ii) = fread(fid, 1, 'int');
            info{varv}.case_number(ii) = fread(fid, 1, 'int');
            info{varv}.dims_number(ii) = fread(fid, 1, 'int');
        else
            fseek(fid,stot-sln+3*4,0);
        end
    end
 
    for ii= 1:new_dims,
        dim{cur_dims + ii}.varv=varv;
        dim{cur_dims + ii}.id = fread(fid, 1, 'int');    %number of rows of nodes in calculated geometry
        dim{cur_dims + ii}.jd = fread(fid, 1, 'int');   %number of columns of nodes in calculated geometr
        dim{cur_dims + ii}.kd = fread(fid, 1, 'int');   %number of axial nodes including reflector
        dim{cur_dims + ii}.idr = fread(fid, 1, 'int');  %rows of assemblies (plus reflector nodes)
        dim{cur_dims + ii}.jdr = fread(fid, 1, 'int');  %columns of assemblies (plus reflector nodes)
        dim{cur_dims + ii}.ida = fread(fid, 1, 'int');  %rows of assemblies in calculated geometry
        dim{cur_dims + ii}.jda = fread(fid, 1, 'int');  %columns of assemblies in calculated geometry
        dim{cur_dims + ii}.kdfuel = fread(fid, 1, 'int'); % number of axial fuel nodes
        dim{cur_dims + ii}.nrefz = fread(fid, 1, 'int');  %number of axial reflector nodes
        dim{cur_dims + ii}.iafull = fread(fid, 1, 'int'); % number of assemblies across full core
        dim{cur_dims + ii}.irmx = fread(fid, 1, 'int');  %dimension of control rod array
        dim{cur_dims + ii}.ilmx = fread(fid, 1, 'int');  %dimension of detector array (BWR only)
        dim{cur_dims + ii}.iofset = fread(fid, 1, 'int');  %offset core flag ( 0 = No; 1 = Yes )
        dim{cur_dims + ii}.ihave = fread(fid, 1, 'int');   %calculation fraction(1 = 1/8; 2 = 1/4; 3 = 1/2; 4 = 1)
        dim{cur_dims + ii}.if2x2 = fread(fid, 1, 'int');  %nodes per Assembly  ( 1 = 1x1; 2 = 2x2 )
        dim{cur_dims + ii}.nref = fread(fid, 1, 'int');   %number of radial reflector nodes
        dim{cur_dims + ii}.isymc = fread(fid, 1, 'int');  % rotational symmetry flag ( 1 = Rotational; 2 = Mirror)
        dim{cur_dims + ii}.pwr = fread(fid, 1, 'int');   %pwr flag ( 0 = bwr; 1 = pwr )
        dim{cur_dims + ii}.npfw = fread(fid, 1, 'int');
        dim{cur_dims + ii}.height = fread(fid, 1, 'float');  % core height in centimeters
        dim{cur_dims + ii}.assembly_row_count = fread(fid, 1, 'int');
        dim{cur_dims + ii}.nodal_row_count = fread(fid, 1, 'int');
        dim{cur_dims + ii}.control_row_count = fread(fid, 1, 'int');
        dim{cur_dims + ii}.serial_row_count= fread(fid, 1, 'int');
        
        
        if (dim{cur_dims + ii}.assembly_row_count > 0),
            dim{cur_dims + ii}.assembly_xlow = fread(fid, dim{cur_dims + ...
                ii}.assembly_row_count, 'int');
            dim{cur_dims + ii}.assembly_xhigh = fread(fid, dim{cur_dims + ...
                ii}.assembly_row_count, 'int');
        end
        
        if (dim{cur_dims + ii}.nodal_row_count > 0),
            dim{cur_dims + ii}.nodal_xlow = fread(fid, dim{cur_dims + ...
                ii}.nodal_row_count, 'int');
            dim{cur_dims + ii}.nodal_xhigh = fread(fid, dim{cur_dims + ...
                ii}.nodal_row_count, 'int');
        end
        
        if (dim{cur_dims + ii}.control_row_count > 0),
            dim{cur_dims + ii}.control_xlow = fread(fid, dim{cur_dims + ...
                ii}.control_row_count, 'int');
            dim{cur_dims + ii}.control_xhigh = fread(fid, dim{cur_dims + ...
                ii}.control_row_count, 'int');
        end
        
        if (dim{cur_dims + ii}.serial_row_count > 0),
            dim{cur_dims + ii}.serial_xlow = fread(fid, dim{cur_dims + ...
                ii}.serial_row_count, 'int');
            dim{cur_dims + ii}.serial_xhigh = fread(fid, dim{cur_dims + ...
                ii}.serial_row_count, 'int');
            
            if (dim{cur_dims + ii}.iofset == 1),
                j = dim{cur_dims + ii}.serial_row_count;
                dim{cur_dims + ii}.serial_xlow = dim{cur_dims + ii}.serial_xlow - 1;
                dim{cur_dims + ii}.serial_high = dim{cur_dims + ii}.serial_high + 1;
            end
            
        end
    end
    cur_dims = cur_dims + new_dims;
    
    pospos(varv)=ftell(fid);
    position = fread(fid, 1, 'int'); % the start position of the next
                                      % statepoint
    PosPos(varv)=position;
    
    
    if position == 0 % reached the end of the file.
        break;
    end
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %Part 5
    if read3D,
        cur_datanum = 1;
        cont = 1;
        
        while cont == 1,
            Pos3Data(cur_datanum,varv)=ftell(fid);
            cor_hght = fread(fid, 1, 'float');
            
            no_nodes = fread(fid, 1, 'int');
            
            no_m= fread(fid, 1, 'int'); %% integer1 = 30
            mminj= fread(fid,no_m,'int');
            mmaxj = fread(fid, no_m,'int');
            
            if varv<3,
                core.Mminj{cur_datanum,varv}=mminj;
                core.Mmaxj{cur_datanum,varv}=mmaxj;
            end
            
            float_flag=fread(fid,1,'int');
            fseek(fid,12,0); %Change  back if integers and float are of interest for something
            %integers(cur_datanum,varv,:) = fread(fid, 2, 'int'); %what is this?
            %float1(cur_datanum,varv)=fread(fid,1,'float');       %what is this?
            float(cur_datanum,varv) = fread(fid, 1, 'float');
            no_pos = sum(mmaxj- mminj+1);
            
            
            xdata=NaN(no_pos,no_nodes);
            num4=NaN(4,no_nodes);
            for ii = 1:no_nodes %Note that data_value contains the "strange" statepoint 1.
                num4(:,ii) = fread(fid, 4, 'int');
                fseek(fid,12,0); % Here just max, min and mean of the following numbers are written on the file
                %scalar{cur_datanum,varv}(ii,:) = fread(fid,3,'float');
                if float_flag,
                    xdata(:,ii) = fread(fid,no_pos,'float');
                else %% The last is control rods, data in 'int' format
                    xdata(:,ii) = fread(fid,no_pos,'int');
                end
            end
            
            %         if cor_hght,
            %             data_fixmap{cur_fixmap,varv}=xdata;
            %             num4_fixmap{cur_fixmap,varv}=num4;
            %             cur_fixmap=cur_fixmap+1;
            %         else
            data_value{cur_datanum,varv}=xdata';
            num4_data{cur_datanum,varv}=num4;
            cur_datanum = cur_datanum + 1;
            %        end
            cont=((ftell(fid)-position)<-10);
        end
    end
    varv = varv +1;
    
end %end of while loop

fclose(fid);  %Close the file

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Part 6
%
%The data reading is done, now on to the data processing


%Fill out a matrix with one statepoint per column so that it matches
%the names matrix's rows (names below). Statepoint 1 is disgarded. One data type per row and
% one statepoint per column. 
%for row = 1:count_pm
if readScalar,
  for col = 2:count_sp
     data(statepoint{col}.marker+1,col-1) = statepoint{col}.data; 
  end
end
%end

%% Make compact forms of the labels, without any "bad" characters

variables.Labels = stp_labels1;  %First add all the real names
cmsinfo.ScalarNames=stp_labels1;
cmsinfo.DistNames=data_name;
cmsinfo.distlist=data_name(:,1);
cmsinfo.distlist(cellfun(@isempty,cmsinfo.distlist))=[];
ia=find(~cellfun(@isempty,strfind(cmsinfo.distlist,'RING - Ring Edit')));
ia=[ia find(~cellfun(@isempty,strfind(cmsinfo.distlist,'BAT  - F')))];
ia=[ia find(~cellfun(@isempty,strfind(cmsinfo.distlist,'NFT  - F')))];
cmsinfo.misclist=cmsinfo.distlist(ia);
cmsinfo.distlist(ia)=[];

if nargout>3,
    variables.Labels_Compact=loose2compact(stp_labels1);
    for ii = 1:count_pm
        variables.(variables.Labels_Compact{ii}) = data(ii,:);
    end
end
% And then the header with constants
[NewLabel,NewValue]=parseheaders(HeaderLabel,HeaderValues);
cmsinfo.constants.Labels = NewLabel;
cmsinfo.constants.Labels_Compact = loose2compact(NewLabel); 
cmsinfo.constants.Values=NewValue;

%% Put together relevant information about the filters
cmsinfo.filters.Labels = stp_filters;
cmsinfo.filters.Labels_Compact = loose2compact(stp_filters);
cmsinfo.filters.Mask = cat(1,scalar_mask.f{1});
for i=2:length(scalar_mask.f),
    cmsinfo.filters.Mask=cat(1,cmsinfo.filters.Mask,scalar_mask.f{i});
end
cmsinfo.serial=ident;
kmaxset=0;
for i=1:length(dim)
    if isfield(dim{1},'kdfuel')
        core.crmminj=dim{i}.control_xlow;
        core.kmax=dim{1}.kdfuel;
        core.irmx=dim{i}.irmx;
        core.if2x2=dim{i}.if2x2;
        kmaxset=1;
        break
    end
end
if ~kmaxset,
    if exist('data_value','var'),
        kmax=0;
        for i=1:size(data_value,1),
            for j=1:size(data_value,2),
                kmax=max(kmax,size(data_value{i,j},1));
            end
        end
    end
    core.kmax=kmax;
end
cmsinfo.core=core;
cmsinfo.core.iafull = dim{1}.iafull;
cmsinfo.core.iwant=dim{1}.ihave;
cmsinfo.core.isymc=dim{1}.isymc;
switch cmsinfo.core.iwant
    case 1
        cmsinfo.core.sym='SSE';
    case 2
        cmsinfo.core.sym='SE';
    case 3
        cmsinfo.core.sym='E';
    case 4
        cmsinfo.core.sym='FULL';
end
[ia,ja]=mminjmmaxj2ij(dim{1}.assembly_xlow,dim{1}.assembly_xhigh,cmsinfo.core.iwant,cmsinfo.core.iafull);
[~,~,knum]=ij2mminj(ia,ja,ones(size(ia)),cmsinfo.core.isymc);
cmsinfo.core.knum=knum;

if dim{1}.pwr,
    cmsinfo.core.lwr='PWR';
else
    cmsinfo.core.lwr='BWR';
end

cmsinfo.file.filename=file('normalize',filename);
cmsinfo.file.fileMarker=fileMarker;
cmsinfo.file.fileMask=fileMask;
cmsinfo.file.DataSize=DataSize;
cmsinfo.file.PosData=PosData;
cmsinfo.file.Pos3Data=pos;
cmsinfo.dim=dim;
cmsinfo.fileinfo.type='cms';
cmsinfo.fileinfo.name=file('tail',filename);
cmsinfo.fileinfo.fullname=file('normalize',filename);

rundatlog = strcmpi('SIMULATE-3 run date',cmsinfo.constants.Labels);
runtimlog = strcmpi('SIMULATE-3 run time',cmsinfo.constants.Labels);
simverlog = strcmpi('SIMULATE-3 version',cmsinfo.constants.Labels);
if sum(rundatlog)==0, 
    rundatlog = strcmpi('SIMULATE-5 run date',cmsinfo.constants.Labels);
    runtimlog = strcmpi('SIMULATE-5 run time',cmsinfo.constants.Labels);
    simverlog = strcmpi('SIMULATE-5 version',cmsinfo.constants.Labels);    
end
if sum(rundatlog)>0,
    cmsinfo.fileinfo.date = cmsinfo.constants.Values{rundatlog};
end
if sum(runtimlog)>0,
    cmsinfo.fileinfo.time = cmsinfo.constants.Values{runtimlog};
end
if sum(simverlog)>0,
    cmsinfo.fileinfo.simver = cmsinfo.constants.Values{simverlog};
end
    %% Get xpo list (can be time)
xpo = read_cms_scalar(cmsinfo,cmsinfo.ScalarNames{1});
cmsinfo.Xpo=xpo;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%% Return the arguments
%%Part7
%
varargout{1} = cmsinfo;
if nargout == 2 
  varargout{2} = data;
elseif nargout == 3
  varargout{2} = data;
  varargout{3} = data_value;
elseif nargout == 4
  varargout{2} = data;
  varargout{3} = data_value;    
  varargout{4} = variables;
elseif nargout == 5
  varargout{2} = data;
  varargout{3} = data_value;    
  varargout{4} = variables;    
  varargout{5} = dim;  
elseif nargout == 6
  varargout{2} = data;
  varargout{3} = data_value;    
  varargout{4} = variables;    
  varargout{5} = dim;  
  varargout{6} = info;
end


 
function StringCompact=loose2compact(StringLoose)

%%
StringLoose=cellstr(StringLoose);
StringCompact=cell(length(StringLoose),1);
for i=1:length(StringLoose),
    loosestr=StringLoose{i};
    blank=0;compstr=[];
    for jj = 1:length(loosestr)
        if loosestr(jj) == 40, %char(40) = '('
            compstr(jj - blank) = 95; % char(95) = '_'
        elseif loosestr(jj) < 48 || loosestr(jj) > 122
            blank = blank + 1;
        elseif loosestr(jj) > 57 && loosestr(jj) < 65
            blank = blank + 1;
        elseif loosestr(jj) < 97 && loosestr(jj) > 90
            blank = blank + 1;
        else
            compstr(jj - blank) = loosestr(jj);
        end
    end
    if abs(compstr(1))>47&&abs(compstr(1))<58, %If first char is a number, move it to 4:pos
        newstart=compstr(2:4);
        compstr(4)=compstr(1);
        compstr(1:3)=newstart;
    end
    StringCompact{i}=char(compstr);
end



function [NewLabel,NewValue]=parseheaders(Header,HValues)
%%
NewLabel=Header;
nH=length(Header);
NewValue=cell(nH,1);
for i=1:nH
    NewValue{i}=HValues(i);
    if HValues(i)==-999,
        colon=strfind(Header{i},':');
        if ~isempty(colon),
            NewLabel{i}=Header{i}(1:(colon(1)-1));
            NewValue{i}=Header{i}(colon(1)+2:end);
        else
            comma=strfind(Header{i},',');
            NewLabel{i}=deblank(Header{i}(1:comma(1)-1));
            n=length(comma);
            NewValue{i}=cell(1,n);
            comma=[comma,length(Header{i})+1];
            for j=1:n,
                NewValue{i}{j}=Header{i}(comma(j)+1:comma(j+1)-1);
            end
        end
    end    
end
