function Compare2GUI
%% get data from cmsplot
hfig = gcf;
cmsplot_prop = get(hfig, 'userdata');
resinfo = cmsplot_prop.coreinfo;
st_pt = cmsplot_prop.state_point;
%% set some default values
presfile = resinfo.fileinfo.fullname;
distlist = resinfo.distlist;
comp_prop.file1 = resinfo;
comp_prop.file2 = resinfo;
comp_prop.dist1 = distlist{1};
comp_prop.dist2 = distlist{1};
comp_prop.numdist = 2;
comp_prop.st_pt = st_pt;

%% create window
scrsz = get(0,'ScreenSize');
xsid = scrsz(4)/3;
ysid = xsid;
pos = [scrsz(3)/2-xsid/2,scrsz(4)/2-ysid/2];

comparefig = figure('MenuBar','none','Name','Compare2','NumberTitle','off','Position',[pos,xsid,ysid]);

% static textboxes
comp_prop.handels.disttext(1) = annotation('textbox',[0.06 0.85 0.8 0.1],'EdgeColor','none');
comp_prop.handels.disttext(2) = annotation('textbox',[0.06 0.55 0.8 0.1],'EdgeColor','none');
set(comp_prop.handels.disttext(1),'String','Distribution 1');
set(comp_prop.handels.disttext(2),'String','Distribution 2');

% edit boxes
comp_prop.handels.Edit(1) = uicontrol('Style','edit','String',presfile,'Position',[xsid*0.06,ysid*0.8,xsid*0.6,ysid*0.08],'CallBack',@Edittext1);
comp_prop.handels.Edit(2) = uicontrol('Style','edit','String',presfile,'Position',[xsid*0.06,ysid*0.5,xsid*0.6,ysid*0.08],'CallBack',@Edittext2);

% the choose buttons
comp_prop.handels.Choose(1) = uicontrol('Style','PushButton','String','Browse','Position',[xsid*0.7,ysid*0.8,xsid*0.2,ysid*0.08],'CallBack',@PushButtonPressed1);
comp_prop.handels.Choose(2) = uicontrol('Style','PushButton','String','Browse','Position',[xsid*0.7,ysid*0.5,xsid*0.2,ysid*0.08],'CallBack',@PushButtonPressed2);

% pupup menues
comp_prop.handels.Popup(1) = uicontrol('Style','PopupMenu','String',distlist,'Position',[xsid*0.06,ysid*0.70,xsid*0.6,ysid*0.08],'CallBack', @PopupMenuCallBack1);
comp_prop.handels.Popup(2) = uicontrol('Style','PopupMenu','String',distlist,'Position',[xsid*0.06,ysid*0.4,xsid*0.6,ysid*0.08],'CallBack', @PopupMenuCallBack2);

% ok and cancel buttons

comp_prop.handels.Ok = uicontrol('Style','PushButton','String','Ok','Position',[xsid*0.1,ysid*0.1,xsid*0.35,ysid*0.08],'CallBack',@Okbutt);
comp_prop.handels.Cancel = uicontrol('Style','PushButton','String','Cancel','Position',[xsid*0.55,ysid*0.1,xsid*0.35,ysid*0.08],'CallBack',@Cancelbutt);


% extra dist button

comp_prop.handels.Extradist = uicontrol('Style','PushButton','String','Add Distribution','Position',[xsid*0.25,ysid*0.25,xsid*0.5,ysid*0.08],'CallBack',@Extradist);





set(comparefig,'userdata',comp_prop);
end

function Edittext1(h,~)
    hand = get(h);
    comp_prop = get(hand.Parent,'userdata');
    if strcmp(comp_prop.file2.fileinfo.fullname,file('normalize',hand.String))
        comp_prop.file1 = comp_prop.file2;
    else
        temph = waitbar(0.5,'Updating distlist, Please wait...');
        comp_prop.file1 = ReadCore(hand.String);
        delete(temph);
    end
    set(comp_prop.handels.Popup(1),'String',comp_prop.file1.distlist);
    set(hand.Parent,'userdata',comp_prop);    
end

function Edittext2(h,~)
    hand = get(h);
    comp_prop = get(hand.Parent,'userdata');
    if strcmp(comp_prop.file1.fileinfo.fullname,file('normalize',hand.String))
        comp_prop.file2 = comp_prop.file1;
    else
        temph = waitbar(0.5,'Updating distlist, Please wait...');
        comp_prop.file2 = ReadCore(hand.String);
        delete(temph);
    end
    set(comp_prop.handels.Popup(2),'String',comp_prop.file2.distlist);
    set(hand.Parent,'userdata',comp_prop);    
end

