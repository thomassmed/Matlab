function cases = CaseReader(mfile,exceptions,double)
% CaseReader gets all cases from a m-file containing a switch case.
%
%   cases = CaseReader(mfile)
%
% Input
%   mfile       - an m-file containing a switch 
%   exeptions   - if there are know cases that not are wanted.
%   double      - 0 if no doubles should be presented and 1 if all doubles
%                 should be shown.
%
% Output
%   dists       - cell array of all cases
%
% Example:
%
% cases = CaseReader('GetResData.m')

%TODO: Can not handle numbers...

fid = fopen(mfile,'r');
TEX = textscan(fid,'%s','delimiter','\n');
TEXT = TEX{1};
TF = strncmp('case',TEXT,4);
if max(TF) == 0
    warning('No cases found in file')
    return;
end
casline = TEXT(TF);
k = 1;
if ismatlab
    for i = 1:length(casline)
        if length(regexp(casline{i},'[{}]')) == 2
            str = strtrim(regexprep(casline{i},'[{}]',''));
            str1 = strtrim(str(5:end));
        elseif length(regexp(casline{i},'[{}]')) > 2
            str = strtrim(casline{i}(5:end));
            str1 = strtrim(str(2:end-1));
        else
            str1 = strtrim(casline{i}(5:end));
        end
        if isempty(regexp(str1(5:end),',','start'))
            casesall{k,:} = strtrim(str1(2:end-1));
            k = k+1;
        else 
            cass = strtrim(regexp(str1(1:end),',','split'));
            for j = 1:length(cass)
                casesall{k,:} = cass{j}(2:end-1);
                k=k+1;
            end
        end
    end
else
    casesall = cell(1);
    for i = 1:length(casline)
        str = strtrim(regexprep(casline{i},'[{}]',''));
        str1 = strtrim(str(5:end));

        if isempty(regexp(str(5:end),',','start'))
            casesall{k,:} = strtrim(str1(2:end-1));
            k = k+1;
        else 
            seps = regexp(str(5:end),',','match');
            cass = strtrim(regexpsplit(str1(1:end),seps));
            for j = 1:length(cass)
                casesall{k,:} = cass{j}(2:end-1);
                k=k+1;
            end
        end
    end  
end
    
fclose(fid);
k = 1;
if nargin >=2 && ~isempty(exceptions)
	casesmine = cell(1);
    for i = 1:length(casesall)
        if ~max(strcmp(casesall{i},exceptions))
            casesmine{k,:} = casesall{i};
            k = k+1;
        end
    end
else
    casesmine = casesall;
end

if nargin == 3 && double == 0
    k = 1;
    cases = {''};
    for i = 1:length(casesmine)
        if ~strcmp(casesmine{i},cases)
            cases{k,:} = casesmine{i};
            k = k+1;
        end
    end
    
else
    cases = casesmine;
end
    
cases = cases(~strcmp(cases,''));
end



%% regexpslpit (for octave)
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