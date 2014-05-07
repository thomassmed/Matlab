function assdat = GetSingleAssembly(data,ser,serials,option)
% GetSingleAssembly - picks one assembly from all statepoints from a cell 
% of many distributions
% 
%  assdat = GetSingleAssembly(data,knum)
%  assdat = GetSingleAssembly(data,ser,serials)
%  assdat = GetSingleAssembly(data,ser,serials,option)
%
% Input
%   data    - cell of data
%   knum    - channel number(s) wanted
%   ser     - the serial(s) wanted
%   serials - referens of all serials in the core (can take one per statepoint/cycle)  
%   option  - form of output (for multiple ser/knum) 'single' for one cell
%             for each assembly and state point, or 'multi' for 1 cell for
%             each state point. Default 'single'
%
% Output
%   assdat  - the data for the wanted asseblies
%   
% Example:
%   cmsinfo = ReadCore('sim-tip.core');
%   dists = ReadCore(cmsinfo,{'3RPF','3EXP'}); 
%   oneass = GetSingleAssembly(dists,'50342',cmsinfo.serial)
%   
% See also ReadCore

if nargin <4
    option = 'single';
end

if ~iscell(data)
    celldat = {data};
else
    celldat = data;
end

if ischar(ser)
    ser = strtrim(ser);
    serwan = {ser};
    knum=0;
elseif iscell(ser)
    serwan = ser;
    knum=0;
    serwan = cellfun(@strtrim,serwan,'uniformoutput',0);
% elseif isnumeric(ser)
%     serwan = cellfun(@strtrim,serials(ser),'uniformoutput',0);
    
else
    serwan = ser;
    knum=1;
end

serials = cellfun(@strtrim,serials,'uniformoutput',0);
if ~knum && length(serials) == length(celldat)
    %TODO: not fixed, for multi
    serref = serials;
    for i = 1:length(serwan)
        
        positions = cellfun(@(x) find(strcmp(serwan{i},x)),serref);  
        if length(unique(positions)) > 1
            for j = 1:length(unique(positions))
                logivec = unique(positions) == serials;
                tempcell = celldat(logivec);
                assdat{i}(:,logivec) = cellfun(@(x) x(:,logivec),tempcell,'uniformoutput',0);
            end
        else
            assdat{i} = cellfun(@(x) x(:,unique(positions)),celldat,'uniformoutput',0);
        end
    end
else
    if strcmp(option,'single')
        for i = 1:length(serwan)   
            if knum
                positions = serwan(i);
            else
                positions = strcmp(serwan{i},serials);
            end
            assdat{i} = cellfun(@(x) x(:,positions),celldat,'uniformoutput',0);
        end
    else
        positions = zeros(1,length(serials));
        if knum
            positions = serwan;
        else
            for i = 1:length(serwan)   
                positions = strcmp(serwan{i},serials)' | positions; 
            end
        end
        if size(celldat{1},1) == 1
            assdat = cellfun(@(x) x(positions),celldat,'uniformoutput',0);
        else
            assdat = cellfun(@(x) x(:,positions),celldat,'uniformoutput',0);
        end
    end
end
if length(serwan) == 1 && length(celldat) == 1
    assdat = assdat{1};
end

