function dists = ReadCore(coreinfo,label,stpt,varargin)
% ReadCore - Reads from different outputfiles, current files, .out, .sum,
% .res , .cms, .pin, .mat (matstab output) 
% 
%   coreinfo = ReadCore(resfile)
%   data = ReadCore(coreinfo,label)
%   data = ReadCore(coreinfo,label,xpo)
%   data = ReadCore(coreinfo,label,xpo,asspos)
%
% Input
%   resfile     - name of res file
%   label       - labels or distributions both found in resinfo (if more
%                 than one it needs to be placed in a cell array)
%   xpo         - exposure point, 10000 or 'first' is first, 20000 or
%                 'last' is last. For all statepoints 'All' and 'ends' will
%                 return the first and last state point,
%                 numbers (1...99) and real exposure points. 
%   asspos      - i and j coordinates for separate assemblies, or channel
%                 numbers (column vector), serial number of assembly (cell
%                 array)
%
% Output
%   resinfo     - for first call a summary of content of the file. 
%   data        - second call: if one dist or label is choosen, resinfo will be a matrix or
%                 cell array containing the data. If more than one dist or
%                 label coreinfo will be a structure .
%   
% Example:
%   coreinfo = ReadCore('sim-tip.sum);
%   flc = ReadCore(coreinfo,'FLC 2D MAP')
%   
%   coreinfo = ReadCore('sim-dep.cms')
%   datastr = ReadCore(cmsinfo,{'SAM TOTAL','3EXP','3RPF'},'all')
%
%   coreinfo = ReadCore('dist-tip.res')
%   datastr = ReadCore(coreinfo,{'XENON','KONROD'},[1 2 3],[150 151 152]')
%
% See also ReadSum, ReadOut, read_cms, ReadRes, ReadPin

% Mikael Andersson 2012-04-20

if nargin>1&&ischar(coreinfo), % To allow for rpf=ReadCore('sim.out','3RPF');
    coreinfo=ReadCore(coreinfo);
end

if nargin==1,
    filename=coreinfo;
    typ=identfile(filename);
    switch typ
        case 'res'
            dists=ReadRes(filename);
        case 'out'
            dists=AnalyzeOut(filename);
        case 'sum'
            dists=AnalyzeSum(filename);
        case 'cms'
            dists=read_cms(filename);
        case 'pin'
            dists=ReadPin(filename);
        case 'mat'
            dists=ReadMatStab(filename);
        case {'p7','p4','pre'}
            dists=ReadPolca(filename);
    end
    dists.fileinfo.type=typ;
    return;
end


%% The second read
% take care of only one statepoint with first read (default setting for
% ReadCore not the same for ReadSum, ReadOut or read_cms_dist)
if nargin <3
%    varargin{1}='all';
    stpt = 'all';
end

stpt=ParseStpt(stpt,coreinfo);
typ=coreinfo.fileinfo.type;
label=cellstr(label);

switch typ
    case 'res'
        dists = ReadRes(coreinfo,label,stpt,varargin{:});
    case 'cms'
        dists=ReadCms(coreinfo,label,stpt,varargin{:});
    case 'out'
        [dists,str] = ReadOut(coreinfo,label,stpt,varargin{:});
        label=str;
     case 'sum'
        dists=ReadSum(coreinfo,label,stpt);
    case 'pin'
        dists = ReadPin(coreinfo,label,stpt,varargin{:});
    case 'mat'    
        dists = ReadMatStab(coreinfo,label);
    case {'p7','p4','pre'}
        dists=ReadPolca(coreinfo,label);
    otherwise
        warning('filetype not found or filetype not supported by ReadCore');
end

%% If more than one distlab (with sum, out, cms) create structure for output
if ~max(strcmpi(typ,{'res','pin','mat'})) && length(label) >1
    ndist = length(label);
    distcell = dists;
    distnames=strrep(label,'{','');
    distnames=strrep(distnames,'}','');
    distnames=strrep(distnames,'-','');
    distnames = genvarname(distnames);
    distnames=strrep(distnames,'0x2E','');
    distnames=lower(distnames);
    for i=1:length(distnames),
        if length(distnames{i})>10, distnames{i}=distnames{i}(1:10);end
    end
    for i=1:ndist
        if max(strcmpi(typ,'cms')) && max(strcmpi(label{i},coreinfo.ScalarNames));
            endstruct.(distnames{i})=distcell{i};
        else
            if isnumeric(distcell{i})
                endstruct.(distnames{i})=cell2mat(distcell(i));
            else
                if iscell(distcell{i})
                    dist = distcell{i};
                else
                    dist = distcell(i);
                end
                endstruct.(distnames{i})=dist;
            end
        end
    end
    endstruct.coreinfo = coreinfo;
    if nargin == 4
        endstruct.knums = knums(:)';
    end
    dists = endstruct;
elseif length(label) == 1 && iscell(dists)
    if length(stpt)==1 && length(dists)==1,
        dists = dists{1};
    end
end


        
