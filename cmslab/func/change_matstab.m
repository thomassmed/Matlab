function change_matstab(type,version)
% change_matstab(type,version)
% sets matstab path to type and version
% 
% type is "prod" or "dev"
% 
% see "/cm/tools/matstab/versions.txt" for prod. versionnr.
%
% development versions are found in /public/alster/proj/matlab
% 
% example change_matstab('prod')
%
% change_matstab without input gives default prodution version of matstab

if nargin==0, type='prod'; version='default'; end
if ~isempty(type) & ~strcmp(type,'prod') & ~strcmp(type,'dev')
	disp('Wrong type of version, type must be "prod" or "dev"');
	return
end 

matlab_home='/public/alster/proj/matlab';
matstab_prod='/cm/tools/matstab';

mstabdirs=str2mat('fuel','neu','termo','tools','misc');
mstabdirs2=str2mat('general', 'model','numerics','post','tools');

if strcmp(getenv('CPU'),'LINUX')
	versionfile = '/cm/tools/matstab/versions.txt';
	[ver, date, def]=textread(versionfile,'%s%s%s','commentstyle','matlab');
	n=strmatch('*',def);
	defaultver=ver(n,:);
elseif strcmp(getenv('CPU'),'SUN7')
	disp('Only dev version type can be used on SUN');
	if strcmp(type,'prod')
		return
	end
end

p=path;
matstabpath=which('matstab');
if ~isempty(findstr('general/matstab.m',matstabpath))
	oldver=matstabpath(1:findstr('general/matstab.m',matstabpath)-2);
	dirstyleold=2;
elseif ~isempty(findstr('tools/matstab.m',matstabpath))
	oldver=matstabpath(1:findstr('tools/matstab.m',matstabpath)-2);
	dirstyleold=1;
else
	oldver='unknown';
end


if strcmp(type,'dev')
	if nargin==1, disp('No development version given!'); return; end
	switch lower(version)
	case 'matstab'
  		newver='matstab';
		dirstylenew=1;
	case {'matstab_d', 'd'}
  		newver='matstab_D';
		dirstylenew=1;
	case {'matstab_p4','p4'}
 		newver='matstab_p4';
		dirstylenew=1;
	case {'matstab_p7_2.7.0.1','2.7.0.1'}
 		newver='matstab_p7_2.7.0.1';
		dirstylenew=1;
	case {'matstab_n','n'}
		newver='matstab_N/source';
		dirstylenew=1;
	case {'matstab2','2'}
  		newver='matstab2/source';
		dirstylenew=2;
	otherwise,
  	disp('Unknown version!')
  	return
	end
	newver=[ matlab_home filesep char(newver) ];
elseif strcmp(type,'prod')
	if nargin==1 version='default'; end
	if strcmp(version,'default')
		newver=defaultver;
	elseif ~(strmatch(version,ver) == 0)
		newver=version;
	else
		disp('No such version');
		return
	end
	newver=[ matstab_prod filesep char(newver) ];
	dirstylenew=2;
end



if dirstyleold == 2
  oldpath=strcat(oldver,filesep,mstabdirs2);  
else
  oldpath=strcat(oldver,filesep,mstabdirs);
end
if dirstylenew == 2
  newpath=strcat(newver,filesep,mstabdirs2);
else
  newpath=strcat(newver,filesep,mstabdirs);
end

disp('Old MATSTAB-path:');
disp(oldpath);
disp('New MATSTAB-path:');
disp(newpath);


for i=1:size(oldpath,1)
  p=strrep(p,deblank(oldpath(i,:)),deblank(newpath(i,:)));
end

path(p)
