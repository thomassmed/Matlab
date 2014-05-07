function resinfo = FindLabels(resfile,opt)
% FindLabels is used by ReadRes and finds all labels and positions for a
% resfile. FindLabels also creates resinfo.
%   
%   resinfo = FindLabels(resfile)
%   resinfo = FindLabels(resfile,opt)
%
% Input
%   resfile     - name of res file
%   opt         - option 'FULL' for complete file map or 'nodata' for file
%                 map except all data positions (default 'nodata')
% Output
%   resinfo     - structure with core, file info data, and distlist
%   
% Example:
%
% resinfo = FindLabels('s3.res')
% distrubutions = FindLabels(resinfo,'FULL');
% 
% See also ReadRes, GetResData

% Mikael Andersson 2011-10-03

% TODO: Fix for additional symetries only works for 'S' and 'SE' at the
% moment

% NOTE: Works for both Simulate 3 and Simulate 5 restart files, that is why
% there is an extra GetFormatNr in FindLabels, if there are differences in
% FORMAT and Nr there will be different for S3 and S5.
% 

if nargin <2
    wantdatapos = 0;
else
    if strcmpi(opt,'FULL')
        wantdatapos = 1;
    elseif strcmpi(opt,'NODATA')
        wantdatapos = 0;
    end
end

% open file
fid=fopen(resfile,'r','ieee-be');
% find max data
fseek(fid,0,1);
neof=ftell(fid);
fseek(fid,0,-1);
lnr = 1;
resinfo.core = struct;
resinfo.fileinfo = struct;
ResStruct.abs_pos=nan(10000,1);
ResStruct.Label{1} = ('');

%% start searching file for labels
while ftell(fid)<neof,
    labpos = ftell(fid);
    numL = fread(fid,1,'int')';
    numW = fread(fid,1,'int')';
    label = fread(fid,numL-4,'*char')';
    [strex firstreppos] = max(strcmp(label,ResStruct.Label));
    if strex == 1
        break;
    end
    ResStruct.Label{lnr,1} = label;
    
    ResStruct.abs_pos(lnr,1) = labpos;
    fseek(fid,4,0);
    for j = 1:numW
        range = fread(fid,1,'int');
        fseek(fid,range+4,0);
    end
lnr = lnr +1;
end

ResStruct.abs_pos(lnr:end)=[];

fseek(fid,-numL-4,0);
size_data_guess =  sum(diff([ResStruct.abs_pos(firstreppos:end); ftell(fid)]));

%% find positions for fuel data 
    datalab = ResStruct.Label(firstreppos:end);
    [datapos numinA] = FindPos(ResStruct,datalab);
    dataposin = datapos(1);
if wantdatapos == 1
    resinfo.data.Fuel_data.readopt = 'FULL';
    fuenr = 0;
%     nr_data_lab = length(numinA);
    fseek(fid,dataposin,-1);
    
    while ftell(fid)<neof,
        labpos = ftell(fid);
        numL = fread(fid,1,'int')';
        numW = fread(fid,1,'int')';
        label = fread(fid,numL-4,'*char')';

        if max(strcmp(label,datalab))== 0
            fseek(fid,-numL-4,0);
            new_label_pos = ftell(fid);
            break;
        end
        if strcmp(label,datalab{1})
            fuenr = fuenr +1;
        end
        fseek(fid,4,0);
        for j = 1:numW
            range = fread(fid,1,'int');
            fseek(fid,range+4,0);
        end
        posvec = strcmp(label,datalab);
        [~, p] = max(posvec);
        fuedatapos(p,fuenr) = labpos;
    end
    for i=1:length(numinA)
        resinfo.data.Fuel_data.abs_pos{i,1} = fuedatapos(i,:);
    end
end

for i=1:length(numinA)
    resinfo.data.Fuel_data.Label{i,1} = datalab{i};
end
%% Parameters
clear FORMAT nr
[FORMAT nr] = GetFormatNrlab('PARAMETERS          ');
[~, nia] = FindPos(ResStruct,'PARAMETERS          ');
next_record = GetNextRecord(fid,ResStruct,nia,FORMAT,nr);
Parameters=next_record.data;