function Edittextex(h,~)
    hand = get(h);
    extr_prop = get(hand.Parent,'userdata');
    comp_prop = get(extr_prop.parhand,'userdata');
    if strcmp(comp_prop.file1.fileinfo.fullname,fullname)
        newinfo = comp_prop.file1;
        eval([extr_prop.filestr '= newinfo']);
    elseif strcmp(comp_prop.file2.fileinfo.fullname,fullname)
        newinfo = comp_prop.file2;
        eval([extr_prop.filestr '= newinfo']);
    else
        temph = waitbar(0.5,'Updating distlist, Please wait...');
        newinfo = ReadCore(fullname);
        eval([extr_prop.filestr '= newinfo;']);
        delete(temph);
    end
    set(comp_prop.handels.Popup(comp_prop.numdist),'String',newinfo.distlist);
    set(extr_prop.parhand,'userdata',comp_prop);  
end

function PopupMenuCallBack1(h,~)
    hand = get(h);
    comp_prop = get(hand.Parent,'userdata');
    comp_prop.dist1 = hand.String{hand.Value};
    set(hand.Parent,'userdata',comp_prop);
end

function PopupMenuCallBack2(h,~)
    hand = get(h);
    comp_prop = get(hand.Parent,'userdata');
    comp_prop.dist2 = hand.String{hand.Value};
    set(hand.Parent,'userdata',comp_prop);
end

function PopupMenuCallBackex(h,~)
    hand = get(h);
    extr_prop = get(hand.Parent,'userdata');
    comp_prop = get(extr_prop.parhand,'userdata');
    eval([extr_prop.diststr '= hand.String{hand.Value};']);
    set(extr_prop.parhand,'userdata',comp_prop);
end

function PushButtonPressed1(h,~)
        hand = get(h);
        comp_prop = get(hand.Parent,'userdata');
        [filename,pathname]=uigetfile({'*.res;*.mat;*.hms;*.h5;*.hdf5;*.out;*.sum;*.dat;*.cms','CMS-files (*.cms,*.res,*.mat,*.hms,*.h5,*hdf5,*.out,*.sum,*.dat)';...
        '*.cms','cms-files (*.cms)';...
        '*.res','Restart-files (*.res)';...
        '*.out','Output-files (*.out)';...
        '*.sum','Output-files (*.sum)';...
        '*.mat','Files saved by Matstab (*.mat)';...
        '*.hms','Hermes-files (*.hms)';...
        '*.h5;*.hdf5','Database Files (*.h5, *.hdf5)';...
        '*.dat','Polca Distribution files (*.dat)';...
        '*.*', 'All files (*.*)'},...
        'Pick a file',comp_prop.file1.fileinfo.fullname);
    if ischar(pathname)
        fullname = [pathname filename];
        if strcmp(comp_prop.file2.fileinfo.fullname,fullname)
            comp_prop.file1 = comp_prop.file2;
        else
            temph = waitbar(0.5,'Updating distlist, Please wait...');
            comp_prop.file1 = ReadCore(fullname);
            delete(temph);
        end
        set(comp_prop.handels.Popup1,'String',comp_prop.file1.distlist);
        set(comp_prop.handels.Edit(1),'String',fullname);
        set(hand.Parent,'userdata',comp_prop);  
    end
end

function PushButtonPressed2(h,~)
        hand = get(h);
        comp_prop = get(hand.Parent,'userdata');
        [filename,pathname]=uigetfile({'*.res;*.mat;*.hms;*.h5;*.hdf5;*.out;*.sum;*.dat;*.cms','CMS-files (*.cms,*.res,*.mat,*.hms,*.h5,*hdf5,*.out,*.sum,*.dat)';...
        '*.cms','cms-files (*.cms)';...
        '*.res','Restart-files (*.res)';...
        '*.out','Output-files (*.out)';...
        '*.sum','Output-files (*.sum)';...
        '*.mat','Files saved by Matstab (*.mat)';...
        '*.hms','Hermes-files (*.hms)';...
        '*.h5;*.hdf5','Database Files (*.h5, *.hdf5)';...
        '*.dat','Polca Distribution files (*.dat)';...
        '*.*', 'All files (*.*)'},...
        'Pick a file',comp_prop.file1.fileinfo.fullname);
    fullname = [pathname filename];
    if ischar(pathname)
        if strcmp(comp_prop.file1.fileinfo.fullname,fullname)
            comp_prop.file2 = comp_prop.file1;
        else
            temph = waitbar(0.5,'Updating distlist, Please wait...');
            comp_prop.file2 = ReadCore(fullname);
            delete(temph);
        end
        set(comp_prop.handels.Popup(2),'String',comp_prop.file2.distlist);
        set(comp_prop.handels.Edit(2),'String',fullname);
        set(hand.Parent,'userdata',comp_prop);  
    end
end

