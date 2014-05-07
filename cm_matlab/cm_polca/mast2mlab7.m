%@(#)   mast2mlab7.m 1.1	 03/08/19     08:46:23
%
%function vec=mast2mlab7(f_master,par_no,type);
function vec=mast2mlab7(f_master,par_no,type);

fid=fopen(expand(f_master,'dat'),'r','b');

ind=fread(fid,200,'int32');
if ind(1)~=1
  fclose(fid);
  fid=fopen(expand(f_master,'dat'),'r','l');
  ind=fread(fid,200,'int32');
end

start=ind(par_no)*4-4;
stop=ind(par_no+1)*4-4;
len=(stop-start)/4;

if par_no==48
  len = 400;
end

fseek(fid,start,-1);

if strcmp(type,'F')
  vec=fread(fid,len,'float32');
elseif strcmp(type,'I')
  vec=fread(fid,len,'int32');
elseif strcmp(type,'C1')
  vec=deblank(setstr(fread(fid,len))');
elseif strcmp(type,'C2')
  vec=setstr(fread(fid,4*len))';
  vec=ascch2(vec);
else
  error(['Type ' type ' not supported']);
end
