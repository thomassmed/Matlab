function f=expandpath(file)
% f=expandpath(file)
% expands the realative path for a file to an absolute path
% ex: ../myfile.txt -> /home/myhome/myfile.txt

if length(file)<2
  f=fullfile(pwd,filesep,file); %really short file name,
else  
  if (file(1:2)=='./')
    % this-dir pointer is removed 
    file=file(3:end);
    f=fullfile(pwd,filesep,file);
    f=delupstr(f);  
  elseif (file(1)~='/' & file(2)~=':')
    f=fullfile(pwd,filesep,file);
    f=delupstr(f);  
  else
    f=file; % already absolute path
  end
end

function s=delupstr(str)
% delete the ../ in str

sep=filesep;
upstr=[sep,'..',sep];
isep=find(str==sep);
iup=min(findstr(str,upstr));

if ~isempty(iup)
  i0=isep(max(find(isep<iup)));
  i1=iup+2;
  str(i0:i1)=[];
  s=delupstr(str);
else
  s=str;
end
