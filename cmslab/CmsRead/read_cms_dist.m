function [data_value,data_name,index]=read_cms_dist(cmsinfo,dists,xpo,option)
% read_cms_dist - reads specific distribution from cms-file
%
% [data,Names,index]=read_cms_dist(cmsinfo,dists)
% [data,Names,index]=read_cms_dist(cmsinfo,dists,xpo)
% [data,Names,index]=read_cms_dist(cmsinfo,dists,xpo,'exact')
%
% Input:
%   cmsinfo - info about cmsfile (first output from cms_read)
%   dists   - spec of the dists that should be read, string or cell array
%   xpo     - exposure point, 10000 or 'first' is first, 20000 or
%             'last' is last. For all statepoints 'All', 
%             numbers (1...150) and real exposure points. 
%   option  - if 'exact' is specified, only strings that match exact are used
%
% Output:
%   data - Cell array of data distributions (No of dists by Number of statepoints)
%   Names - Names on the read quantities
%   index - index of quantity in file, cell array of index per state point
%
% Examples:
%  cmsinfo=read_cms('s3k.cms');
%  [data,Names,index]=read_cms_dist(cmsinfo,'Transient'); % searchpattern
%  dists can be specified as a cell array of strings, 
%  dists{1}='T';dists{2}='CRD.POS';
% [data,Names,index]=read_cms_dist(cmsinfo,dists);
% Note that as opposed to read_cms_scalar, integer inputs are not allowed, this is because
% very often, the number of distributions saved can vary between state points.
%
% See also read_cms, read_cms_scalar

if ~isstruct(cmsinfo), % Then assume first argument is a cmsfile
    cmsfile=cmsinfo;
    cmsinfo=read_cms(cmsfile);
end
if nargin<4, option='all';end
if nargin == 3 && ischar(xpo) && strcmpi(xpo,'EXACT'),option = 'exact';end
%% Input parsing
if ischar(dists),
    dists=cellstr(dists);
end
index=cellstrmatch(dists,cmsinfo.DistNames,option);
%% find iteration parameters
if nargin<3
    stptit = 1:length(index);
    nxp = length(index);
else
    if ischar(xpo)
        switch upper(xpo)
            case 'FIRST'
                stptit = 1;
                nxp = 1;
            case 'LAST'
                stptit = length(cmsinfo.Xpo);
                nxp = 1;
            case 'ALL'
                nxp = length(cmsinfo.Xpo);
                stptit = 1:nxp;
            case 'ENDS'
                nxp = 2;
                stptit = [1 length(cmsinfo.Xpo)];
            case 'EXACT'
                stptit = 1:length(index);
                
            otherwise
                warning('Allowed strings for exposure are "first", "last","ends" and "all"')
        end
    elseif isnumeric(xpo)
        if all(xpo==round(xpo))&&~all(cmsinfo.Xpo==round(cmsinfo.Xpo))
            stptit=xpo;
        else
            nxp = length(xpo);
            tmpr = 1;
            for i = 1:nxp
                [indic p] = max(abs(cmsinfo.Xpo - xpo(i)) < 0.005);
                if indic == 1
                    stptit(tmpr) = p;
                    tmpr = tmpr + 1;
                end
            end
            if xpo == 10000
                stptit = 1;
            elseif xpo == 20000
                stptit = length(cmsinfo.Xpo);
            elseif max(floor(xpo)-xpo == 0) && max(xpo)<150 && min(xpo)>0
                stptit = xpo;
            end
        end
    end
    if ~exist('nxp'), nxp = length(stptit);end
end
%% Read from file
fid=fopen(cmsinfo.file.filename,'r','ieee-be');
%% find largest length of index for preallocation
ll=0;
for j=1:nxp,
    ll=max(ll,length(index{j}));
end
data_value=cell(ll,size(stptit,2));
data_name=cell(ll,size(stptit,2));
%% Read from the file
for j=1:nxp
    icount=0;
    for i1=1:length(index{stptit(j)})
        icount=icount+1;
        fseek(fid,cmsinfo.file.Pos3Data(index{stptit(j)}(i1),stptit(j))+4,-1);
        %cor_hght = fread(fid, 1, 'float');
        no_nodes = fread(fid, 1, 'int');
        no_m= fread(fid, 1, 'int');
        mminj= fread(fid,no_m,'int');
        mmaxj = fread(fid, no_m,'int');
        float_flag=fread(fid,1,'int');
        fseek(fid,16,0); %Change  back if integers and float are of interest for something
        %integers(cur_datanum,varv,:) = fread(fid, 3, 'int');  %integers(1) = 0 if last data??
        %float(cur_datanum,varv,:) = fread(fid, 2, 'float');
        no_pos = sum(mmaxj- mminj+1);
        xdata=NaN(no_pos,no_nodes);
        for ii = 1:no_nodes %Note that data_value contains the "strange" statepoint 1.
            fseek(fid,28,0); 
            if float_flag,
                xdata(:,ii) = fread(fid,no_pos,'float');
            else %% The last is control rods, data in 'int' format
                xdata(:,ii) = fread(fid,no_pos,'int');
            end
        end
        data_value{i1,j}=xdata';
        data_name{i1,j}=cmsinfo.DistNames{index{stptit(j)}(i1),stptit(j)};
    end
end
if ~isempty(data_value) && max(size(data_value))==1, data_value=data_value{1};end
fclose(fid);
