function [answer] = file(cmd, varargin)
% file - Manipulate file names
%
% answer=file(cmd,args)
% 
% Input
%   cmd  - sub-command to execute. See below.
%   args - argument(s) for specified sub-command.
%
% Output
%   answer - Depends on specified sub-command.
%
% Description
%   The file function is the front end for several sub-functions. The first
%   argument to file is the name of the sub-function to invoke. The following
%   sub-functions are available:
%     - dirname    - Returns the directory name of a path.
%     - tail       - Returns the file name of a path.
%     - rootname   - Returns the root name of a path.
%     - extension  - Returns the file extension (including the dot) of a path.
%     - join       - Joins names to create a path.
%     - normalize  - Normalizes a path and returns its full path.
%
%   All sub-functions except 'join' can also be called with a cell array of
%   paths.
%
%   Under Windows both slash (/) and backslash (\) are valid file separators.
%   Returned paths, however, always use backslash as separator.
%
% Examples
%     file('dirname', path) - Returns the directory name of a path
%     ------------------------------------------------------------
%     dirnm = file('dirname', 'c:\a\b\c\file.txt');
%     % dirnm is set to 'c:\a\b\c'
%
%     file('tail', path) - Returns the file name of a path
%     ----------------------------------------------------
%     filenm = file('tail', 'c:\a\b\c\file.txt');
%     % filenm is set to 'file.txt'
%
%     file('rootname', path) - Returns the root name of a path
%     --------------------------------------------------------
%     rootnm = file('rootname', 'c:\a\b\c\file.txt');
%     % rootnm is set to 'c:\a\b\c\file'
%     rootnm = file('rootname', 'file.txt');
%     % rootnm is set to 'file'
%
%     file('extension', path) - Returns the file extension of a path
%     --------------------------------------------------------------
%     ext = file('extension', 'c:\a\b\c\file.txt');
%     % ext is set to '.txt'
%     ext = file('extension', 'file.txt');
%     % rootnm is set to '.txt'
%
%     file('join', parts) - Joins names to create a path
%     --------------------------------------------------
%     % Join contents of cell array
%     path = file('join', {'c:\' 'a' 'b' 'c' 'file.txt'});
%     % path is set to 'c:\a\b\c\file.txt'
%     ext = file('join', {'c:\a\b\c' 'file.txt'});
%     % path is set to 'c:\a\b\c\file.txt'
%
%     % Join multiple arguments
%     path = file('join', 'c:\', 'a', 'b', 'c', 'file.txt');
%     % path is set to 'c:\a\b\c\file.txt'
%     ext = file('join', 'c:\a\b\c', 'file.txt');
%     % path is set to 'c:\a\b\c\file.txt'
%
%     file('normalize', path) - Returns the normalized version of a path
%     ------------------------------------------------------------------
%     Note:
%         The specified path must refer to an existing file or directory.
%
%     npath = file('normalize', '..');
%     % npath is set to the full path to the parent directory, e.g. 'c:\a\b'
%     npath = file('normalize', 'c:\a\b\..\.\b\c\file.txt');
%     % npath is set to 'c:\a\b\c\file.txt'

% Copyright Studsvik Scandpower 2010

%% If input is a string, convert it to a cell array
arg=varargin{1};
was_string=0;
if(~iscell(arg))
    was_string=1;
    arg=cellstr(arg);
end

%% Parse command
switch cmd
    case 'dirname'
	answer = dirname(arg);
    case 'tail'
	answer = tail(arg);
    case 'rootname'
	answer = rootname(arg);
    case 'extension'
	answer = extension(arg);
    case 'join'
	%% If first argument isn't a cell array, use all arguments
	if(was_string)
	    arg = varargin(:);
	end
	answer = join(arg);
    case 'normalize'
	answer = normalize(arg);
    otherwise
	error(['Unknown command ''%s'', must be one of:\n' ...
	    '''dirname'', ''rootname'', ''extension'', ''join'' or ' ...
	    '''normalize'''], ...
	    cmd);
end

%% Convert result to string if the argument was a string
if(was_string && iscell(answer))
    answer=char(answer{1});
end
end

function [rx] = getDriveRegex()
%% Regular expression for windows drive specification
if ispc,
    rx = '^[A-Za-z]:';
else
    rx = '';
end
end

function [rx] = getSeparatorRegex()
%% Under Windows both slash and backslash can be used
if ispc,
    rx = '[/\\]+';
else
    rx = '[/]+';
end
end

function [tp] = trimPath(fpath)
%% Handle drive letters under windows
min_sz = 1;
rx = getDriveRegex();
if(ispc && length(regexp(fpath, rx, 'match', 'once')) == 2)
    min_sz = 3;
end

%% Trim trailing file separator characters
tp = fpath;
rx = getSeparatorRegex();
while(length(tp) > min_sz && ~isempty(regexp(tp(end), rx, 'once')))
    tp(end) = [];
end
end

function [dnames] = dirname(fpaths)
%% Initialize result
dnames=cell(size(fpaths));

%% Regular expression to apply
rx = [getDriveRegex(), '|', getSeparatorRegex()];
if ~ispc&&~ismatlab 
    rx = '/';
end
%% Loop over all paths and get directory name
for i=1:numel(fpaths)
    % Split trimmed file path into parts
    if ismatlab
        [seps parts] = regexp(trimPath(fpaths{i}), rx, 'match', 'split');
    else
         seps  = regexp(trimPath(fpaths{i}), rx, 'match');
         parts = regexpsplit(trimPath(fpaths{i}),seps);
    end
     % If no separators were found, return .
    if(isempty(seps))
	dnames{i} = '.';
	continue;
    end

    % Get rid of the file name
    parts(end) = [];

    % Replace all matching separators with a single separator. Keep drive
    % letter under windows.
    if(ispc && length(seps{1}) > 1 && seps{1}(2) == ':')
	seps(2:end) = {filesep};
    else
	seps(:) = {filesep};
    end

    % Re-assemble the arrays to form the directory name
    d = [parts; seps];

    % Remove trailing path separator (if any)
    dnames{i}=trimPath([d{:}]);
end
end

function [fnames] = tail(fpaths)
%% Initialize result
fnames=cell(size(fpaths));

%% Regular expression to apply
rx = [getDriveRegex(), '|', getSeparatorRegex()];
if ~ispc&&~ismatlab 
    rx = '/';
end

%% Loop over all paths and get file name
for i=1:numel(fpaths)
    % Split trimmed file path into parts
    if ismatlab
        parts = regexp(trimPath(fpaths{i}), rx, 'split');
    else
        seps  = regexp(trimPath(fpaths{i}), rx, 'match');
        parts = regexpsplit(trimPath(fpaths{i}),seps);
    end
    % The last part of the cell array has the file name
    fnames{i} = parts{end};
end
end

function [roots] = rootname(fpaths)
%% Initialize result
roots=cell(size(fpaths));

%% Get extensions of all files in fpath
exts = extension(fpaths);

%% Loop over all paths and get the root name
for i=1:numel(fpaths)
    % Remove extension from the full path
    if(length(exts{i}) < length(fpaths{i}))
	roots{i} = fpaths{i}(1:end-length(exts{i}));
    else
	roots{i} = '';
    end
end
end

function [exts] = extension(fpaths)
%% Initialize result
exts=cell(size(fpaths));

%% Regular expression to apply
if ispc,
    rx = '[.][^./\\]*$';
else
    rx = '[.][^./]*$';
end

%% Get the file names
tails=tail(fpaths);

%% Loop over all file names and get the file extension
for i=1:numel(tails)
    exts(i) = {regexp(tails{i}, rx, 'match', 'once')};
end
end

function [fpath] = join(parts)
%% Compose regular expression
if ispc,
    rx = '^[/\\]';
    seprx = [getDriveRegex(), '[/\\]*$', '|^[/\\]+$'];
else
    rx = '^[/]';
    seprx = '^[/]+$';
end

%% Join all parts
fpath = '';
N = numel(parts);
for i=1:N
    if(isempty(parts{i}))
	continue;
    end
    if(isempty(fpath) || ~isempty(regexp(parts{i}, rx, 'once')))
	fpath = parts{i};
    else
	if(isempty(regexp(fpath, seprx, 'once')))
	    fpath = [fpath, filesep, parts{i}];
	else
	    fpath = [fpath, parts{i}];
	end
    end
end

%% Under Windows, replace all forward slashes with backslashes
if ispc,
    fpath = strrep(fpath, '/', '\');
end
end

function [npaths] = normalize(fpaths)
%% Initialize result
npaths=cell(size(fpaths));

%% Save current directory
wd=pwd();
	  
%% Loop over all paths and get normalized file name
for i=1:numel(fpaths)
    % Go to file's directory and get its path. First, try to cd to the path
    tl = '.';
    try
	cd(fpaths{i});
    catch
	% Try cd to parent directory
	try
	    pdir=dirname(fpaths(i));
	    cd(pdir{1});
	    tl=tail(fpaths(i));
	  
	    tl=tl{1};
	
	catch
	    error('Directory of %s doesn''t exist', fpaths{i});
	    cd(wd);
	    return;
	end
    end
    fdir = pwd();

    % Join the directory name and the file name
    if(tl == '.')
	npaths{i} = fdir;
    else
	fdir = trimPath(fdir);
	npaths{i} = [fdir filesep tl];
    end
end

%% Return to working directory
cd(wd);
end
%% Function equal to regexp with option "split" to work in octave.
function parts = regexpsplit(inpstr,seps)

kit = length(seps);
for i = 1:kit
    sepl(i) = length(seps{i});
end
k=1;
st = 1;
inpnr = size(inpstr,2);
if kit ~= 0 
    while st <= inpnr
        if strncmp(seps{k},inpstr(st:end),sepl(k))
            seppos{k} = st:(st*sepl(k));
            if k== kit   
                break
            else
            k=k+1;
            st = st + sepl(k) - 1;
            end
        else
        end

            st = st+1;
    end
    inpos = 1:inpnr;
    pos = [seppos{:} inpnr(end)+1];
    j=1;
    allparts=cell(length(pos),1);
    sepl = [sepl 1];
    for i=1:inpnr

            if inpos(i) ~= pos(j) 
                allparts{j} = [allparts{j} inpstr(i)];
            else
                j = j+1;
            end
    end

    allparts(cellfun('isempty',allparts)) = {''};

    if sepl(1) == 2
        range = [2:length(allparts)];
    else
        range = [1:length(allparts)];
    end
        psiz = size(allparts(range));
        parts = allparts(range)';
else
    parts = {inpstr};
end
end