%% Dimensions
clear FORMAT nr
[FORMAT nr] = GetFormatNrlab('DIMENSIONS          ');
[~, nia]= FindPos(ResStruct,'DIMENSIONS          ');
next_record=GetNextRecord(fid,ResStruct,nia,FORMAT,nr);
Dimensions=next_record.data;
lwr=char(Dimensions{1,1});
iafull=double(Dimensions{2,1}(1));
irmx=double(Dimensions{2,1}(2));
ilmx=double(Dimensions{2,1}(3));
iofset=double(Dimensions{2,1}(4));
ihaveu=double(Dimensions{1,2}(1));
if2x2=double(Dimensions{1,2}(3));
isymc=double(Dimensions{1,2}(6));
kmax=double(Dimensions{1,2}(2));
ida=double(Dimensions{1,2}(7));
jda=double(Dimensions{1,2}(8));
id=double(Dimensions{1,2}(9));
jd=double(Dimensions{1,2}(10));
kd=double(Dimensions{1,2}(11));
nrefa=double(Dimensions{1,2}(12));

%% Get maps for mminj and kan
clear FORMAT nr
[Map_pos nia]= FindPos(ResStruct,'LABELS              ');
fseek(fid,Map_pos+32,-1);
[FORMAT nr] = GetFormatNrlab('LABELS              ');
next_record=GetNextRecord(fid,ResStruct,nia,FORMAT,nr);
maparr = next_record.data{2};
cmap = reshape(maparr,length(maparr)/iafull,iafull)';
mminj = zeros(1,iafull);
for i=1:iafull
    [~, b] = min(isspace(cmap(i,:)));
    mminj(i) = floor(b/6) +1;
end
[ia,ja] = mminj2ij(mminj);
kan = length(ia);
% knum = 1:kan;