function PushButtonPressedex(h,~)
        hand = get(h);
        extr_prop = get(hand.Parent,'userdata');
        comp_prop = get(extr_prop.parhand,'userdata');
        [filename,pathname]=uigetfile({'*.res;*.mat;*.hms;*.h5;*.hdf5;*.out;*.sum;*.dat;*.cms','CMS-files (*.cms,*.res,*.mat,*.hms,*.h5,*hdf5,*.out,*.sum,*.dat)';...
        '*.cms','cms-files (*.cms)';...
        '*.res','Restart-files (*.res)';...
        '*.out','Output-files (*.out)';...
        '*.sum','Output-files (*.sum)';...
        '*.mat','Files saved by Matstab (*.mat)';...
        '*.hms','Hermes-files (*.hms)';...
        '*.h5;*.hdf5','Database Files (*.h5, *.hdf5)';...
        '*.dat','Polca Distribution files (*.dat)';...
        '*.*', 'All files (*.*)'},...
        'Pick a file');
    fullname = [pathname filename];
    if ischar(pathname)
        if strcmp(comp_prop.file1.fileinfo.fullname,fullname)
            newinfo = comp_prop.file1;
            eval([extr_prop.filestr '= newinfo;']);
        elseif strcmp(comp_prop.file2.fileinfo.fullname,fullname)
            newinfo = comp_prop.file2;
            eval([extr_prop.filestr '= newinfo;']);
        else
            temph = waitbar(0.5,'Updating distlist, Please wait...');
            newinfo = ReadCore(fullname);
            eval([extr_prop.filestr '= newinfo;']);
            delete(temph);
        end
        set(comp_prop.handels.Popup(comp_prop.numdist),'String',newinfo.distlist);
        set(comp_prop.handels.Edit(comp_prop.numdist),'String',fullname);
        set(extr_prop.parhand,'userdata',comp_prop);  
    end
end

function Cancelbutt(h,~)
    hand = get(h);
    delete(hand.Parent);
end

function Okext(h,~)
    hand = get(h);
    delete(hand.Parent);
end

function Okbutt(h,~)
    hand = get(h);
    comp_prop = get(hand.Parent,'userdata');
    for i = 1:comp_prop.numdist
        evalstrdi = ['dist{' num2str(i) '} = ReadCore(comp_prop.file' num2str(i) ', comp_prop.dist' num2str(i) ',comp_prop.st_pt);'];
        eval(evalstrdi);
        evalstrnm = ['distname{' num2str(i) '} = comp_prop.dist' num2str(i) ';'];
        eval(evalstrnm);
        evalinf = ['coreinfo{' num2str(i) '} = comp_prop.file' num2str(i) ';']; 
        eval(evalinf);
    end
    
    delete(hand.Parent);
    compare2(dist,distname,coreinfo);
end

function Cancelext(h,~)
    hand = get(h);
    extr_prop = get(hand.Parent,'userdata');
    comp_prop = get(extr_prop.parhand,'userdata');
    eval(['comp_prop = rmfield(comp_prop,{''file' num2str(comp_prop.numdist) ''',''dist' num2str(comp_prop.numdist) '''});'])
    comp_prop.numdist = comp_prop.numdist -1;
    delete(hand.Parent);
end

function Extradist(h,~)

hand = get(h);
parent = get(hand.Parent);
comp_prop = parent.UserData;
comp_prop.numdist = comp_prop.numdist +1;
parpos = parent.Position;
xsid = parpos(3);
ysid = parpos(4)/3;
pos = [parpos(1) parpos(2)*1.3 xsid ysid];
filestr = ['comp_prop.file' num2str(comp_prop.numdist)];
diststr = ['comp_prop.dist' num2str(comp_prop.numdist)];
eval([filestr '= comp_prop.file1;']);
eval([diststr '= comp_prop.dist1;']);
extradist = figure('MenuBar','none','Name','Additional Distribution','NumberTitle','off','Position',pos);
extr_prop.filestr = filestr;
extr_prop.diststr = diststr;
extr_prop.parhand = hand.Parent;
set(extradist,'UserData',extr_prop);
comp_prop.handels.Edit(comp_prop.numdist) = uicontrol('Style','edit','String',comp_prop.file1.fileinfo.fullname,'Position',[xsid*0.06,ysid*0.7,xsid*0.6,ysid*0.24],'CallBack',@Edittextex);
comp_prop.handels.Choose(comp_prop.numdist) = uicontrol('Style','PushButton','String','Browse','Position',[xsid*0.7,ysid*0.5,xsid*0.2,ysid*0.24],'CallBack',@PushButtonPressedex);
comp_prop.handels.Popup(comp_prop.numdist) = uicontrol('Style','PopupMenu','String',comp_prop.file1.distlist,'Position',[xsid*0.06,ysid*0.4,xsid*0.6,ysid*0.24],'CallBack', @PopupMenuCallBackex);
uicontrol('Style','PushButton','String','Ok','Position',[xsid*0.1,ysid*0.1,xsid*0.35,ysid*0.24],'CallBack',@Okext);
uicontrol('Style','PushButton','String','Cancel','Position',[xsid*0.55,ysid*0.1,xsid*0.35,ysid*0.24],'CallBack',@Cancelext);
set(hand.Parent,'UserData',comp_prop);
end
