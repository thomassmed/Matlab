function data = loadfile(file)

[PATHSTR,NAME,EXT] = fileparts(file);

if strcmp(EXT,'.racs')
    type = 'f1f2measmat';
elseif strcmp(EXT,'.mat')
    if ~isempty(whos('-file',file,'signaler'))
        type = 'f1f2measmat';
    elseif ~isempty(whos('-file',file,'mvar'))
        type = 'f3measmat';
    end
elseif strcmp(EXT,'.supe')
    type = 'bisonsupe';
    %%% APROS
elseif strcmp(EXT,'.dat')
    fid=fopen(file);
    fgetl(fid);
    var=cellstr(fgetl(fid));
    if strmatch(cellstr(' SIMULATION TIME'), var)
        type = 'APROS';
    else
        type = 'N_MDATOR';
    end
    %%% End APROS
    %%% COPTA %%%
elseif strcmp(EXT,'.cpt')
    type='COPTA';
    %%% End COPTA
    
    %%% Excel (Standard Plexen addin format)
elseif strcmp(EXT,'.xls')|| strcmp(EXT,'.xlsx')
    type = 'EXCEL';
    answer=inputdlg_mad('Choose Excel sheet');
    answer=char(answer);
    %%% End Excel
end
h=waitbar(0,['Loading file:  ' file]);
set(h,'WindowStyle','modal');
waitbar(0,h);