%% get last labels without data positions
if wantdatapos == 0
    
    est_size_stpt = size_data_guess*kan*if2x2^2*0.9 + ResStruct.abs_pos(end);
    nr_stpt = floor(neof/est_size_stpt);
    if nr_stpt == 0
        nr_stpt = 1;
    end
    size_stpt = neof/nr_stpt;
    % test if it is the correct state point number
    if nr_stpt ~=1
    % If more than one state point
        if (floor(size_stpt) - size_stpt) ~=0
            if nr_stpt >2
                nr_stpt_test = [nr_stpt-2 nr_stpt-1 nr_stpt+1 nr_stpt+2];
            elseif nr_stpt >1
                nr_stpt_test = [nr_stpt-1 nr_stpt+1];
            else
                nr_stpt_test = nr_stpt+1;
            end
                size_stpt_test = neof./nr_stpt_test;
                normch = (floor(size_stpt_test) - size_stpt_test)==0;
            if ~isempty(find(normch, 1))
                nr_stpt_new = nr_stpt_test(normch);
                size_stpt_new = size_stpt_test(normch);
                k = 1;
                for i = 1:length(nr_stpt_new)
                    fseek(fid,size_stpt_new(i),-1);
                    search_str = fread(fid,100,'uint8=>char')';
                    posoffirst = regexp(search_str,ResStruct.Label{1},'start');
                    if ~isempty(posoffirst)
                        size_stpt(k) = size_stpt_new(i);
                        nr_stpt(k) = nr_stpt_new(i);
                        k = k+1;
                    end

                end
            else

                fseek(fid,ResStruct.abs_pos(end),-1);
                search_str = fread(fid,size_stpt,'uint8=>char')';
                posoffirstsearch = regexp(search_str,ResStruct.Label{1},'start');
                if ~isempty(posoffirstsearch)
                    posoffirst = posoffirstsearch(1) + FindPos(ResStruct,ResStruct.Label(end)) - 9;
                    size_stpt = posoffirst;
                    nr_stpt = neof/posoffirst;

                end
            end
        else
            fseek(fid,size_stpt,-1);
            search_str = fread(fid,100,'uint8=>char')';
            paramfind = regexp(search_str,ResStruct.Label{1},'start');
            fseek(fid,ResStruct.abs_pos(end),-1);
            if isempty(paramfind)
                fseek(fid,ResStruct.abs_pos(end),-1);
                search_str = fread(fid,size_stpt,'uint8=>char')';
                posoffirstsearch = regexp(search_str,ResStruct.Label{1},'start');
                if ~isempty(posoffirstsearch)
                    posoffirst = posoffirstsearch(1) + FindPos(ResStruct,ResStruct.Label(end)) - 9;
                    size_stpt = posoffirst;
                    nr_stpt = neof/posoffirst;
                end
            end
        end
    else
    % If there is only one state point and may be two
        nr_stpt_test = 2;
        size_stpt_test = neof./nr_stpt_test;
        fseek(fid,size_stpt_test,-1);
        search_str = fread(fid,100,'uint8=>char')';
        paramfind = regexp(search_str,ResStruct.Label{1},'start');
        if isempty(paramfind)
            nr_stpt = 1;
        else
            nr_stpt = 2;
        end
    size_stpt = neof/nr_stpt;
    end



    stptspos = zeros(1,nr_stpt);
    for i = 1:nr_stpt-1
        stptspos(i+1) = i*size_stpt;
    end

    resinfo.data.Fuel_data.readopt = 'NODATA';
    reg_serach_size = 500000;
    fseek(fid,size_stpt-reg_serach_size,-1);
    search_str = fread(fid,reg_serach_size,'uint8=>char')';
    last_pos = regexp(search_str,ResStruct.Label{end},'start') + size_stpt-reg_serach_size;
    if isempty(last_pos)
        fseek(fid,0,-1);
        search_str = fread(fid,size_stpt,'uint8=>char')';
        last_pos = regexp(search_str,ResStruct.Label{end},'start');
    end
    new_start_pos = last_pos(end)-9;

    fseek(fid,new_start_pos,-1);
    numL = fread(fid,1,'int')';
    numW = fread(fid,1,'int')';
    fseek(fid,24,0);
    for j = 1:numW
        range = fread(fid,1,'int');
        fseek(fid,range+4,0);
    end
else
    fseek(fid,new_label_pos,-1);
end
    
while ftell(fid)<neof,
    labpos = ftell(fid);
    numL = fread(fid,1,'int')';
    numW = fread(fid,1,'int')';
    label = fread(fid,numL-4,'*char')';
    [strex] = max(strcmp(label,ResStruct.Label));
    if strex == 1
        if wantdatapos == 1
            fseek(fid,-(numL+4),0);
            size_stpt = ftell(fid);
            nr_stpt = floor(neof/size_stpt);
            stptspos = zeros(1,nr_stpt);
            for i = 1:nr_stpt-1
                stptspos(i+1) = i*size_stpt;
            end
        end
        break;
    end
    ResStruct.Label{lnr,1} = label;
    ResStruct.abs_pos(lnr,1) = labpos;
    fseek(fid,4,0);
    for j = 1:numW
        range = fread(fid,1,'int');
        fseek(fid,range+4,0);
    end
lnr = lnr +1;
end
% if "full" and one statepoint.
if exist('nr_stpt') ==0;
    nr_stpt = 1;
    stptspos = 0;
end

%% Get Titles and Xpo
clear FORMAT nr

[posTitle,nia] = FindPos(ResStruct,'TITLE               ');
[FORMAT nr] = GetFormatNrlab('TITLE               ');
for i = 1:nr_stpt
    fseek(fid,posTitle + stptspos(i),-1);
    next_record=GetNextRecord(fid,ResStruct,nia,FORMAT,nr,0);                                            
    Title{i}=next_record.data;
    date = Title{i}{2,4};
    time = Title{i}{1,4};
    TIME = [num2str(time(1)) ':' num2str(time(2)) ':' num2str(time(3))];
    Xpo(i) = Title{i}{1,3}(1);
