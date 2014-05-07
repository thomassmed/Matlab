function run_matstab(file,varargin)
%%
if iscell(file),
    s3kinp=file;
else
    fid=fopen(file,'r');
    temp=textscan(fid,'%s');
    s3kinp=temp{1};
    fclose(fid);
end
%% Run matstab
for i=1:length(s3kinp),
    matstab(s3kinp{i},varargin{:});
end