switch type
    case 'bisonsupe'
        [bisdata namn] = superead(file,'ALL');
        
        % Store filinfo
        data.type = 'bisonsupe';
        data.file = file;
        data.desc = 'Bison supefile';
        data.nvar = size(bisdata,1);
        
        % Store timevector info
        data.t = bisdata(1,:);
        data.nsamples = size(bisdata,2);
        data.fs = 1/(bisdata(1,2) - bisdata(1,1));
        
        % Store signal data
        for i=1:data.nvar
            data.signal(i).data = bisdata(i,:);
            data.signal(i).label = namn(i,:);
            data.signal(i).unit = '';
            data.signal(i).lowlimit = '';
            data.signal(i).highlimit = '';
            data.signal(i).gain = '';
            data.signal(i).desc = '';
        end
        
    case 'f1f2measmat'
        [beskrivning,b,mdata]=ldracs_new(file);
        
        nl = find(b == 10);
        signaler = char(zeros(size(b,2)/100,100));
        signaler(1,:) = b(1:nl(1));
        for i=2:size(nl,2)
            signaler(i,:) = b(nl(i-1):nl(i)-1);
        end
        
        % Store filinfo
        data.type = 'meas';
        data.file = file;
        data.desc = beskrivning;
        data.nvar = size(mdata,2);
        
        % Store timevector info
        data.t = mdata(:,1);
        data.nsamples = size(mdata,1);
        data.fs = 1/(mdata(2,1) - mdata(1,1));
        
        % Store signal data
        for i=1:data.nvar
            data.signal(i).data = mdata(:,i)';
            data.signal(i).label = signaler(i+2,5:21);
            data.signal(i).unit = signaler(i+2,22:28);
            data.signal(i).lowlimit = signaler(i+2,29:41);
            data.signal(i).highlimit = signaler(i+2,42:54);
            data.signal(i).gain = signaler(i+2,55:67);
            data.signal(i).desc = signaler(i+2,68:100);
        end
        
    case 'f3measmat'
        [mdata,mtext,mvar,mvarb,sampl,t]=getf3(file);
        
        % Store filinfo
        data.type = 'meas';
        data.file = file;
        data.desc = mtext;
        data.nvar = size(mdata,2);
        
        % Store timevector info
        data.t = t;
        data.nsamples = size(mdata,1);
        data.fs = sampl(2,1);
        
        % Store signal data
        for i=1:data.nvar
            data.signal(i).data = mdata(:,i)';
            data.signal(i).label = mvar(i,4:20);
            data.signal(i).unit = mvar(i,25:31);
            data.signal(i).lowlimit = mvar(i,39:46);
            data.signal(i).highlimit = mvar(i,47:58);
            data.signal(i).gain = mvar(i,59:64);
            data.signal(i).desc = mvar(i,84:120);
        end
        
    case 'N_MDATOR'
        [c,b,a]=ReadMatdataFil(file);     % Import DAT-file from mätdator
        mdata=c;
        b(:,100)=10;   % lägg in radbrytning
        b=b'; b=b(:)';
        nl = find(b == 10);
        signaler = char(zeros(size(b,2)/100,100));
        signaler(1,:) = b(1:nl(1));
        for i=2:size(nl,2)
            signaler(i,:) = b(nl(i-1):nl(i)-1);
        end
        
        % Store fileinfo
        data.type = 'meas';
        data.file = file;
        data.desc = a;
        data.nvar = size(mdata,2);
        
        % Store time vector info
        data.t = mdata(:,1);
        data.nsamples = size(mdata,1);
        data.fs = 1/(data.t(2) - data.t(1));
        
        % Store signal data
        for i=1:data.nvar
            data.signal(i).data = mdata(:,i)';
            data.signal(i).label = signaler(i+2,5:21);
            data.signal(i).unit = signaler(i+2,22:28);
            data.signal(i).lowlimit = signaler(i+2,29:41);
            data.signal(i).highlimit = signaler(i+2,42:54);
            data.signal(i).gain = signaler(i+2,55:67);
            data.signal(i).desc = signaler(i+2,68:100);
        end
    case 'COPTA'
        
        fid=fopen(file);
        signaler=fgetl(fid);
        fclose(fid);
        signaler=strread(signaler,'%s');
        signaler=char(signaler);
        M=dlmread(file,'',1,1);
        t=M(:,1);
        
        data.type = 'COPTA';
        data.file = file;
        
        beskrivning=cell(7,1);
        beskrivning{1}=['Datum           : '];
        beskrivning{2}=['Etikett         : 1 - '];
        beskrivning{3}= 'Antal mätningar : 1';
        beskrivning{4}=['Antal signaler  : ',sprintf('%i',size(signaler,1))];
        beskrivning{5}=['Antal Sampel    : ',sprintf('%i',size(M,1))];
        beskrivning{6}=['Samplingstid    : ',sprintf('%g',t(2) - t(1))];
        beskrivning{7}=['Fil             : ',char(file)];
        
        data.desc=beskrivning;
        data.nvar = size(signaler,1);
        
        % Store timevector info
        data.t = t;
        data.nsamples = size(M,1);
        data.fs = 1/(t(2) - t(1));
        
        spc=char(32*ones(data.nvar,1));
        spc10=char(32*ones(data.nvar,12));
        nr=char(32*ones(data.nvar,3));
        lolim=cell(data.nvar,1);hilim=lolim;
        for i=1:data.nvar
            nr(i,:)=sprintf('%-3i',i);
            lolim{i}=sprintf('%g',min(M(:,i)));
            hilim{i}=sprintf('%g',max(M(:,i)));
        end
        
        % Store signal data
        for i=1:data.nvar
            data.signal(i).data = M(:,i);
            data.signal(i).label = [' ',signaler(i,:),' '];
            data.signal(i).unit = '';
            data.signal(i).lowlimit = '-';
            data.signal(i).highlimit = '-';
            data.signal(i).gain = '-';
            data.signal(i).desc = '-';
        end
        
    case 'APROS'
        fid=fopen(file);
        num_var=str2num(fgetl(fid));
        signaler='';
        for i=1:num_var
            signaler = strvcat(signaler,fgetl(fid));
        end
        fclose(fid);
        %num_var = textread(file,'%f', 1);
        M = dlmread(file,'%f',num_var+1,0);
        t=M(:,1);
        [m,n]=size(signaler);
        M=M(:,1:m); % Ev. en extra rad läses in som måste tas bort
        
        % Store fileinfo
        data.type = 'APROS';
        data.file = file;
        
        beskrivning=cell(7,1);
        beskrivning{1}=['Datum           : '];
        beskrivning{2}=['Etikett         : 1 - '];
        beskrivning{3}= 'Antal mätningar : 1';
        beskrivning{4}=['Antal signaler  : ',sprintf('%i',size(signaler,1))];
        beskrivning{5}=['Antal Sampel    : ',sprintf('%i',size(M,1))];
        beskrivning{6}=['Samplingstid    : ',sprintf('%g',t(2) - t(1))];
        beskrivning{7}=['Fil             : ',char(file)];
        
        data.desc=beskrivning;
        data.nvar = size(signaler,1);
        
        % Store timevector info
        data.t = t;
        data.nsamples = size(M,1);
        data.fs = 1/(t(2) - t(1));
        
        spc=char(32*ones(data.nvar,1));
        spc10=char(32*ones(data.nvar,12));
        nr=char(32*ones(data.nvar,3));
        lolim=cell(data.nvar,1);hilim=lolim;
        for i=1:data.nvar
            nr(i,:)=sprintf('%-3i',i);
            lolim{i}=sprintf('%g',min(M(:,i)));
            hilim{i}=sprintf('%g',max(M(:,i)));
        end
        
        % Store signal data
        for i=1:data.nvar
            data.signal(i).data = M(:,i);
            data.signal(i).label = [' ',signaler(i,:),' '];
            data.signal(i).unit = '';
            data.signal(i).lowlimit = '-';
            data.signal(i).highlimit = '-';
            data.signal(i).gain = '-';
            data.signal(i).desc = '-';
        end
        
    case 'EXCEL'
        [num,signaler]= xlsread(file,answer);
        
        % Store filinfo
        data.type = 'EXCEL';
        data.file = file;
        data.desc = '';
        data.nvar = size(num,2);
        
        % Store timevector info
        t=num(:,1);
        data.t = t;
        data.nsamples = size(num,1);
        data.fs = 1/(t(2) - t(1));
        
        % Store signal data
        % Blev mycket fixande nedan för att läsa in Plexen-data
        for i=2:data.nvar+1
            data.signal(i).data = num(:,i-1);
            try
                if ~isempty(signaler{2,i})
                    data.signal(i).label = [' ',char(signaler(1,i)),' '];
                    data.signal(i).unit = char(signaler(2,i));
                    t_num=3;
                elseif (isempty(signaler{2,i}) && (~isempty(signaler{1,i})))
                    data.signal(i).label = [' ',char(signaler(1,i)),' '];
                    data.signal(i).unit='';
                    t_num=2;
                end
            catch
                data.signal(i).label = [' ',num2str(i),' '];
                data.signal(i).unit='';
                t_num=1;
            end
            data.signal(i).lowlimit = '';
            data.signal(i).highlimit = '';
            data.signal(i).gain = '';
            data.signal(i).desc = '';
        end
        if isempty(data.signal(1).label)
            chardate=char(signaler(t_num:end,1));
            numdat=datenum(chardate,'yyyy-mm-dd HH:MM:SS');
            %numdat=datenum(chardate,'HH:MM:SS');
            numdat=numdat-numdat(1);
            data.t=numdat.*60*60*24;
            data.fs=1/(numdat(2)-numdat(1));
            
            data.nvar=data.nvar+1;
            data2.signal=data.signal(1);
            data2.signal.label='Tid ';
            data2.signal.unit='[s]';
            data2.signal.data=data.t;
            tmp=data.signal;
            data.signal(1)=data2.signal;
            data.signal(2:data.nvar)=tmp(2:data.nvar);
        end
end

waitbar(100,h);
delete(h);