end

%% fill resinfo
resinfo.core.mminj = mminj';
resinfo.core.iafull = iafull;
resinfo.core.kmax = kmax;

resinfo.core.kan = kan;
resinfo.core.symc = isymc;
resinfo.core.irmx = irmx;
resinfo.core.ilmx = ilmx;
resinfo.core.lwr = lwr;
resinfo.core.if2x2 = if2x2;
resinfo.core.iwant=ihaveu;
resinfo.core.ihaveu = ihaveu;
if resinfo.core.if2x2==2,
    resinfo.core.crmminj=resinfo.core.mminj;
else
    resinfo.core.crmminj = mminj2crmminj(resinfo.core.mminj,resinfo.core.irmx);
end

%TODO: check this symmetry
switch ihaveu
    case 4
        sym = 'FULL';
    case 3 
        sym = 'S';
    case 2 
        sym = 'SE';
    case 1
        sym = 'ESE';
end
        
resinfo.core.sym = sym;
knum = sym2knum(mminj,sym);
resinfo.core.knum = knum;

if if2x2 == 2
    mminjh = 2*mminj'-1;
    mminjk = reshape([mminjh mminjh]',2*length(mminjh),1);
    resinfo.core.mminj2x2 = mminjk;
    resinfo.core.knum2x2 = knum2x2knum(knum,mminj',sym,isymc);
end

filtype = file('extension', resfile);
resinfo.fileinfo.type = filtype(2:end);
resinfo.fileinfo.fullname = file('normalize', resfile);
resinfo.fileinfo.name = file('tail', resfile);

resinfo.fileinfo.date = date;
resinfo.fileinfo.time = TIME;
resinfo.fileinfo.simver = strtrim(Title{1}{1});;
resinfo.data.Label = ResStruct.Label;
resinfo.data.abs_pos = ResStruct.abs_pos;
resinfo.data.statepoints = nr_stpt;
resinfo.data.st_pts_pos = stptspos;
resinfo.Xpo = Xpo;
resinfo.data.Parameters = Parameters;
resinfo.data.Dimensions = Dimensions;
resinfo.data.Title = Title{1};


resinfo.fileinfo.ismatlab = ismatlab;

%% detector data
clear FORMAT nr nia
[posTitle,nia] = FindPos(ResStruct,'DETECTOR');
[FORMAT nr] = GetFormatNrlab('DETECTOR');
fseek(fid,posTitle,-1);
det = GetNextRecord(fid,ResStruct,nia,FORMAT,nr,0);    
detl = det.data;
detloc = reshape(detl{1},ilmx,ilmx);
resinfo.core.detloc = detloc;

clear FORMAT nr
[posTitle,nia] = FindPos(ResStruct,'VERSION 2.40');
[FORMAT nr] = GetFormatNrlab('VERSION 2.40',kd);
fseek(fid,posTitle,-1);
ver24 = GetNextRecord(fid,ResStruct,nia,FORMAT,nr,0);  
detlz = ver24.data;
idetz=detlz{1};
ddetz=detlz{2};

resinfo.core.idetz = idetz;
resinfo.core.ddetz = ddetz;
resinfo.core.det_axloc = det_axloc(idetz,ddetz);
fclose(fid);

%% check if it is Simulate 3 or 5
if max(strcmp('S5 PARAMETERS       ' ,resinfo.data.Label)) || max(strcmp('TH-S5-PRO           ' ,resinfo.data.Label)) || max(strcmp('TH-S5-HYD           ' ,resinfo.data.Label))
    resinfo.fileinfo.Sim = 5;
else
    resinfo.fileinfo.Sim = 3;
end
    
%% Find distlist
distexepts = (CaseReader('RelativePosInData.m'));

if resinfo.fileinfo.Sim == 3
    nondist = GetResData('NONDISTS',3,resinfo.core.if2x2);
    if max(strcmpi('PIN EXPOSURES       ',resinfo.data.Label))
        Exeptions = [GetResData(resinfo,'exceptions',resinfo.core.if2x2) distexepts'];
    else
        Exeptions = [GetResData(resinfo,'exceptions',resinfo.core.if2x2) 'PINDATA' 'PINEXP' 'PINPOW' distexepts'];
        nondist(strcmp(nondist,'PINDATA')) = [];
    end
    
else

    for i = 1:length(distexepts)
        subexepts{i} = ['SUB ' distexepts{i}];
    end
    nondist = GetResData('NONDISTS',5,resinfo.core.if2x2);
    
    Exeptions = [GetResData(resinfo,'exceptions',resinfo.core.if2x2) distexepts' subexepts];
end

if resinfo.core.if2x2 == 2
    endstr = '_2x2';
else
    endstr = '_1x1';
end
dist1 = CaseReader(['GetResDataS' num2str(resinfo.fileinfo.Sim) endstr '.m'],Exeptions,0);
j=1;
for i = 1:length(dist1),
    if ~max(strcmpi(dist1{i},nondist)),
        distnostr{j} = dist1{i}; j = j+1; 
    end
end
dimens = GetResData(resinfo,'DIMENSIONS',1,0);
idcons = dimens{1,4}(2:end);
dist2 = RelativePosInData(idcons);
if resinfo.fileinfo.Sim == 5
    for i = 1:length(dist2)
        dist3{i} = ['SUB ' dist2{i}];
    end
    Dists = [distnostr';dist2;dist3'];
else
    Dists = [distnostr';dist2];
end

serials = GetResData(resinfo,'SERIALS',1);
resinfo.serial = serials;

%% final things to core
dims = GetResData(resinfo,'DIMS',1,0);
resinfo.core.hz = dims.hz;
resinfo.core.hx = dims.hx;
resinfo.core.hcore = dims.hcore;

resinfo.distlist = Dists;
resinfo.misclist = nondist;

end

function [FORMAT nr] = GetFormatNrlab(label,kd)
% same as in GetFormatNr but only for FindLabels.
switch upper(strtrim(label))
    case 'PARAMETERS'
        FORMAT=cell(3,4);nr=FORMAT;
        FORMAT{1,1}='int'; nr{1,1}=-1;  FORMAT{1,2}='int';   nr{1,2}=91; FORMAT{1,3}='int'; nr{1,3}=1; FORMAT{1,4}='int'; nr{1,4}=-1;
                                FORMAT{2,2}='float'; nr{2,2}=1;
                                FORMAT{3,2}='int';   nr{3,2}=-1;
                                FORMAT{1,5} = 'int'; nr{1,5} = 1;
    case 'TITLE'
        FORMAT=cell(2,4);nr=FORMAT;
        FORMAT{1,1}='*char';   FORMAT{1,2}='*char';   FORMAT{1,3}='float'; nr{1,3}=3;
                                                    FORMAT{2,3}='int';
        FORMAT{1,4}='int'; nr{1,4} = 3;
        FORMAT{2,4}='*char';
    case 'LABELS'
        FORMAT{1}='*char';FORMAT{1,2}='*char';
        nr{1}=-1;nr{1,2}=-1;
    case 'DIMENSIONS'
        FORMAT=cell(2,4);nr=FORMAT;
        FORMAT{1,1}='*char'; nr{1,1}=3;   FORMAT{1,2}='int'; nr{1,2}=12;   FORMAT{1,3}='*char';     FORMAT{1,4}='int'; nr{1,4}=-1; 
        FORMAT{2,1}='int'; nr{2,1}=4;  
    case 'VERSION 2.40'
        FORMAT=cell(4,1);nr=FORMAT;
        FORMAT{1,1}='int'; nr{1,1}=kd;      
        FORMAT{2,1}='float'; nr{2,1}=kd;    
        FORMAT{3,1}='int'; nr{3,1}=kd;      
        FORMAT{4,1}='float'; nr{4,1}=2;  
    case 'DETECTOR'
        FORMAT=cell(1,1);nr=FORMAT;
        FORMAT{1,1}='int'; nr{1,1}=-1;  
end
end

