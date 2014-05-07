%@(#)   init_msopt.m 1.7   03/08/13     15:32:09
function msopt=init_msopt(distfile,varargin);
% msopt=init_msopt(distfile,useropt)
% Initialize the msopt structure
% Priority order: 
% Commandline(useropt) -> OptionFile -> CodeDefaults
% Code Defaults: MasterFile from DistFile
%				 SourceFile from DistFile
%                ParaFile from /cm/xx/matstab/input/parameter.inp 
%                MstabFile = DistFile with extension '.mat' in local dir

% Code defaults, Defaults for File* are handled further down
msopt=msoptset; 

% Check if distfile is a distfile or a complementfile:
compflag=0;
if ~isempty(dir(distfile)),
  if strcmp(polca_version(distfile),'UNKNOWN'),
      %distfile is a complementfile!
      compfile=distfile;
      msopt.OptionFile=compfile;
      msopt=comp2useropt(compfile);
      distfile=msopt.DistFile;
      compflag=1;
  end
end


% Read user file (msoptuser.m or commandline option) here
if compflag==0,
  msopttemp=msoptset(varargin{:});
  optionfile=msopttemp.OptionFile;
  if isempty(optionfile)
    optionfile='msuseropt';
  end
 
  if ~isempty(optionfile)
    f=which(optionfile);
    if ~isempty(f)
      eval(optionfile)
      msopt.OptionFile=f; 
      %now we should have the variable useropt defined
      if exist('useropt','var')
        msopt=msoptset(msopt,useropt);
      end
    end
  end

  % Commandline arguments
  if ~isempty(distfile)
    msopt.DistFile=distfile; 
  end
  msopt=msoptset(msopt,varargin{:});
end
% Check the files and use create 'smart' defaults if necessary

%Option File
if compflag==1,
   disp(['User options found in complementfile: ',compfile]);
else
   disp(['User options used in file: ',msopt.OptionFile])
end


% DistFile
distfile=msopt.DistFile;	
distfile=expand(distfile,'dat');	
% look on matlab path as well
f=which(distfile);
if ~isempty(f) 
  % this handeling of f may cause problem if the local dir is not first in matlab path
  distfile=f;
end
distfile=expandpath(distfile);	
checkfile(distfile,'DistFile')
msopt.DistFile=deblank(distfile); % if we get here, distfile is OK

MATLAB_HOME=getenv('MATLAB_HOME'); % I hope this works for PCWIN as well./vdb 02-02-21

[dist,mminj,konrod,bb,hy,mz,ks,buntyp,bunref,...
 distlist,staton,masfil,rubrik,detpos,fu]=readdist(msopt.DistFile);

soufil=get_soufil(msopt.DistFile); 

% check staton
switch lower(staton)
case {'leibstadt','l'}
  staton='l';
case {'forsmark 1','f1'}
  staton='f1';
case {'forsmark 2','f2'}
  staton='f2';
case {'forsmark 3','f3'}
  staton='f3';
case {'ringhals 1','r1'}
  staton='r1';
otherwise
  error(['MATSTAB does''nt support ',staton,' at the moment'])
end


%ParaFile
if isempty(msopt.ParaFile) 
  % no defaults, but we can make a good guess
  msopt.ParaFile=['/cm/',remblank(staton),'/matstab/input/parameter.inp'];
  if isempty(dir(msopt.ParaFile))
    error('parameter.inp must be given');  
  end
end
msopt.ParaFile=expandpath(msopt.ParaFile);
checkfile(msopt.ParaFile,'ParaFile')
% if we get here, ParaFile is OK


% MasterFile
if isempty(msopt.MasterFile) 
  % no defaults, look for MasterFile from DistFile
  if ~isempty(masfil) && ~isempty(dir(masfil))				% lagt till koll av ~isempty(masfil), Emma Lundgren, 051208
    msopt.MasterFile=masfil;
	msopt.MasterFile=expandpath(msopt.MasterFile);
	checkfile(msopt.MasterFile,'MasterFile')
	
	% if we get here MasterFile is OK
	disp(['Master File: ',msopt.MasterFile]);
  else
    msopt.MasterFile=[];
  end
end


% SourceFile
if isempty(msopt.SourceFile) 
  % no defaults, look for SourceFile from DistFile
  if ~isempty(dir(soufil))
    msopt.SourceFile=soufil;
  end
end
msopt.SourceFile=expandpath(msopt.SourceFile);
checkfile(msopt.SourceFile,'SourceFile')

% if we get here SourceFile is OK
disp(['Source File: ',msopt.SourceFile]);


% MstabFile
if isempty(msopt.MstabFile)
  % no defaults, use DistFile with extention '.mat' in local dir
  [path,name,ext]=fileparts(msopt.DistFile);
  msopt.MstabFile=[name, '.mat'];
end
msopt.MstabFile=expand(msopt.MstabFile,'mat');
msopt.MstabFile=expandpath(msopt.MstabFile);
disp(['Results saved on: ',msopt.MstabFile])
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function checkfile(file,filetype)

if isempty(dir(file))
  error(sprintf('Couldn''t find %s:\n %s \n',filetype,file))
end
