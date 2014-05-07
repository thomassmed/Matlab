function [blob, cr, num_cases, iCase, CycExp,konrod] = reads3_file(filename, case_no)
if nargin<2, case_no=[];end

%% Process the file
fid = fopen(filename);  % open file
file = fread(fid)';     % read file
fclose(fid);            % close file
file = char(file);      % convert to ascii equivalents to characters
%% Find Cycle Exposure
if nargout>4,
    icycexp=strfind(file,'Cycle Exp =');
    CycExp=zeros(1,length(icycexp));
    for i=1:length(icycexp),
        CycExp(i)=sscanf(file(icycexp(i)+11:icycexp(i)+21),'%g');
    end
end
%% Find the cases in the file
if isempty(strfind(file(1:200),'s3k.exe')) % If we deal with S3-output, keep only one case
    iCase = strfind(file, ' CASE  ');    % find the case delimiters
    if numel(iCase)==0,
        iCase=strfind(file,[10,'Case ']);
        for i=1:length(iCase),
            inum(i)=sscanf(file(iCase(i)+5:iCase(i)+8),'%i');
        end
        ic_num=unique(inum);
        % Remove first and last non-sense case
        ic_num(ic_num==0)=[];
        ic_num(end)=[];
        for i=1:length(ic_num), iCASE(i)=iCase(find(inum==ic_num(i),1));end
        iCase=iCASE;
    end
        
    % output files have an extra "CASE" card so we don't need to add an additional point for looping
    if (~strcmp(filename(length(filename) - 2 : length(filename)), 'out'))
        iCase = [iCase length(file)];       % add a point to the case vector for ease of looping
    end
    if length(iCase)==1,
        iCase = [iCase length(file)];       % add a point to the case vector for ease of looping
    end    
    num_cases = length(iCase) - 1;  % output the number of cases

    if ~isempty(case_no),
        blob = file(iCase(case_no):  iCase(case_no + 1) - 1);       % read only this case
    else
        blob=file;
    end
else  % if we deal with S3K-output, keep the whole file
    iCase=1;
    num_cases=1;
    blob=file;
end
%% Remove line feeds from the file
lf = blob == 13;  % find line feeds
blob(lf) = [];          % remove line feeds

%% Index the carriage returns in the file
cr = find(blob == 10);  % find carriage returns