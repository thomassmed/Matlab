function SavedataGUI(diffdat)
% SavedataGUI is used by cmsplot and a number of cmsplot underfunctions to
% export data to .mat, load in matlab, ascii .txt or excel .xls
% SavedataGUI creates a GUI where the user can choose the specifics.
%
%   SavedataGUI(diffdat)
%
% Input
%   diffdat     - logical, 1 if rawdata is available
% Output
%   file        - output file depending on user input
% 
% See also check_filenames_for_save, exp2asc, exp2xls

% get data from plot
hfig = gcf;
plot_prop = get(hfig, 'userdata');
save_prop = plot_prop.savdat;
save_prop.kmax = plot_prop.coreinfo.core.kmax;
if isfield(save_prop,'plotxvar')
        save_prop.res5 = 1;
        save_prop.xvar = plot_prop.savdat.plotxvar;
else
    save_prop.res5 = 0;
end

if diffdat
    save_prop.rawdata = plot_prop.data;
end
%% TODO: default names
%% TODO: do a check if it is matlab and should take away matlab variables
%% if it will become an application
%% TODO: Maybe change default for geting data into excel
save_prop.filename = 'data';
%% create window
scrsz = get(0,'ScreenSize');
xsid = scrsz(4)/3;
ysid = xsid;
pos = [scrsz(3)/2-xsid/2,scrsz(4)/2-ysid/2];
savegui = figure('MenuBar','none','Name','Export Data','NumberTitle','off','Position',[pos,xsid,ysid]);

%% create uicontrols

% edit textbox
save_prop.handels.text = uicontrol('Style','edit','String','filename (default: data)','BackgroundColor',[1 1 1],'Position',[xsid*0.2,ysid*0.15,xsid*0.6,ysid*0.08],'CallBack',@Edittext);

% frames
uicontrol('Style','frame','BackgroundColor',[0.8 0.8 0.8],'Position',[xsid*0.34,ysid*0.55,xsid*0.32,ysid*0.36]);
uicontrol('Style','frame','BackgroundColor',[0.8 0.8 0.8],'Position',[xsid*0.34,ysid*0.27,xsid*0.32,ysid*0.24]);
uicontrol('Style','text','BackgroundColor',[0.8 0.8 0.8],'String','File type','Position',[xsid*0.35,ysid*0.86,xsid*0.2,ysid*0.07]);
uicontrol('Style','text','BackgroundColor',[0.8 0.8 0.8],'String','Data type','Position',[xsid*0.35,ysid*0.45,xsid*0.2,ysid*0.07]);

% checkboxes
save_prop.handels.matfil = uicontrol('Style','checkbox','BackgroundColor',[0.8 0.8 0.8],'String','Matlab (.mat)','Position',[xsid*0.36,ysid*0.8,xsid*0.27,ysid*0.08]);
save_prop.handels.ascii = uicontrol('Style','checkbox','BackgroundColor',[0.8 0.8 0.8],'String','Ascii (.txt)','Position',[xsid*0.36,ysid*0.72,xsid*0.27,ysid*0.08]);
save_prop.handels.matvar = uicontrol('Style','checkbox','BackgroundColor',[0.8 0.8 0.8],'String','Load in matlab','Position',[xsid*0.36,ysid*0.64,xsid*0.27,ysid*0.08],'Value',1);
save_prop.handels.excel = uicontrol('Style','checkbox','BackgroundColor',[0.8 0.8 0.8],'String','Excel (.xls)','Position',[xsid*0.36,ysid*0.56,xsid*0.27,ysid*0.08]);

save_prop.handels.rawdata = uicontrol('Style','checkbox','BackgroundColor',[0.8 0.8 0.8],'String','Raw data','Position',[xsid*0.36,ysid*0.39,xsid*0.27,ysid*0.08]);
save_prop.handels.plotdata = uicontrol('Style','checkbox','BackgroundColor',[0.8 0.8 0.8],'String','Plotted data','Position',[xsid*0.36,ysid*0.29,xsid*0.27,ysid*0.08],'Value',1);
% set if rawdata should be enabled
if diffdat
    set(save_prop.handels.rawdata,'Enable','on')
else
    set(save_prop.handels.rawdata,'Enable','off')
end

% ok and cancel buttons
save_prop.handels.Ok = uicontrol('Style','PushButton','String','Ok','Position',[xsid*0.1,ysid*0.05,xsid*0.35,ysid*0.08],'CallBack',@Okbutt);
save_prop.handels.Cancel = uicontrol('Style','PushButton','String','Cancel','Position',[xsid*0.55,ysid*0.05,xsid*0.35,ysid*0.08],'CallBack',@Cancelbutt);

% save data to figure.
set(savegui,'userdata',save_prop);

end
%% controls for edittext and buttons

