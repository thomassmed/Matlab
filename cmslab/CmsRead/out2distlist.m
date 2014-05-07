function distlist=out2distlist(blob)

%% Read file if filename
if length(blob)<100, 
    fid = fopen(blob);      % open file
    blob = fread(fid)';     % read file
    fclose(fid);            % close file
    blob = char(blob);      % convert to ascii equivalents to characters
end 
%% 


iE = strfind(blob, [10,' PRI.STA ']);
distlist={};
icount=0;
if  ~isempty(iE),
    for i=1:length(iE),
        distnam=blob(iE(i)+10:iE(i)+13);
        if isempty(strmatch(distnam,distlist)),
            if ~strcmp(distnam(1),'-'),
                icount=icount+1;
                distlist{icount,1}=distnam;
            end
        end
    end
end


iE=strfind(blob,[10,' A-PRI.STA ']);
if ~isempty(iE),
    icount=1;
    new_distlist{1}=[remblank(blob(iE(2)+12:iE(2)+16)),'-A'];
    for i=3:length(iE),
        distnam=blob(iE(i)+12:iE(i)+15);
        if isempty(strmatch(distnam,new_distlist)),
            icount=icount+1;
            new_distlist{icount,1}=[distnam,'-A'];
        end
    end
    if ~isempty(distlist)
        distlist=[distlist;new_distlist];
    else
        distlist=new_distlist;
    end
end






