function msopt=init_msopt(compfile,varargin)
% Initialize msopt
%
% msopt=init_msopt(compfile,useropt)
% 
% Initialize the msopt structure
% Priority order: 
% 1. Commandline in call to matstab
% 2. s3k input file (.inp) or matstab input file (.txt) 
% 3. Defaults
% Code Defaults: RestartFile from s3k input file
%                LibFile from RestartFile
%                
%
% Example:
%  matstab s3k-1.inp restartfile s3-10.res
%    will use s3-10.res as restart file,  and NOT the restartfile that is specified on s3k-1.inp
%  matstab s3k-1.inp harmonics 2
%    will calculate two harmonic modes in addition to the global mode

%%
msopt=set_msopt;  % First msopt is set to defaults
absolute_addr=is_absolute(compfile);
if ~absolute_addr,
   compfile=expandpath(compfile);
end
[direc,fname,ext]=fileparts(compfile);
msopt.MstabFile=[direc,filesep,fname,'.mat'];

switch ext
    case '.inp'  %s3k-input file
        msopt.input='s3kfile';
        blob=read_simfile(compfile);
        rest=get_card(blob,'RES');
        if length(rest) ~= 1
            msopt.xpo = rest{2};
        end
        dimcal=get_num_card(blob,'DIM.CAL');
        vec=[4 3 2 1];
        if ~isempty(dimcal)
            msopt.CoreSym=vec(dimcal(2));
        end
        msopt.s3kfile=compfile;
        restart_file=rest{1};
        msopt.xpo=rest{2};
        if ~is_absolute(restart_file),
            restart_file=[direc,filesep,restart_file];
        end
        msopt.RestartFile=restart_file;
        libf=char(get_card(blob,'LIB'));
        if ~isempty(libf),
            if ~is_absolute(libf),
                [PATH,NAME]=fileparts(compfile);
                libf=[PATH,filesep,libf];
            end
            if ~isempty(dir(libf));
                msopt.LibFile=libf;
            end
        end
    case '.res' %RestartFile
        msopt.input='RestartFile';
        msopt.RestartFile=compfile;
        msopt.CoreOnly='on';
    case '.txt' %Complement file
        msopt.input='OptionsFile';
        msopt1=comp2useropt(compfile);
        msopt.OptionFile=compfile;
        msopt=set_msopt(msopt,msopt1);
    case '.dat'
        msopt.input='DistFile';
        msopt.DistFile=compfile;
end
%% Check if complement file is used in combination with s3k-input file
if strncmp(msopt.input,'OptionsFile',11)
    if ~isempty(msopt.s3kfile)
        msopt.NodalCode='SIM3'; %TODO: check if SIM5 is used
        blob=read_simfile(msopt.s3kfile);
        rest=get_card(blob,'RES');
        if length(rest) ~= 1
            msopt.xpo = rest{2};
        end
        dimcal=get_num_card(blob,'DIM.CAL');
        vec=[4 3 2 1];
        if ~isempty(dimcal)
            msopt.CoreSym=vec(dimcal(2));
        end
        restart_file=rest{1};
        msopt.xpo=rest{2};
        direc1=fileparts(msopt.s3kfile);
        if ~is_absolute(restart_file),
            restart_file=[direc1,filesep,restart_file];
            restart_file=file('normalize',restart_file);
        end
        msopt.RestartFile=restart_file;
        libf=char(get_card(blob,'LIB'));
        if ~isempty(libf),
            if ~is_absolute(libf),
                libf=[direc1,filesep,libf];
                libf=file('normalize',libf);
            end
            if ~isempty(dir(libf));
                msopt.LibFile=libf;
            end
        end
    elseif ~isempty(msopt.RestartFile),
        msopt.NodalCode='SIM3';
    elseif ~isempty(msopt.DistFile),
        msopt.NodalCode='POLCA7';
    end 
end
    

if nargin>1,
    msopt=set_msopt(msopt,varargin{:});
end
if ~isnan(msopt.Freq)
    msopt.Global='off';
    msopt.Lam=2j*pi*msopt.Freq;
end


