function restart_file=out2restart(blob)

%% Read file if filename
if length(blob)<100, 
    fid = fopen(blob);      % open file
    blob = fread(fid)';     % read file
    fclose(fid);            % close file
    blob = char(blob);      % convert to ascii equivalents to characters
end
%% Find the restart file name
iE=strfind(blob,'Opening restart file:');
if numel(iE)==0,
    iE=strfind(blob,'OPENING RESTART FILE');
end
if numel(iE)==0, restart_file=[];return;end

blob=blob(iE(1)+21:iE(1)+200);
cr=find(blob==10,1);
blob=blob(1:cr-1);
lf=find(blob==13);blob(lf)=[];
restart_file=deblank(char(blob));