function Edittext(h,~)
% control for the textbar
    hand = get(h);
    save_prop = get(hand.Parent,'userdata');
    savestring = regexprep(file('normalize',hand.String),file('extension',hand.String),'');
    save_prop.filename = savestring;
    set(hand.Parent,'userdata',save_prop);
end

function Cancelbutt(h,~)
% control the cancel button
    hand = get(h);
    delete(hand.Parent);
end

function Okbutt(h,~)
% control the ok button
    hand = get(h);
    save_prop = get(hand.Parent,'userdata');
    
    % check if the file already exist
    save_prop = check_filenames_for_save(save_prop);
        
    % get data from save_prop
    filename = save_prop.filename;
    matfil = get(save_prop.handels.matfil,'value');
    ascii = get(save_prop.handels.ascii,'value');
    matvar = get(save_prop.handels.matvar,'value');
    excel = get(save_prop.handels.excel,'value');
    rawdata = get(save_prop.handels.rawdata,'value');
    plotdata = get(save_prop.handels.plotdata,'value');
    
    delete(hand.Parent);
    if ischar(save_prop) && strcmpi(save_prop,'exit')
        return
    end
    
%% check ReadMe file
if ~exist('Readme_cmsplot_save.txt','file')
    write_cmsplot_readme;
else
    write_cmsplot_readme('ver')
    readmetext = ReadAscii('Readme_cmsplot_save.txt');
    if strcmp(write_cmsplot_readme('ver'),readmetext{1})
        write_cmsplot_readme;
    end
end
    
    
    
%% start writing to files
    if rawdata && ~plotdata
        rawdataraw = save_prop.rawdata;
        if matfil || matvar
            rawdata = convert_data_for_save(rawdataraw,save_prop,'cell');
            save([filename '.mat'],'rawdata');
            if matvar
                evalstr = ['load(''' filename '.mat'')'];
                evalin('base',evalstr);
            end
            if ~matfil
                evalstr = ['!rm ' filename '.mat'];
                eval(evalstr)
            end
        end
            rawdata = convert_data_for_save(rawdataraw,save_prop,'nocell');
        if ascii
            exp2asc(rawdata,save_prop,'raw')
%             save([filename '.txt'],'rawdata','-ascii');
        end
        if excel
            exp2xls(rawdata,save_prop,'raw')
        end
        
    elseif rawdata && plotdata
        rawdataraw = save_prop.rawdata;
        plotdataraw = save_prop.plotdata;
        
        if matfil || matvar
            rawdata = convert_data_for_save(rawdataraw,save_prop,'cell');
            plotdata = convert_data_for_save(plotdataraw,save_prop,'cell');
           
            save([filename '.mat'],'plotdata','rawdata');
            if matvar
                evalstr = ['load(''' filename '.mat'')'];
                evalin('base',evalstr);
            end
            if ~matfil
                evalstr = ['!rm ' filename '.mat'];
                eval(evalstr)
            end
        end
            rawdata = convert_data_for_save(rawdataraw,save_prop,'nocell');
            plotdata = convert_data_for_save(plotdataraw,save_prop,'nocell');

        if ascii
            exp2asc(plotdata,save_prop,'plot',1)
            exp2asc(rawdata,save_prop,'raw',1)
%             save([filename '_raw.txt'],'rawdata','-ascii');
%             save([filename '_plt.txt'],'plotdata','-ascii');
        end
        if excel
            exp2xls(rawdata,save_prop,'raw')
            exp2xls(plotdata,save_prop,'plot')
%             if length(plotdata) > 256, plotdata = plotdata'; end
%             if length(rawdata) > 256, rawdata = rawdata'; end
%             xlswrite([filename '.xls'],plotdata,'plotdata','B2')
%             xlswrite([filename '.xls'],rawdata,'rawdata','A2')
        end
    else
        plotdataraw = save_prop.plotdata;
%         plotdata = convert_data_for_save(save_prop.plotdata,save_prop,'cell');
        if matfil || matvar
            plotdata = convert_data_for_save(plotdataraw,save_prop,'cell');
            save([filename '.mat'],'plotdata');
            if matvar
                evalstr = ['load(''' filename '.mat'')'];
                evalin('base',evalstr);
            end
            if ~matfil
                evalstr = ['!rm ' filename '.mat'];
                eval(evalstr)
            end
        end
        plotdata = convert_data_for_save(plotdataraw,save_prop,'nocell');
        if ascii
            exp2asc(plotdata,save_prop,'plot')
%             save([filename '.txt'],'plotdata','-ascii');
        end
        if excel
            exp2xls(plotdata,save_prop,'plot')
%             if length(plotdata) > 256, plotdata = plotdata'; end
%             xlswrite([filename '.xls'],plotdata)
        end
    end
    
end
