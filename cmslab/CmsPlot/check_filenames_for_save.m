function outstruct = check_filenames_for_save(instruct)
% check_filenames_for_save is used by SavedataGUI to check if the shoosen
% filename is used and sends a dialog to be able to change it or replace
% it. If the file should be replaced check_filenames_for_save removes them.
%   
% check_filenames_for_save(save_prop)
%
% Input
%   save_prop   - structure with the filename and which kinds of files that
%                 is about to be written
% Output
%   outstruct   - is basically the same struct as the instruct but it can
%                 have a new filename 
% 
% See also SavedataGUI


%% get data from struct
save_prop = instruct;
filename = instruct.filename;
matfil = get(instruct.handels.matfil,'value');
ascii = get(instruct.handels.ascii,'value');
matvar = get(instruct.handels.matvar,'value');
excel = get(instruct.handels.excel,'value');
rawdata = get(instruct.handels.rawdata,'value');
plotdata = get(instruct.handels.plotdata,'value');
outstruct = instruct;
askcont = 1;
%% check files
% check matfiles
if exist([filename '.mat'],'file') == 2
    choice = questdlg(['File ' filename ' already exist'], ...
	'File replacement', ...
	'Replace all','Change filename','Cancel','Replace all');
    switch choice
        case 'Replace all'
            evalstr = ['!rm ' filename '.mat'];
            eval(evalstr)
            askcont = 0;
        case 'Change filename'
            contin = 1;
            while contin >=1
                if exist([filename '_' num2str(contin) '.mat'],'file') == 2
                    contin = contin +1;
                else
                    suggest = [filename '_' num2str(contin)];
                    contin = 0;
                end
            end
            answer = inputdlg('new filename','Select new filename',1,{suggest});
            outstruct.filename = answer{1};
            askcont = 0;
        case 'Cancel'
            askcont = 0;
            outstruct = 'exit';
            return
    end
end
% check txt files
if exist([filename '.txt'],'file') == 2
    if askcont
        choice = questdlg(['File ' filename ' already exist'], ...
        'File replacement', ...
        'Replace all','Change filename','Cancel','Replace all');
    end
    switch choice
        case 'Replace all'
            evalstr = ['!rm ' filename '.txt'];
            eval(evalstr)
            askcont = 0;
        case 'Change filename'
            contin = 1;
            while contin >=1
                if exist([filename '_' num2str(contin) '.mat'],'file') == 2
                    contin = contin +1;
                else
                    suggest = [filename '_' num2str(contin)];
                    contin = 0;
                end
            end
            answer = inputdlg('new filename','Select new filename',1,{suggest});
            outstruct.filename = answer{1};
            askcont = 0;
        case 'Cancel'
            askcont = 0;
            outstruct = 'exit';
            return
    end
end

if exist([filename '_plt.txt'],'file') == 2
    if askcont
        choice = questdlg(['File ' filename ' already exist'], ...
        'File replacement', ...
        'Replace all','Change filename','Cancel','Replace all');
    end
    switch choice
        case 'Replace all'
            evalstr = ['!rm ' filename '_plt.txt'];
            eval(evalstr)
            askcont = 0;
        case 'Change filename'
            contin = 1;
            while contin >=1
                if exist([filename '_' num2str(contin) '.mat'],'file') == 2
                    contin = contin +1;
                else
                    suggest = [filename '_' num2str(contin)];
                    contin = 0;
                end
            end
            answer = inputdlg('new filename','Select new filename',1,{suggest});
            outstruct.filename = answer{1};
            askcont = 0;
        case 'Cancel'
            askcont = 0;
            outstruct = 'exit';
            return
    end
end

if exist([filename '_raw.txt'],'file') == 2 
    if askcont
        choice = questdlg(['File ' filename ' already exist'], ...
        'File replacement', ...
        'Replace all','Change filename','Cancel','Replace all');
    end
    switch choice
        case 'Replace all'
            evalstr = ['!rm ' filename '_raw.txt'];
            eval(evalstr)
            askcont = 0;
        case 'Change filename'
            contin = 1;
            while contin >=1
                if exist([filename '_' num2str(contin) '.mat'],'file') == 2
                    contin = contin +1;
                else
                    suggest = [filename '_' num2str(contin)];
                    contin = 0;
                end
            end
            answer = inputdlg('new filename','Select new filename',1,{suggest});
            outstruct.filename = answer{1};
            askcont = 0;
        case 'Cancel'
            askcont = 0;
            outstruct = 'exit';
            return
    end
end
% check excel files
if exist([filename '.xls'],'file') == 2
    if askcont
        choice = questdlg(['File ' filename ' already exist'], ...
        'File replacement', ...
        'Replace all','Change filename','Cancel','Replace all');
    end
    switch choice
        case 'Replace all'
            evalstr = ['!rm ' filename '.xls'];
            eval(evalstr)
            askcont = 0;
        case 'Change filename'
            contin = 1;
            while contin >=1
                if exist([filename '_' num2str(contin) '.mat'],'file') == 2
                    contin = contin +1;
                else
                    suggest = [filename '_' num2str(contin)];
                    contin = 0;
                end
            end
            answer = inputdlg('new filename','Select new filename',1,{suggest});
            outstruct.filename = answer{1};
            askcont = 0;
        case 'Cancel'
            askcont = 0;
            outstruct = 'exit';
            return
    end
end
end


