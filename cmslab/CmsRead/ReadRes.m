function resinfo = ReadRes(resfile,distlab,xpo,asspos)
% ReadRes Read from .res files
%
%   resinfo = ReadRes(resfile)
%   resinfo = ReadRes(resfile,readopt)
%   data = ReadRes(resinfo,label)
%   data = ReadRes(resinfo,label,xpo)
%   data = ReadRes(resinfo,label,xpo,asspos)
%
% Input
%   resfile     - name of res file
%   readopt     - 'nodata' for short version of resinfo (without all adresses to fuel data position
%                 or 'full' for complete resinfo (default 'nodata')
%   label       - labels or distributions both found in resinfo (if more
%                 than one it needs to be placed in a cell array)
%   xpo         - exposure point, 10000 or 'first' is first, 20000 or
%                 'last' is last. For all statepoints 'All', 
%                 numbers (1...99) and real exposure points. 
%   asspos      - i and j coordinates for separate assemblies, or channel
%                 numbers, serial number of assembly
%   
% Output
%   resinfo     - for first call a summary of content of resfile. 
%   data        - second call: if one dist or label is choosen, resinfo will be a matrix or
%                 cell array containing the data. If more than one dist or
%                 label resinfo will be a structure .
%
%   Without input ReadRes will return the distrubution list of avaliable
%   distlists and labels.
% Example:
%
% resinfo = ReadRes('s3.res')
% distrubutions=ReadRes(resinfo,{'XENON', 'SAMARIUM', 'IODINE', 'PROMETHIUM'},[1 2 3]);
% will return a structure with xenon, samarium and iodine distrubutions for
% state points 1,2 and 3.
% 
% See also FindLabels, GetResData, GetResDataS3, GetResDataS5

% Mikael Andersson 2011-10-03

% Programmers note: ReadRes should not need to be changed if other options
% for ReadRes is needed, then GetResDataS3 and GetResDataS5 is the file to be changed.
% If more data is to be added to resinfo, FindLabels is the function that
% needs to be changed.


%% Default values
defaultread = 'FULL';   % default values are 'full' or 'nodata', for function FindLabels
min_size = 1000;        % default for "all state point read" without third input, see line 179
defaultSim = 3;         % which Simulate version is used only used for ReadRes(), see line 52

%% Take care of first read and if input filename is not structure. (not used in ReadCore)
if nargin == 0 
    exceptions = GetResData('exceptions',defaultSim);
    Dists = CaseReader(['GetResdataS' num2str(defaultSim) '.m'],exceptions,0);
    Labels = CaseReader(['GetFormatNrS' num2str(defaultSim) '.m']);
    resinfo = [Dists; Labels];
    return
end

if ~isstruct(resfile)
    if nargin >1 
        if ~iscell(distlab) && max(strcmpi(distlab,{'FULL';'NODATA'})) 
            resinfo = FindLabels(resfile,distlab);
            return;
        else
            warning('For faster read use resinfo = ReadRes(resfile), then use ReadRes with resinfo as input');
            RESINFO = FindLabels(resfile,'FULL');
        end
    else
        resinfo = FindLabels(resfile,defaultread);
        return;
    end
elseif isstruct(resfile)
    RESINFO = resfile;
end
    
%% parsing of distlist and xpo

switch nargin
    case 1
        % give fue_new ish, later work
    case 2
        if iscell(distlab)
            % get structure labels
            ndist = length(distlab);
            distlist = distlab;
            distnames=strrep(distlist,'{','');
            distnames=strrep(distnames,'}','');
            distnames = lower(genvarname(distnames));
            distnames=strrep(distnames,'0x2e','');
        elseif ischar(distlab)
            ndist = 1;
            distlist = {distlab};
        end
        nxp = 1;
        offsetstpt = 1;
    case {3,4}
        if iscell(distlab)
            % get structure labels
            ndist = length(distlab);
            distlist = distlab;
            distnames=strrep(distlist,'{','');
            distnames=strrep(distnames,'}','');
            distnames = lower(genvarname(distnames));
            distnames=strrep(distnames,'0x2e','');
        elseif ischar(distlab)
            ndist = 1;
            distlist = {distlab};
        end
        % setup for xpo pts
        if ischar(xpo)
            
            switch upper(xpo)
                case 'FIRST'
                    offsetstpt = 1;
                    nxp = 1;
                case 'LAST'
                    offsetstpt = RESINFO.data.statepoints;
                    nxp = 1;
                case 'ALL'
                    nxp = RESINFO.data.statepoints;
                    offsetstpt = [1:nxp];
                case 'ENDS'
                    nxp = 2;
                    offsetstpt = [1 length(RESINFO.Xpo)];
                otherwise
                    warning('Allowed strings for exposure are "first", "last" and "all"')
            end
    
        elseif isnumeric(xpo)
            nxp = length(xpo);
            tmpr = 1;
            for i = 1:nxp
                [indic p] = max(abs(RESINFO.Xpo - xpo(i)) < 0.01); 
                if indic == 1
                   offsetstpt(tmpr) = p;
                   tmpr = tmpr + 1;
                end
            end
            if xpo == 10000 
                offsetstpt = 1;
            elseif xpo == 20000
                offsetstpt = RESINFO.data.statepoints;
            elseif 1< floor(xpo)-xpo<99
                offsetstpt = xpo;
            end
        end
end

if nargin < 4
    asspos = 0;
end

%% if first read is nodata, check if all inputs are ok.
if strcmp(RESINFO.data.Fuel_data.readopt,'NODATA')
    k = 1;
    distnotok = cell(1);
    partstr = '';
    for d = 1:ndist
        try
            test = GetResData(RESINFO,distlist{d},1);
        catch err
            if ~isempty(regexp(err.message,'abs_pos', 'once'))
                distnotok{k} = distlist{d};
                partstr = [partstr ' ' upper(distlist{d})];
                k = k+1;
            end
        end
    end
    if k>1
        warning(['The full read of resinfo is needed for input' partstr ' ,for help see "help ReadRes"']);
        resinfo = nan;
        return
    end
end
%% Get data with given options and exposure points
distcell = cell(ndist,nxp);
structm = zeros(ndist,nxp);
for d = 1:ndist
    for x = 1:nxp
        distcell{d,x} = GetResData(RESINFO,distlist{d},offsetstpt(x),asspos);
        structm(d,x) = isstruct(distcell{d,x});
    end
end

%% arrange the data to structures or cells depending on what data is asked for.

if nxp == 1 && ndist ==1
    resinfo = distcell{1};
    if isstruct(resinfo)
        resinfo.resinfo = RESINFO;
    else 
        if iscell(resinfo) && size(resinfo,1) == 1 && size(resinfo,2) == 1 &&  isfloat(resinfo{1})
            resinfo = resinfo{1};
        end
    end
    if nargin == 2 && RESINFO.data.statepoints > 1
        ressize = whos('resinfo');
        if ressize.bytes < min_size
            resinfo = ReadRes(RESINFO,distlab,'all');
        end
    end
    return
end

structvar = logical(structm(:,1));
if max(structvar) == 1
    for i = 1:ndist
        if structvar(i)
            finam = fieldnames(distcell{i,1});
            
            for l = 1:length(finam)
                for k = 1:nxp
                    c = struct2cell(distcell{i,k});
                    if ndist ==1
                        if nxp == 1
                            eval(['resinfo.'  finam{l} '=' 'c{l}' ';']);
                        else
                            eval(['resinfo.'  finam{l} '{k}' '=' 'c{l}' ';']);
                        end
                    else 
                        if nxp == 1
                            eval(['resinfo.' distnames{i} '.' finam{l} '=' 'c{l}' ';']); 
                        else
                            eval(['resinfo.' distnames{i} '.' finam{l} '{k}' '=' 'c{l}' ';']); 
                        end
                    end
                end   
            end
        else
            if isscalar(distcell{i,1})
                eval(['resinfo.' distnames{i} '=' 'cell2mat(distcell(i,:));']);
            else
                if nxp == 1
                    eval(['resinfo.' distnames{i} '=' 'distcell{i,:};']);
                else
                    eval(['resinfo.' distnames{i} '=' 'distcell(i,:);']); 
                end
            end

        end
    end
    resinfo.resinfo = RESINFO;
    return;
    
end

if ndist >1
    for i=1:ndist
        if isscalar(distcell{i,1})
            eval(['resinfo.' distnames{i} '=' 'cell2mat(distcell(i,:));']);
        else
            eval(['resinfo.' distnames{i} '=' 'distcell(i,:);']);
        end
    end
else
    resinfo = distcell;
end

if isstruct(resinfo)
    resinfo.resinfo = RESINFO;
end

if nargin == 2
    ressize = whos('resinfo');
    if ressize.bytes < min_size
        resinfo = ReadRes(RESINFO,distlab,'all');
    end
end

if ndist ==1 && isscalar(resinfo{1})
    if iscell(resinfo{1}) 
        if isscalar(resinfo{1}{1})
            for i = 1:nxp
                resinfon(i) = cell2mat(resinfo{i});
            end
            resinfo = resinfon;
        else
            for i = 1:nxp
                resinfon{i} = cell2mat(resinfo{i});
            end
            resinfo = resinfon;
        end
    else
        resinfo = cell2mat(resinfo);
    end
end


end





