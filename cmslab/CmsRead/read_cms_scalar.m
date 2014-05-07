function [data,Names,index]=read_cms_scalar(cmsinfo,scalars)
% read_cms_scalar - reads specific scalar quntity from cms-file
%
% Input:
%   cmsinfo - info about cmsfile (first output from cms_read)
%   scalars - spec of the scalars that should be read, array or cell array
%
% Output:
%   data - Matrix of data (No of scalars by Number of statepoints)
%   Names - Names on the read quantities
%   index - index of quantity in file
%
% Examples:
%  cmsinfo=read_cms('s3k.cms');
%  data=read_cms_scalar(cmsinfo,[1 2 7 9 10]);
%  [data,Names,index]=read_cms_scalar(cmsinfo,'octant'); % searchpattern
%  If scalars is specified as a cell array, a mix of numerical and strings
%  are allowed
%  scalars{1}=[1 2 3 4];scalars{2}='XEN';scalars{3}='octant';
% [data,Names,index]=read_cms_scalar(cmsinfo,scalars);


%% Input parsing
if ~isstruct(cmsinfo),
    cmsinfo=read_cms(cmsinfo);
end
if ischar(scalars),
    scalars=cellstr(scalars);
end
if iscell(scalars),
    scalcell=scalars;
    scalars=[];
    icount=0;
    for i=1:length(scalcell),
        if isnumeric(scalcell{i}),
            istr=scalcell{i};
        else
            istr=strmatch(scalcell{i},cmsinfo.ScalarNames);
        end
        if ~isempty(istr)
            scalars(icount+1:icount+length(istr))=istr;
            icount=icount+length(istr);
        else
            warning(['Cannot find ',scalcell{i}]);
        end
    end
end
if isempty(scalars),
    data=[];
    Names=[];
    index=[];
    return
end
%% Read from file
fileMarker=cmsinfo.file.fileMarker;
fileMask=cmsinfo.file.fileMask;
PosData=cmsinfo.file.PosData;
DataSize=cmsinfo.file.DataSize;
fid=fopen(cmsinfo.file.filename,'r','ieee-be');
N=length(DataSize)-1;
data=NaN(length(scalars),N);
for i=1:N,
    fseek(fid,PosData(i+1),-1);
    statepointdata = fread(fid, DataSize(i+1), 'float');
    statepointi=fread(fid,DataSize(i+1),'int');
    if (fileMarker)
        data(:,i)=statepointdata(scalars);
    end
    if (fileMask),
        isel=findint(scalars,statepointi+1);
        if all(isel)
            data(:,i)=statepointdata(isel);
        else
            for j=1:length(isel),
                if isel(j)
                    data(j,i)=statepointdata(isel(j));
                end
            end
        end
    end
end
fclose(fid);

index=scalars;
if nargout>1,
    Names=cell(length(index),1);
    for i=1:length(index),
        Names{i}=cmsinfo.ScalarNames{index(i)};
    end
end
    