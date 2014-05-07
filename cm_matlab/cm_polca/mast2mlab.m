%@(#)   mast2mlab.m 1.1	 03/08/19     08:46:23
%
function vec=mast2mlab(f_master,par_no,type);

%vec=mast2mlab(f_master,par_no,type);

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

fseek(fid,start,-1);


if strcmp(type,'F')
  vec=fread(fid,len,'float32');
  if par_no==81 & vec(14)<0.1   % error in ABB programming, parameter saved as integer instead of float 
    fseek(fid,start,-1);
    vec2=fread(fid,len,'int32');
    vec(14:60:end)=vec2(14:60:end);
  end
elseif strcmp(type,'I')
  vec=fread(fid,len,'int32');
elseif strcmp(type,'C1')
  vec=deblank(setstr(fread(fid,len))');
elseif strcmp(type,'C2')
  vec=setstr(fread(fid,4*len))';
  vec=ascch2(vec);
%  vec=deblank(ascch2(vec));
else
  error(['Type ' type ' not supported']);
end

