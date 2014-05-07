function dists = ReadPin(pininfo,distlab,xpo,asspos)
% ReadPin reads from .pinfile files
%
%   pininfo = ReadPin(pinfile)
%   data = ReadPin(pininfo,distlab)
%   data = ReadPin(pininfo,distlab,xpo)
%   data = ReadPin(pininfo,distlab,xpo,serialnr)
%
% Input
%   resfile     - name of pinfile file
%   label       - distributions wanted (found in pininfo.distlist)
%   xpo         - state point (default first)
%   asspos      - serial number on assembly
%   
% Output
%   resinfo     - for first call a summary of content of resfile. 
%   data        - second call: if one dist or label is choosen, dists will be a matrix or
%                 cell array containing the data. If more than one dist or
%                 label dists will be a structure .
%
% Example:
%
% pininfo = ReadPin('ht1c21_c5s5ws5th.pinfile')
% distrubutions=ReadPin(pininfo,'PINPOW3',1);
% 
% See also read_pinfile, read_pinfile_asyid

% Mikael Andersson 2012-03-07

% TODO: check when/if more than one cycle is on the file..

if nargin >2
    if ischar(xpo) == 1
            
        switch upper(xpo)
            case 'FIRST'
                offsetstpt = 1;
                nxp = 1;
            case 'LAST'
                offsetstpt = length(pininfo.Xpo);
                nxp = 1;
            case 'ALL'
                nxp = length(pininfo.Xpo);
                offsetstpt = 1:nxp;
            case 'ENDS'
                nxp = 2;
                offsetstpt = [1 length(pininfo.Xpo)];

            otherwise
                warning('Allowed strings for exposure are "first", "last" and "all"')
        end

    elseif isnumeric(xpo)
        nxp = length(xpo);
        tmpr = 1;
        for i = 1:nxp
            [indic p] = max(abs(pininfo.Xpo - xpo(i)) < 0.01); 
            if indic == 1
               offsetstpt(tmpr) = p;
               tmpr = tmpr + 1;
            end
        end
        if xpo == 10000 
            offsetstpt = 1;
        elseif xpo == 20000
            offsetstpt = length(pininfo.Xpo);
        elseif 1< floor(xpo)-xpo<99
            offsetstpt = xpo;
        end
    end  
    st_pt = offsetstpt;
end
    



if ischar(pininfo)
%% create pininfo
% fill core
    [~,fuel_data]=read_pinfile(pininfo,1);
    dists.core.mminj = fuel_data.mminj;
    dists.core.kmax = fuel_data.KDFUEL;
    dists.core.kan = fuel_data.MAXASS;
% fill fileinfo
    dists.fileinfo.type = 'pinfile';
    dists.fileinfo.fullname = file('normalize', pininfo);
    dists.fileinfo.name = file('tail', pininfo);
    dists.fileinfo.date = fuel_data.ADATE;
    dists.fileinfo.time = fuel_data.ATIME;
    dists.fileinfo.simver = fuel_data.SIMVER;
    dists.fileinfo.ismatlab = ismatlab;
% fill xpo, serials and distlist
    dists.Xpo = fuel_data.XPO;
    sers = fuel_data.SERIAL';
    dists.serial = cellfun(@strtrim,sers(~cellfun(@isempty,fuel_data.SERIAL)),'uniformoutput',0);
    dists.distlist = {'PINPOW3','fuel_data','PINEXP3','pin_data','PINFLU3','PINPOW2','PINEXP2','PINFLU2'}';    
else
%% Read specific data
    testvec = {'pinpow3','fuel_data','pinexp3','pin_data','pinflu3','pinpow2','pinexp2','pinflu2'};
% check if mutiple outputs are wanted
    if iscell(distlab)
        itlen = length(distlab);
        logivec = cell(1,itlen);
        ordn = zeros(1,itlen);
        for i = 1:itlen
            logivec{i} = strcmpi(testvec,distlab{i});
            ordn(i) = find(logivec{i});
        end
        distlbs = lower(distlab);
        [~,itvec] = sort(ordn,'descend');
    else
        itvec = 1;
        logivec = {strcmpi(testvec,distlab)};
        ordn = find(logivec{1});
        distlbs{1} = lower(distlab);
    end
% create the outvector
    if max(ordn) > 3
        outvec = '[~,~,~,~,~,~,~]';
    else
        outvec = '[~,~,~]';
    end
    for i = itvec
        outvec = [outvec(1:ordn(i)*2-1) distlbs{i} outvec(ordn(i)*2+1:end)];
    end
	
    if nargin == 2
        endstr = ',1);';
        pinver = '';
    elseif nargin == 3
        endstr = ',st_pt);';
        pinver = '';
    else
        endstr = ',asspos,st_pt);';
        pinver = '_asyid';
    end
% read pinfile
	evalstr = [outvec ' = read_pinfile' pinver '(''' pininfo.fileinfo.fullname '''' endstr];
    eval(evalstr)
% create struct if multiple outputs wanted
    if length(itvec) == 1
        eval(['dists = ' lower(distlbs{1}) ';']);
    else
        for i = 1:length(itvec)
            evalstr = ['dists.' distlbs{i} ' = ' distlbs{i} ';'];
            eval(evalstr)
        end
    end
end