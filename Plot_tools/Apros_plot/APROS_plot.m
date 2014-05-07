function varargout = APROS_plot(varargin)
% APROS_PLOT M-file for APROS_plot.fig
%      APROS_PLOT, by itself, creates a new APROS_PLOT or raises the existing
%      singleton*.
%
%      H = APROS_PLOT returns the handle to a new APROS_PLOT or the handle to
%      the existing singleton*.
%
%      APROS_PLOT('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in APROS_PLOT.M with the given input arguments.
%
%      APROS_PLOT('Property','Value',...) creates a new APROS_PLOT or
%      raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before APROS_plot_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to APROS_plot_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Copyright 2002-2003 The MathWorks, Inc.

% Edit the above text to modify the response to help APROS_plot

% Last Modified by GUIDE v2.5 28-Oct-2009 14:37:42

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @APROS_plot_OpeningFcn, ...
                   'gui_OutputFcn',  @APROS_plot_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before APROS_plot is made visible.
function APROS_plot_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to APROS_plot (see VARARGIN)

% Choose default command line output for APROS_plot
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes APROS_plot wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = APROS_plot_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in Update.
function Update_Callback(hObject, eventdata, handles)
% hObject    handle to Update (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

seekl_1=0;
seekl_2=0;
Mtot=[];
M1tot=[];
M2tot=[];
close_Callback
set(handles.stop,'Enable','on')
set(handles.close,'Enable','off')
set(handles.Update,'Enable','off')
set(handles.avsluta,'Enable','off')

APR_pathfile=handles.APR_pathfile;

while strcmp(get(handles.stop,'Enable'),'on')
    fid=fopen(APR_pathfile(1,:));
    num_var=str2num(fgetl(fid));
    signaler='';
    signaler2='';
    for i=1:num_var
        signaler = strvcat(signaler,fgetl(fid));
    end
    fclose(fid);
    try
        M1 = dlmread(APR_pathfile(1,:),'%f',(num_var+1)+seekl_1,0);
        if ~isempty(M1)
            [m,n]=size(signaler);
            M1=M1(:,1:m); % Ev. en extra rad läses in som måste tas bort
            t=M1(:,1);
            
        end
        
        M1tot=[M1tot;M1];
        [m,n]=size(M1tot);
        seekl_1=m;
    catch
    end
        
    if(length(APR_pathfile(:,1)))>1
        fid=fopen(APR_pathfile(2,:));
        num_var=str2num(fgetl(fid));
        for i=1:num_var
            signaler2 = strvcat(signaler2,fgetl(fid));  % Dubbla tider är kvar !!!!
        end
        fclose(fid);
        try
            M2 = dlmread(APR_pathfile(2,:),'%f',(num_var+1)+seekl_2,0);
            if ~isempty(M2)
                [m,n]=size(signaler2);
                M2=M2(:,1:m); % Ev. en extra rad läses in som måste tas bort
                [m,n]=size(M2);
            end
            
            M2tot=[M2tot;M2];
            [m,n]=size(M1tot);
            M2tot=M2tot(1:m,:); % Fix för att M2 blir något sampel längre vid realtidsuppdatering
            seekl_2=m;
        catch
        end
        
        Mtot=[M1tot,M2tot];
        signaler=strvcat(signaler,signaler2);
    else
        Mtot=M1tot;
    end
    
    data.nvar = size(signaler,1); % Plockar bort tiden

    % Store signal data
    for i=1:data.nvar
        data.signal(i).data = Mtot(:,i);
        data.signal(i).label = signaler(i,:);
    end
    ut=data;

    slVal=round(get(handles.slider,'Value'));
    tout=data.signal(1).data(end);
    tin=data.signal(1).data(1);
    if (tout-tin)>slVal
        tout=ceil(tout);
        tin=floor(tout-slVal);
        I = find(data.signal(1).data>tin);
        for i=1:length(data.signal)
            data.signal(i).data=data.signal(i).data(I);
        end
    end

    w_val=get(get(handles.uipanel,'SelectedObject'),'String');
    bt_val=get(handles.b_text,'Value');
    switch w_val
        case '1'

            if exist('sig2')
                %sig2
                %delete(sig2)
                %delete(sig3)
            end
            effe=get(handles.dd120_check,'Value');
            if effe==0
                % Tillåtet driftområde
                %     HC-flöde, APRM
                till = [2500  ,   0;
                    3000  ,  25;
                    3700  ,  38;
                    3900  ,  74;
                    9500  , 108;
                    12000 , 108;
                    12000 ,  20;
                    8000 ,  20;
                    8000 ,   0];

                % Nedstyrning på filtrerad signal
                %      HC-flöde, APRM
                e3   = [ 2000  ,  66;
                    9500  , 114;
                    13000  , 114];

                % SS på filtrerad signal
                %      HC-flöde, APRM
                ss9  = [ 2000  ,  69;
                    9500  , 117;
                    13000  , 117];

                % Nedstyrning på ofiltrerad signal
                %      HC-flöde, APRM
                e4   = [ 2000  ,  80.5;
                    9500  , 126;
                    13000  , 126];

                % SS på ofiltrerad signal
                %      HC-flöde, APRM
                ss10 = [ 2000  ,  87.5;
                    9500  , 133;
                    13000  , 133];
                % Delsnabbstoppslinje
                delss = [ 2000 ,  60;
                    4000 ,  60;
                    8255 , 133];

            else
                e3   = [   0,   72;
                    1900,   72;
                    10000,  126;
                    14000 , 126];

                ss9  = [    0,  76;
                    1900,  76;
                    10000, 130;
                    14000, 130];

                e4   = [    0,  81;
                    1900,  81;
                    10000, 135;
                    14000, 135];

                ss10 = [    0,  86;
                    1900, 86;
                    10000, 140;
                    14000, 140];

                delss = [   0,  30;
                    2800,  30;
                    9900, 160;
                    14000, 160];

               till = [2500  ,   0;
                    3100  ,  30;
                    6850  ,  99;
                    10000  ,  120;
                    12000  , 120;
                    12600 , 65;
                    12000 ,  55;
                    8000 ,  10;
                    8000 ,   0];
            end
            scnsize=get(0,'ScreenSize');
            subplot(3,4,1)
            set(gcf,'Position',[scnsize(1),scnsize(2)+scnsize(2)+200,scnsize(3),scnsize(4)-280])
            h=area(till(:,1),till(:,2));
            hold on
            set(h,'FaceColor',[0,1,0]);
            sig1=plot(h,data.signal(4).data,data.signal(2).data*100,data.signal(5).data,data.signal(3).data*100);
            sig2=plot(h,data.signal(4).data(end),data.signal(2).data(end)*100,'xr',data.signal(5).data(end),data.signal(3).data(end)*100,'xr');
            %sig3=plot(h,data.signal(5).data(end),data.signal(3).data(end)*100,'xr');
            apa=plot(e3(:,1),e3(:,2),'-.',...
                e4(:,1),e4(:,2),'--',...
                ss9(:,1),ss9(:,2),'-.',...
                ss10(:,1),ss10(:,2),'--',...
                delss(:,1),delss(:,2),'-.');
            title('Driftområdesdiagram')
            xlabel('HC-flöde [kg/s]')
            ylabel('Effekt [%]')
            axis tight
            %axis([5000,9000,75,108]);
            if bt_val==1;
                leg=legend(sig1,'Ofilt','Filt');
                legend('boxoff')
                %set(leg,'Location','Best','FontSize',8,'Interpreter','none')
                set(gca,'LegendColorbarListeners',[]); 
                setappdata(gca,'LegendColorbarManualSpace',1);
                setappdata(gca,'LegendColorbarReclaimSpace',1);
            end
            grid on
            hold off
            subplot(3,4,2)
            x=data.signal(1).data;
            y=data.signal(2).data*100;
            da=findobj(gca,'Type','line');
            if ~isempty(get(da)) && length(y(1,:))==length(da)
                set(da,'XData',x,'YData',y);
                drawnow
            else
                plot(x,y);
            end
            ma=max(y);
            mi=min(y);
            axis([x(1),x(end),mi*0.99,ma*1.01]);
            if bt_val==1;
                leg=legend('531K95X');
                legend('boxoff')
                %set(leg,'Location','Best','FontSize',8,'Interpreter','none')
                set(gca,'LegendColorbarListeners',[]); 
                setappdata(gca,'LegendColorbarManualSpace',1);
                setappdata(gca,'LegendColorbarReclaimSpace',1);
            end
            title('Reaktoreffekt')
            xlabel('Tid [s]')
            ylabel('Effekt [%]')
            grid on

            subplot(3,4,3)
            x=data.signal(1).data;
            y=data.signal(4).data;
            da=findobj(gca,'Type','line');
            if ~isempty(get(da)) && length(y(1,:))==length(da)
                set(da,'XData',x,'YData',y);
                drawnow
            else
                plot(x,y);
            end
            ma=max(y);
            mi=min(y);
            axis([x(1),x(end),mi*0.99,ma*1.01]);
            if bt_val==1;
                leg=legend('211K03X');
                legend('boxoff')
                %set(leg,'Location','Best','FontSize',8,'Interpreter','none')
                set(gca,'LegendColorbarListeners',[]); 
                setappdata(gca,'LegendColorbarManualSpace',1);
                setappdata(gca,'LegendColorbarReclaimSpace',1);
            end
            tmp=get(gca,'YTick');
            set(gca,'YtickLabel',tmp)
            
            title('HC-flöde')
            ylabel('Massflöde [kg/s]')
            xlabel('Tid [s]')
            grid on

            subplot(3,4,4)
            x=data.signal(1).data;
            y=data.signal(6).data/1e5-1+1;
            da=findobj(gca,'Type','line');
            if ~isempty(get(da)) && length(y(1,:))==length(da)
                set(da,'XData',x,'YData',y);
                drawnow
            else
                plot(x,y);
            end
            ma=max(y);
            mi=min(y);
            axis([x(1),x(end),(mi*0.995),(ma*1.005)]);
            if bt_val==1;
                leg=legend('211K10X');
                legend('boxoff')
                %set(leg,'Location','Best','FontSize',8,'Interpreter','none')
                set(gca,'LegendColorbarListeners',[]); 
                setappdata(gca,'LegendColorbarManualSpace',1);
                setappdata(gca,'LegendColorbarReclaimSpace',1);
            end
            title('Reaktortryck')
            ylabel('Tryck [bar]')
            xlabel('Tid [s]')
            grid on

            subplot(3,4,5)
            x=data.signal(1).data;
            y=[data.signal(7).data,data.signal(8).data,data.signal(9).data];
            da=findobj(gca,'Type','line');
            if ~isempty(get(da)) && length(y(1,:))==length(da)
                for ii=1:length(y(1,:))
                set(da(ii),'XData',x,'YData',y(:,ii));
                drawnow
                end
            else
                plot(x,y);
            end
            temp=y;
            [ir,ic]=find(temp==max(temp(:)));
            ma=temp(ir(1),ic(1));
            [ir,ic]=find(temp==min(temp(:)));
            mi=temp(ir(1),ic(1));
            axis([x(1),x(end),mi-(0.03*mi),ma+(0.03*ma)]);
            if bt_val==1;
                leg=legend('211K40X','211K41X','211K43X');
                legend('boxoff')
                %set(leg,'Location','Best','FontSize',8,'Interpreter','none')
                set(gca,'LegendColorbarListeners',[]); 
                setappdata(gca,'LegendColorbarManualSpace',1);
                setappdata(gca,'LegendColorbarReclaimSpace',1);
            end
            title('Reaktornivåer')
            ylabel('Nivå [möh]')
            xlabel('Tid [s]')
            grid on

            x=data.signal(1).data;
            y=[data.signal(10).data];

            subplot(3,4,6)
            da=findobj(gca,'Type','line');
            if ~isempty(get(da)) && length(y(1,:))==length(da)
                set(da,'XData',x,'YData',y);
                drawnow
            else
                plot(x,y);
            end
            temp=y;
            [ir,ic]=find(temp==max(temp(:)));
            ma=temp(ir(1),ic(1));
            [ir,ic]=find(temp==min(temp(:)));
            mi=temp(ir(1),ic(1));
            axis([data.signal(1).data(1),data.signal(1).data(end),mi-(0.01*mi),ma+(0.01*ma)]);
            if bt_val==1;
                leg=legend('211K55X');
                legend(leg,'boxoff')
                %set(leg,'Location','Best','FontSize',8,'Interpreter','none')
                set(gca,'LegendColorbarListeners',[]); 
                setappdata(gca,'LegendColorbarManualSpace',1);
                setappdata(gca,'LegendColorbarReclaimSpace',1);
            end
            title('Härdkylflödestemperatur')
            ylabel('Temperatur [C]')
            xlabel('Tid [s]')
            grid on


            x=data.signal(1).data;
            y=[data.signal(11).data*100,data.signal(12).data*100];
            subplot(3,4,7)
            da=findobj(gca,'Type','line');
            if ~isempty(get(da)) && length(y(1,:))==length(da)
                for ii=1:length(y(1,:))
                set(da(ii),'XData',x,'YData',y(:,ii));
                drawnow
                end
            else
                plot(x,y);
            end
            temp=y;
            [ir,ic]=find(temp==max(temp(:)));
            ma=temp(ir(1),ic(1));
            [ir,ic]=find(temp==min(temp(:)));
            mi=temp(ir(1),ic(1));
            axis([x(1),x(end),mi-(0.05*abs(mi)),ma+(0.05*abs(ma))]);
            if bt_val==1;
                leg=legend('314V21 pos','314V22 pos');
                legend(leg,'boxoff')
                %set(leg,'Location','Best','FontSize',8,'Interpreter','none')
                set(gca,'LegendColorbarListeners',[]); 
                setappdata(gca,'LegendColorbarManualSpace',1);
                setappdata(gca,'LegendColorbarReclaimSpace',1);
            end
            title('Position 314 ventiler')
            ylabel('Ventilläge [C]')
            xlabel('Tid [s]')
            grid on

            x=data.signal(1).data;
            y=[data.signal(13).data*100];

            subplot(3,4,8)
            da=findobj(gca,'Type','line');
            if ~isempty(get(da)) && length(y(1,:))==length(da)
                set(da,'XData',x,'YData',y);
                drawnow
            else
                plot(x,y);
            end
            temp=y;
            [ir,ic]=find(temp==max(temp(:)));
            ma=temp(ir(1),ic(1));
            [ir,ic]=find(temp==min(temp(:)));
            mi=temp(ir(1),ic(1));

            axis([x(1),x(end),mi-(0.02*abs(mi)),ma+(0.02*abs(ma))]);
            if bt_val==1;
                leg=legend('BÅFR');
                legend(leg,'boxoff')
                %set(leg,'Location','Best','FontSize',8,'Interpreter','none')
                set(gca,'LegendColorbarListeners',[]); 
                setappdata(gca,'LegendColorbarManualSpace',1);
                setappdata(gca,'LegendColorbarReclaimSpace',1);
            end
            title('BÅFR')
            ylabel('BÅFR [%]')
            xlabel('Tid [s]')
            grid on



            x=data.signal(1).data;
            y=[data.signal(14).data,data.signal(15).data];

            subplot(3,4,9)
            da=findobj(gca,'Type','line');
            if ~isempty(get(da)) && length(y(1,:))==length(da)
                for ii=1:length(y(1,:))
                set(da(ii),'XData',x,'YData',y(:,ii));
                drawnow
                end
            else
                plot(x,y);
            end
            temp=y;
            [ir,ic]=find(temp==max(temp(:)));
            ma=temp(ir(1),ic(1));
            [ir,ic]=find(temp==min(temp(:)));
            mi=temp(ir(1),ic(1));

            axis([x(1),x(end),mi*0.99,ma*1.01]);
            %axis([x(1),x(end),100,300]);
            
            if bt_val==1;
                leg=legend('415K301','415K302');
                legend(leg,'boxoff')
                %set(leg,'Location','Best','FontSize',8,'Interpreter','none')
                set(gca,'LegendColorbarListeners',[]); 
                setappdata(gca,'LegendColorbarManualSpace',1);
                setappdata(gca,'LegendColorbarReclaimSpace',1);
            end
            title('MAVA-flöde')
            ylabel('Massflöde [kg/s]')
            xlabel('Tid [s]')
            grid on

            x=data.signal(1).data;
            y=[data.signal(16).data,data.signal(17).data,data.signal(18).data];
            subplot(3,4,10)
            da=findobj(gca,'Type','line');
            if ~isempty(get(da)) && length(y(1,:))==length(da)
                for ii=1:length(y(1,:))
                set(da(ii),'XData',x,'YData',y(:,ii));
                drawnow
                end
            else
                plot(x,y);
            end
            temp=y;
            [ir,ic]=find(temp==max(temp(:)));
            ma=temp(ir(1),ic(1));
            [ir,ic]=find(temp==min(temp(:)));
            mi=temp(ir(1),ic(1));

            axis([x(1),x(end),mi-(0.01*mi),ma+(0.01*ma)]);
            if bt_val==1;
                leg=legend('415-bland','415K501','415K502');
                legend(leg,'boxoff')
                %set(leg,'Location','Best','FontSize',8,'Interpreter','none')
                set(gca,'LegendColorbarListeners',[]); 
                setappdata(gca,'LegendColorbarManualSpace',1);
                setappdata(gca,'LegendColorbarReclaimSpace',1);
            end
            title('MAVA-temperatur')
            ylabel('Temperatur [C]')
            xlabel('Tid [s]')
            grid on

            x=data.signal(1).data;
            y=[data.signal(19).data,data.signal(20).data,data.signal(21).data,data.signal(22).data];
            subplot(3,4,11)
            da=findobj(gca,'Type','line');
            if ~isempty(get(da)) && length(y(1,:))==length(da)
                for ii=1:length(y(1,:))
                set(da(ii),'XData',x,'YData',y(:,ii));
                drawnow
                end
            else
                plot(x,y);
            end
            temp=y;
            [ir,ic]=find(temp==max(temp(:)));
            ma=temp(ir(1),ic(1));
            [ir,ic]=find(temp==min(temp(:)));
            mi=temp(ir(1),ic(1));

            axis([x(1),x(end),mi-(0.02*mi),ma+(0.02*ma)]);
            if bt_val==1;
                leg=legend('411K301','411K303','411K302','411K304');
                legend(leg,'boxoff')
                %set(leg,'Location','Best','FontSize',8,'Interpreter','none')
                set(gca,'LegendColorbarListeners',[]); 
                setappdata(gca,'LegendColorbarManualSpace',1);
                setappdata(gca,'LegendColorbarReclaimSpace',1);
            end
            title('Ångflöde')
            ylabel('Massflöde [kg/s]')
            xlabel('Tid [s]')
            grid on

            x=data.signal(1).data;
            y=[data.signal(23).data*1,data.signal(24).data*2,data.signal(25).data*3,data.signal(26).data*4,...
                data.signal(27).data*5,data.signal(28).data*6,data.signal(29).data*7,data.signal(30).data*8,...
                data.signal(31).data*9,data.signal(32).data*10,data.signal(33).data*11,data.signal(34).data*12,...
                data.signal(35).data*13,data.signal(36).data*14,data.signal(37).data*15];
            subplot(3,4,12)
            da=findobj(gca,'Type','line');
            if ~isempty(get(da)) && length(y(1,:))==length(da)
                for ii=1:length(y(1,:))
                set(da(ii),'XData',x,'YData',y(:,ii));
                drawnow
                end
            else
                plot(x,y);
            end
            temp=y;
            [ir,ic]=find(temp==max(temp(:)));
            ma=temp(ir(1),ic(1));
            [ir,ic]=find(temp==min(temp(:)));
            mi=temp(ir(1),ic(1));

            axis([x(1),x(end),0,16]); %Special
            set(gca,'YTick',[0 2 4 6 8 10 12 14 16])
            if bt_val==1;
                leg=legend('1. SS','2. delSS','3. I','4. E','5. A','6. M','7. TB','8. N','9. 21-TSXD',...
                    '10. 22-TSXD','11. 21-TS','12. 22-TS','13. 21-DB','14. 22-DB','15. Nedstyrning');
                legend(leg,'boxoff')
                %set(leg,'Location','Best','FontSize',8,'Interpreter','none')
                set(gca,'LegendColorbarListeners',[]); 
                setappdata(gca,'LegendColorbarManualSpace',1);
                setappdata(gca,'LegendColorbarReclaimSpace',1);
            end
            title('516 + 583')
            ylabel('Signal')
            xlabel('Tid [s]')
            grid on

        case '2'

            x=data.signal(1).data;
            y=[data.signal(38).data*100,data.signal(39).data*100];
            scnsize=get(0,'ScreenSize');
            subplot(3,4,1)
            set(gcf,'Position',[scnsize(1),scnsize(2)+scnsize(2)+200,scnsize(3),scnsize(4)-280])
            da=findobj(gca,'Type','line');
            if ~isempty(get(da)) && length(y(1,:))==length(da)
                for ii=1:length(y(1,:))
                set(da(ii),'XData',x,'YData',y(:,ii));
                drawnow
                end
            else
                plot(x,y);
            end
            temp=y;
            [ir,ic]=find(temp==max(temp(:)));
            ma=temp(ir(1),ic(1));
            [ir,ic]=find(temp==min(temp(:)));
            mi=temp(ir(1),ic(1));

            axis([x(1),x(end),mi-(0.05*abs(mi)),ma+(0.05*abs(ma))]);
            if bt_val==1;
                leg=legend('BÅTT1','BÅTK1');
                legend(leg,'boxoff')
%                 set(leg,'Location','Best')
%                 set(leg,'FontSize',8)
%                 set(leg,'Interpreter','none')
                set(gca,'LegendColorbarListeners',[]); 
                setappdata(gca,'LegendColorbarManualSpace',1);
                setappdata(gca,'LegendColorbarReclaimSpace',1);
            end
            title('BÅTT1, BÅTK1')
            ylabel('Signal [%]')
            xlabel('Tid [s]')
            grid on

            x=data.signal(1).data;
            y=[data.signal(40).data*100,data.signal(41).data*100,data.signal(42).data*100,data.signal(43).data*100];
            subplot(3,4,2)
            da=findobj(gca,'Type','line');
            if ~isempty(get(da)) && length(y(1,:))==length(da)
                for ii=1:length(y(1,:))
                set(da(ii),'XData',x,'YData',y(:,ii));
                drawnow
                end
            else
                plot(x,y);
            end
            temp=y;
            [ir,ic]=find(temp==max(temp(:)));
            ma=temp(ir(1),ic(1));
            [ir,ic]=find(temp==min(temp(:)));
            mi=temp(ir(1),ic(1));

            axis([x(1),x(end),mi-(abs(mi)*0.05)-0.1,ma+(abs(ma)*0.05)+0.1]);
            if bt_val==1;
                leg=legend('411V501','411V503','411V505','411V507');
                legend(leg,'boxoff')
%                 set(leg,'Location','Best')
%                 set(leg,'FontSize',8)
%                 set(leg,'Interpreter','none')
                set(gca,'LegendColorbarListeners',[]); 
                setappdata(gca,'LegendColorbarManualSpace',1);
                setappdata(gca,'LegendColorbarReclaimSpace',1);
            end
            title('HTRV ventilläge')
            ylabel('Ventilläge [%]')
            xlabel('Tid [s]')
            grid on

            x=data.signal(1).data;
            y=[data.signal(44).data*10];
            subplot(3,4,3)
            da=findobj(gca,'Type','line');
            if ~isempty(get(da)) && length(y(1,:))==length(da)
                for ii=1:length(y(1,:))
                set(da(ii),'XData',x,'YData',y(:,ii));
                drawnow
                end
            else
                plot(x,y);
            end
            temp=y;
            [ir,ic]=find(temp==max(temp(:)));
            ma=temp(ir(1),ic(1));
            [ir,ic]=find(temp==min(temp(:)));
            mi=temp(ir(1),ic(1));

            axis([x(1),x(end),mi-(mi*0.001),ma+(ma*0.001)]);
            if bt_val==1;
                leg=legend('413K16X');
                legend(leg,'boxoff')
%                 set(leg,'Location','Best')
%                 set(leg,'FontSize',8)
%                 set(leg,'Interpreter','none')
                set(gca,'LegendColorbarListeners',[]); 
                setappdata(gca,'LegendColorbarManualSpace',1);
                setappdata(gca,'LegendColorbarReclaimSpace',1);
            end
            title('Tryck kondensor')
            ylabel('Tryck [bara]')
            xlabel('Tid [s]')
            grid on

            x=data.signal(1).data;
            y=[data.signal(45).data];
            subplot(3,4,4)
            da=findobj(gca,'Type','line');
            if ~isempty(get(da)) && length(y(1,:))==length(da)
                for ii=1:length(y(1,:))
                set(da(ii),'XData',x,'YData',y(:,ii));
                drawnow
                end
            else
                plot(x,y);
            end
            temp=y;
            [ir,ic]=find(temp==max(temp(:)));
            ma=temp(ir(1),ic(1));
            [ir,ic]=find(temp==min(temp(:)));
            mi=temp(ir(1),ic(1));

            axis([x(1),x(end),mi-(mi*0.01),ma+(ma*0.01)]);
            if bt_val==1;
                leg=legend('413K45X');
                legend(leg,'boxoff')
%                 set(leg,'Location','Best')
%                 set(leg,'FontSize',8)
%                 set(leg,'Interpreter','none')
                set(gca,'LegendColorbarListeners',[]); 
                setappdata(gca,'LegendColorbarManualSpace',1);
                setappdata(gca,'LegendColorbarReclaimSpace',1);
            end
            title('Nivå kondensor')
            ylabel('Nivå [m]')
            xlabel('Tid [s]')
            grid on

            x=data.signal(1).data;
            y=[data.signal(46).data,data.signal(47).data,data.signal(58).data*100,data.signal(59).data*100,data.signal(60).data*100,data.signal(61).data*100];
            subplot(3,4,5)
            da=findobj(gca,'Type','line');
            if ~isempty(get(da)) && length(y(1,:))==length(da)
                for ii=1:length(y(1,:))
                set(da(ii),'XData',x,'YData',y(:,ii));
                drawnow
                end
            else
                plot(x,y);
            end
            temp=y;
            [ir,ic]=find(temp==max(temp(:)));
            ma=temp(ir(1),ic(1));
            [ir,ic]=find(temp==min(temp(:)));
            mi=temp(ir(1),ic(1));

            axis([x(1),x(end),mi-(mi*0.2)-0.1,ma+(ma*0.2)+0.1]);
            if bt_val==1;
                leg=legend('414T1','414T2','414V57','414V58','414V47','414V48');
                legend(leg,'boxoff')
%                 set(leg,'Location','Best')
%                 set(leg,'FontSize',8)
%                 set(leg,'Interpreter','none')
                set(gca,'LegendColorbarListeners',[]); 
                setappdata(gca,'LegendColorbarManualSpace',1);
                setappdata(gca,'LegendColorbarReclaimSpace',1);
            end
            title('Nivå 414 T1/T2, ventillägen')
            ylabel('Nivå/Ventillägen [%]')
            xlabel('tid [s]')
            grid on


            x=data.signal(1).data;
            y=[data.signal(48).data,data.signal(49).data,data.signal(62).data*100,data.signal(63).data*100];
            subplot(3,4,6)
            da=findobj(gca,'Type','line');
            if ~isempty(get(da)) && length(y(1,:))==length(da)
                for ii=1:length(y(1,:))
                set(da(ii),'XData',x,'YData',y(:,ii));
                drawnow
                end
            else
                plot(x,y);
            end
            temp=y;
            [ir,ic]=find(temp==max(temp(:)));
            ma=temp(ir(1),ic(1));
            [ir,ic]=find(temp==min(temp(:)));
            mi=temp(ir(1),ic(1));

            axis([x(1),x(end),mi-(mi*0.2)-0.1,ma+(ma*0.2)+0.1]);
            if bt_val==1;
                leg=legend('414T3','414T4','414V39','414V40');
                legend(leg,'boxoff')
%                 set(leg,'Location','Best')
%                 set(leg,'FontSize',8)
%                 set(leg,'Interpreter','none')
                set(gca,'LegendColorbarListeners',[]); 
                setappdata(gca,'LegendColorbarManualSpace',1);
                setappdata(gca,'LegendColorbarReclaimSpace',1);
            end
            title('Nivå 414 T3/T4, ventillägen')
            ylabel('Nivå/Ventillägen [%]')
            xlabel('tid [s]')
            grid on


            x=data.signal(1).data;
            y=[data.signal(50).data,data.signal(64).data*100,data.signal(66).data*100];
            subplot(3,4,7)
            da=findobj(gca,'Type','line');
            if ~isempty(get(da)) && length(y(1,:))==length(da)
                for ii=1:length(y(1,:))
                set(da(ii),'XData',x,'YData',y(:,ii));
                drawnow
                end
            else
                plot(x,y);
            end
            temp=y;
            [ir,ic]=find(temp==max(temp(:)));
            ma=temp(ir(1),ic(1));
            [ir,ic]=find(temp==min(temp(:)));
            mi=temp(ir(1),ic(1));

            axis([x(1),x(end),mi-(mi*0.2)-0.1,ma+(ma*0.2)+0.1]);
            if bt_val==1;
                leg=legend('415T301','415V327','415V329');
                legend(leg,'boxoff')
%                 set(leg,'Location','Best')
%                 set(leg,'FontSize',8)
%                 set(leg,'Interpreter','none')
                set(gca,'LegendColorbarListeners',[]); 
                setappdata(gca,'LegendColorbarManualSpace',1);
                setappdata(gca,'LegendColorbarReclaimSpace',1);
            end
            title('Nivå 415T301, ventillägen')
            ylabel('Nivå/Ventillägen [%]')
            xlabel('tid [s]')
            grid on

            x=data.signal(1).data;
            y=[data.signal(51).data,data.signal(65).data*100,data.signal(67).data*100];
            subplot(3,4,8)
            da=findobj(gca,'Type','line');
            if ~isempty(get(da)) && length(y(1,:))==length(da)
                for ii=1:length(y(1,:))
                set(da(ii),'XData',x,'YData',y(:,ii));
                drawnow
                end
            else
                plot(x,y);
            end
            temp=y;
            [ir,ic]=find(temp==max(temp(:)));
            ma=temp(ir(1),ic(1));
            [ir,ic]=find(temp==min(temp(:)));
            mi=temp(ir(1),ic(1));

            axis([x(1),x(end),mi-(mi*0.2)-0.1,ma+(ma*0.2)+0.1]);
            if bt_val==1;
                leg=legend('415T302','415V328','415V330');
                legend(leg,'boxoff')
%                 set(leg,'Location','Best')
%                 set(leg,'FontSize',8)
%                 set(leg,'Interpreter','none')
                set(gca,'LegendColorbarListeners',[]); 
                setappdata(gca,'LegendColorbarManualSpace',1);
                setappdata(gca,'LegendColorbarReclaimSpace',1);
            end
            title('Nivå 415T302, ventillägen')
            ylabel('Nivå/Ventillägen [%]')
            xlabel('tid [s]')
            grid on
            
            

            x=data.signal(1).data;
            y=[data.signal(52).data,data.signal(53).data,data.signal(68).data*100,data.signal(69).data*100];
            subplot(3,4,9)
            da=findobj(gca,'Type','line');
            if ~isempty(get(da)) && length(y(1,:))==length(da)
                for ii=1:length(y(1,:))
                set(da(ii),'XData',x,'YData',y(:,ii));
                drawnow
                end
            else
                plot(x,y);
            end
            temp=y;
            [ir,ic]=find(temp==max(temp(:)));
            ma=temp(ir(1),ic(1));
            [ir,ic]=find(temp==min(temp(:)));
            mi=temp(ir(1),ic(1));

            axis([x(1),x(end),mi-(mi*0.2)-0.1,ma+(ma*0.2)+0.1]);
            if bt_val==1;
                leg=legend('415T303','415T304','415V321','415V322');
                legend(leg,'boxoff')
%                 set(leg,'Location','Best')
%                 set(leg,'FontSize',8)
%                 set(leg,'Interpreter','none')
                set(gca,'LegendColorbarListeners',[]); 
                setappdata(gca,'LegendColorbarManualSpace',1);
                setappdata(gca,'LegendColorbarReclaimSpace',1);
            end
            title('Nivå 415 T303/T304, ventillägen')
            ylabel('Nivå/Ventillägen [%]')
            xlabel('tid [s]')
            grid on

            x=data.signal(1).data;
            y=[data.signal(54).data,data.signal(55).data,data.signal(70).data*100,data.signal(71).data*100];
            subplot(3,4,10)
            da=findobj(gca,'Type','line');
            if ~isempty(get(da)) && length(y(1,:))==length(da)
                for ii=1:length(y(1,:))
                set(da(ii),'XData',x,'YData',y(:,ii));
                drawnow
                end
            else
                plot(x,y);
            end
            temp=y;
            [ir,ic]=find(temp==max(temp(:)));
            ma=temp(ir(1),ic(1));
            [ir,ic]=find(temp==min(temp(:)));
            mi=temp(ir(1),ic(1));

            axis([x(1),x(end),mi-(mi*0.2)-0.1,ma+(ma*0.2)+0.1]);
            if bt_val==1;
                leg=legend('418T1','418T2','418V25','418V26');
                legend(leg,'boxoff')
%                 set(leg,'Location','Best')
%                 set(leg,'FontSize',8)
%                 set(leg,'Interpreter','none')
                set(gca,'LegendColorbarListeners',[]); 
                setappdata(gca,'LegendColorbarManualSpace',1);
                setappdata(gca,'LegendColorbarReclaimSpace',1);
            end
            title('Nivå 418 T1/T2, ventillägen')
            ylabel('Nivå/Ventillägen [%]')
            xlabel('tid [s]')
            grid on

            x=data.signal(1).data;
            y=[data.signal(56).data,data.signal(72).data*100,data.signal(74).data*100];
            subplot(3,4,11)
            da=findobj(gca,'Type','line');
            if ~isempty(get(da)) && length(y(1,:))==length(da)
                for ii=1:length(y(1,:))
                set(da(ii),'XData',x,'YData',y(:,ii));
                drawnow
                end
            else
                plot(x,y);
            end
            temp=y;
            [ir,ic]=find(temp==max(temp(:)));
            ma=temp(ir(1),ic(1));
            [ir,ic]=find(temp==min(temp(:)));
            mi=temp(ir(1),ic(1));

            axis([x(1),x(end),mi-(mi*0.2)-0.1,ma+(ma*0.2)+0.1]);
            if bt_val==1;
                leg=legend('418T3','418V33','418V37');
                legend(leg,'boxoff')
%                 set(leg,'Location','Best')
%                 set(leg,'FontSize',8)
%                 set(leg,'Interpreter','none')
                set(gca,'LegendColorbarListeners',[]); 
                setappdata(gca,'LegendColorbarManualSpace',1);
                setappdata(gca,'LegendColorbarReclaimSpace',1);
            end
            title('Nivå 418T3, ventillägen')
            ylabel('Nivå/Ventillägen [%]')
            xlabel('tid [s]')
            grid on

            x=data.signal(1).data;
            y=[data.signal(57).data,data.signal(73).data*100,data.signal(75).data*100];
            subplot(3,4,12)
            da=findobj(gca,'Type','line');
           if ~isempty(get(da)) && length(y(1,:))==length(da)
                for ii=1:length(y(1,:))
                set(da(ii),'XData',x,'YData',y(:,ii));
                drawnow
                end
            else
                plot(x,y);
            end
            temp=y;
            [ir,ic]=find(temp==max(temp(:)));
            ma=temp(ir(1),ic(1));
            [ir,ic]=find(temp==min(temp(:)));
            mi=temp(ir(1),ic(1));

            axis([x(1),x(end),mi-(mi*0.2)-0.1,ma+(ma*0.2)+0.1]);
            if bt_val==1;
                leg=legend('418T4','418V34','418V38');
                legend(leg,'boxoff')
%                 set(leg,'Location','Best')
%                 set(leg,'FontSize',8)
%                 set(leg,'Interpreter','none')
                set(gca,'LegendColorbarListeners',[]); 
                setappdata(gca,'LegendColorbarManualSpace',1);
                setappdata(gca,'LegendColorbarReclaimSpace',1);
            end
            title('Nivå 418T4, ventillägen')
            ylabel('Nivå/Ventillägen [%]')
            xlabel('tid [s]')
            grid on

        case '3'
            x=data.signal(1).data;
            y=[data.signal(76).data*100,data.signal(77).data*100];
            scnsize=get(0,'ScreenSize');
            subplot(3,4,1)
            set(gcf,'Position',[scnsize(1),scnsize(2)+scnsize(2)+200,scnsize(3),scnsize(4)-280])
            da=findobj(gca,'Type','line');
            if ~isempty(get(da)) && length(y(1,:))==length(da)
                for ii=1:length(y(1,:))
                set(da(ii),'XData',x,'YData',y(:,ii));
                drawnow
                end
            else
                plot(x,y);
            end
            temp=y;
            [ir,ic]=find(temp==max(temp(:)));
            ma=temp(ir(1),ic(1));
            [ir,ic]=find(temp==min(temp(:)));
            mi=temp(ir(1),ic(1));

            axis([x(1),x(end),mi-(0.05*abs(mi))-0.1,ma+(0.05*abs(ma))+0.1]);
            if bt_val==1;
                leg=legend('BÅTT2','BÅTK2');
                legend(leg,'boxoff')
%                 set(leg,'Location','Best')
%                 set(leg,'FontSize',8)
%                 set(leg,'Interpreter','none')
                set(gca,'LegendColorbarListeners',[]); 
                setappdata(gca,'LegendColorbarManualSpace',1);
                setappdata(gca,'LegendColorbarReclaimSpace',1);
            end
            title('BÅTT2, BÅTK2')
            ylabel('Signal [%]')
            xlabel('Tid [s]')
            grid on

            x=data.signal(1).data;
            y=[data.signal(78).data*100,data.signal(79).data*100,data.signal(80).data*100,data.signal(81).data*100];
            subplot(3,4,2)
            da=findobj(gca,'Type','line');
            if ~isempty(get(da)) && length(y(1,:))==length(da)
                for ii=1:length(y(1,:))
                set(da(ii),'XData',x,'YData',y(:,ii));
                drawnow
                end
            else
                plot(x,y);
            end
            temp=y;
            [ir,ic]=find(temp==max(temp(:)));
            ma=temp(ir(1),ic(1));
            [ir,ic]=find(temp==min(temp(:)));
            mi=temp(ir(1),ic(1));

            axis([x(1),x(end),mi-(abs(mi)*0.05)-0.1,ma+(abs(ma)*0.05)+0.1]);
            if bt_val==1;
                leg=legend('411V501','411V503','411V505','411V507');
                legend(leg,'boxoff')
%                 set(leg,'Location','Best')
%                 set(leg,'FontSize',8)
%                 set(leg,'Interpreter','none')
                set(gca,'LegendColorbarListeners',[]); 
                setappdata(gca,'LegendColorbarManualSpace',1);
                setappdata(gca,'LegendColorbarReclaimSpace',1);
            end
            title('HTRV ventilläge')
            ylabel('Ventilläge [%]')
            xlabel('Tid [s]')
            grid on

            x=data.signal(1).data;
            y=[data.signal(82).data*10];
            subplot(3,4,3)
            da=findobj(gca,'Type','line');
            if ~isempty(get(da)) && length(y(1,:))==length(da)
                for ii=1:length(y(1,:))
                set(da(ii),'XData',x,'YData',y(:,ii));
                drawnow
                end
            else
                plot(x,y);
            end
            temp=y;
            [ir,ic]=find(temp==max(temp(:)));
            ma=temp(ir(1),ic(1));
            [ir,ic]=find(temp==min(temp(:)));
            mi=temp(ir(1),ic(1));

            axis([x(1),x(end),mi-(mi*0.001),ma+(ma*0.001)]);
            if bt_val==1;
                leg=legend('413K16X');
                legend(leg,'boxoff')
%                 set(leg,'Location','Best')
%                 set(leg,'FontSize',8)
%                 set(leg,'Interpreter','none')
                set(gca,'LegendColorbarListeners',[]); 
                setappdata(gca,'LegendColorbarManualSpace',1);
                setappdata(gca,'LegendColorbarReclaimSpace',1);
            end
            title('Tryck kondensor')
            ylabel('Tryck [bara]')
            xlabel('Tid [s]')
            grid on

            x=data.signal(1).data;
            y=[data.signal(83).data];
            subplot(3,4,4)
            da=findobj(gca,'Type','line');
            if ~isempty(get(da)) && length(y(1,:))==length(da)
                for ii=1:length(y(1,:))
                set(da(ii),'XData',x,'YData',y(:,ii));
                drawnow
                end
            else
                plot(x,y);
            end
            temp=y;
            [ir,ic]=find(temp==max(temp(:)));
            ma=temp(ir(1),ic(1));
            [ir,ic]=find(temp==min(temp(:)));
            mi=temp(ir(1),ic(1));

            axis([x(1),x(end),mi-(mi*0.01),ma+(ma*0.01)]);
            if bt_val==1;
                leg=legend('413K45X');
                legend(leg,'boxoff')
%                 set(leg,'Location','Best')
%                 set(leg,'FontSize',8)
%                 set(leg,'Interpreter','none')
                set(gca,'LegendColorbarListeners',[]); 
                setappdata(gca,'LegendColorbarManualSpace',1);
                setappdata(gca,'LegendColorbarReclaimSpace',1);
            end
            title('Nivå kondensor')
            ylabel('Nivå [m]')
            xlabel('Tid [s]')
            grid on

            x=data.signal(1).data;
            y=[data.signal(84).data,data.signal(85).data,data.signal(96).data*100,data.signal(97).data*100,data.signal(98).data*100,data.signal(99).data*100];
            subplot(3,4,5)
            da=findobj(gca,'Type','line');
            if ~isempty(get(da)) && length(y(1,:))==length(da)
                for ii=1:length(y(1,:))
                set(da(ii),'XData',x,'YData',y(:,ii));
                drawnow
                end
            else
                plot(x,y);
            end
            temp=y;
            [ir,ic]=find(temp==max(temp(:)));
            ma=temp(ir(1),ic(1));
            [ir,ic]=find(temp==min(temp(:)));
            mi=temp(ir(1),ic(1));

            axis([x(1),x(end),mi-(mi*0.2)-0.1,ma+(ma*0.2)+0.1]);
            if bt_val==1;
                leg=legend('414T1','414T2','414V57','414V58','414V47','414V48');
                legend(leg,'boxoff')
%                 set(leg,'Location','Best')
%                 set(leg,'FontSize',8)
%                 set(leg,'Interpreter','none')
                set(gca,'LegendColorbarListeners',[]); 
                setappdata(gca,'LegendColorbarManualSpace',1);
                setappdata(gca,'LegendColorbarReclaimSpace',1);
            end
            title('Nivå 414 T1/T2, ventillägen')
            ylabel('Nivå/Ventillägen [%]')
            xlabel('tid [s]')
            grid on


            x=data.signal(1).data;
            y=[data.signal(86).data,data.signal(87).data,data.signal(100).data*100,data.signal(101).data*100];
            subplot(3,4,6)
            da=findobj(gca,'Type','line');
            if ~isempty(get(da)) && length(y(1,:))==length(da)
                for ii=1:length(y(1,:))
                set(da(ii),'XData',x,'YData',y(:,ii));
                drawnow
                end
            else
                plot(x,y);
            end
            temp=y;
            [ir,ic]=find(temp==max(temp(:)));
            ma=temp(ir(1),ic(1));
            [ir,ic]=find(temp==min(temp(:)));
            mi=temp(ir(1),ic(1));

            axis([x(1),x(end),mi-(mi*0.2)-0.1,ma+(ma*0.2)+0.1]);
            if bt_val==1;
                leg=legend('414T3','414T4','414V39','414V40');
                legend(leg,'boxoff')
%                 set(leg,'Location','Best')
%                 set(leg,'FontSize',8)
%                 set(leg,'Interpreter','none')
                set(gca,'LegendColorbarListeners',[]); 
                setappdata(gca,'LegendColorbarManualSpace',1);
                setappdata(gca,'LegendColorbarReclaimSpace',1);
            end
            title('Nivå 414 T3/T4, ventillägen')
            ylabel('Nivå/Ventillägen [%]')
            xlabel('tid [s]')
            grid on


            x=data.signal(1).data;
            y=[data.signal(88).data,data.signal(103).data*100,data.signal(105).data*100];
            subplot(3,4,7)
            da=findobj(gca,'Type','line');
            if ~isempty(get(da)) && length(y(1,:))==length(da)
                for ii=1:length(y(1,:))
                set(da(ii),'XData',x,'YData',y(:,ii));
                drawnow
                end
            else
                plot(x,y);
            end
            temp=y;
            [ir,ic]=find(temp==max(temp(:)));
            ma=temp(ir(1),ic(1));
            [ir,ic]=find(temp==min(temp(:)));
            mi=temp(ir(1),ic(1));

            axis([x(1),x(end),mi-(mi*0.2)-0.1,ma+(ma*0.2)+0.1]);
            if bt_val==1;
                leg=legend('415T301','415V327','415V329');
                legend(leg,'boxoff')
%                 set(leg,'Location','Best')
%                 set(leg,'FontSize',8)
%                 set(leg,'Interpreter','none')
                set(gca,'LegendColorbarListeners',[]); 
                setappdata(gca,'LegendColorbarManualSpace',1);
                setappdata(gca,'LegendColorbarReclaimSpace',1);
            end
            title('Nivå 415T301, ventillägen')
            ylabel('Nivå/Ventillägen [%]')
            xlabel('tid [s]')
            grid on
            
            x=data.signal(1).data;
            y=[data.signal(89).data,data.signal(104).data*100,data.signal(106).data*100];
            subplot(3,4,8)
            da=findobj(gca,'Type','line');
            if ~isempty(get(da)) && length(y(1,:))==length(da)
                for ii=1:length(y(1,:))
                set(da(ii),'XData',x,'YData',y(:,ii));
                drawnow
                end
            else
                plot(x,y);
            end
            temp=y;
            [ir,ic]=find(temp==max(temp(:)));
            ma=temp(ir(1),ic(1));
            [ir,ic]=find(temp==min(temp(:)));
            mi=temp(ir(1),ic(1));

            axis([x(1),x(end),mi-(mi*0.2)-0.1,ma+(ma*0.2)+0.1]);
            if bt_val==1;
                leg=legend('415T302','415V328','415V330');
                legend(leg,'boxoff')
%                 set(leg,'Location','Best')
%                 set(leg,'FontSize',8)
%                 set(leg,'Interpreter','none')
                set(gca,'LegendColorbarListeners',[]); 
                setappdata(gca,'LegendColorbarManualSpace',1);
                setappdata(gca,'LegendColorbarReclaimSpace',1);
            end
            title('Nivå 415T302, ventillägen')
            ylabel('Nivå/Ventillägen [%]')
            xlabel('tid [s]')
            grid on


            x=data.signal(1).data;
            y=[data.signal(90).data,data.signal(91).data,data.signal(107).data*100,data.signal(108).data*100];
            subplot(3,4,9)
            da=findobj(gca,'Type','line');
            if ~isempty(get(da)) && length(y(1,:))==length(da)
                for ii=1:length(y(1,:))
                set(da(ii),'XData',x,'YData',y(:,ii));
                drawnow
                end
            else
                plot(x,y);
            end
            temp=y;
            [ir,ic]=find(temp==max(temp(:)));
            ma=temp(ir(1),ic(1));
            [ir,ic]=find(temp==min(temp(:)));
            mi=temp(ir(1),ic(1));

            axis([x(1),x(end),mi-(mi*0.2)-0.1,ma+(ma*0.2)+0.1]);
            if bt_val==1;
                leg=legend('415T303','415T304','415V321','415V322');
                legend(leg,'boxoff')
%                 set(leg,'Location','Best')
%                 set(leg,'FontSize',8)
%                 set(leg,'Interpreter','none')
                set(gca,'LegendColorbarListeners',[]); 
                setappdata(gca,'LegendColorbarManualSpace',1);
                setappdata(gca,'LegendColorbarReclaimSpace',1);
            end
            title('Nivå 415 T303/T304, ventillägen')
            ylabel('Nivå/Ventillägen [%]')
            xlabel('tid [s]')
            grid on

            x=data.signal(1).data;
            y=[data.signal(92).data,data.signal(93).data,data.signal(109).data*100,data.signal(110).data*100];
            subplot(3,4,10)
            da=findobj(gca,'Type','line');
            if ~isempty(get(da)) && length(y(1,:))==length(da)
                for ii=1:length(y(1,:))
                set(da(ii),'XData',x,'YData',y(:,ii));
                drawnow
                end
            else
                plot(x,y);
            end
            temp=y;
            [ir,ic]=find(temp==max(temp(:)));
            ma=temp(ir(1),ic(1));
            [ir,ic]=find(temp==min(temp(:)));
            mi=temp(ir(1),ic(1));

            axis([x(1),x(end),mi-(mi*0.2)-0.1,ma+(ma*0.2)+0.1]);
            if bt_val==1;
                leg=legend('418T1','418T2','418V25','418V26');
                legend(leg,'boxoff')
%                 set(leg,'Location','Best')
%                 set(leg,'FontSize',8)
%                 set(leg,'Interpreter','none')
                set(gca,'LegendColorbarListeners',[]); 
                setappdata(gca,'LegendColorbarManualSpace',1);
                setappdata(gca,'LegendColorbarReclaimSpace',1);
            end
            title('Nivå 418 T1/T2, ventillägen')
            ylabel('Nivå/Ventillägen [%]')
            xlabel('tid [s]')
            grid on

            x=data.signal(1).data;
            y=[data.signal(94).data,data.signal(111).data*100,data.signal(113).data*100];
            subplot(3,4,11)
            da=findobj(gca,'Type','line');
            if ~isempty(get(da)) && length(y(1,:))==length(da)
                for ii=1:length(y(1,:))
                set(da(ii),'XData',x,'YData',y(:,ii));
                drawnow
                end
            else
                plot(x,y);
            end
            temp=y;
            [ir,ic]=find(temp==max(temp(:)));
            ma=temp(ir(1),ic(1));
            [ir,ic]=find(temp==min(temp(:)));
            mi=temp(ir(1),ic(1));

            axis([x(1),x(end),mi-(mi*0.2)-0.1,ma+(ma*0.2)+0.1]);
            if bt_val==1;
                leg=legend('418T3','418V33','418V37');
                legend(leg,'boxoff')
%                 set(leg,'Location','Best')
%                 set(leg,'FontSize',8)
%                 set(leg,'Interpreter','none')
                set(gca,'LegendColorbarListeners',[]); 
                setappdata(gca,'LegendColorbarManualSpace',1);
                setappdata(gca,'LegendColorbarReclaimSpace',1);
            end
            title('Nivå 418T3, ventillägen')
            ylabel('Nivå/Ventillägen [%]')
            xlabel('tid [s]')
            grid on

            x=data.signal(1).data;
            y=[data.signal(95).data,data.signal(112).data*100,data.signal(114).data*100];
            subplot(3,4,12)
            da=findobj(gca,'Type','line');
            if ~isempty(get(da)) && length(y(1,:))==length(da)
                for ii=1:length(y(1,:))
                set(da(ii),'XData',x,'YData',y(:,ii));
                drawnow
                end
            else
                plot(x,y);
            end
            temp=y;
            [ir,ic]=find(temp==max(temp(:)));
            ma=temp(ir(1),ic(1));
            [ir,ic]=find(temp==min(temp(:)));
            mi=temp(ir(1),ic(1));

            axis([x(1),x(end),mi-(mi*0.2)-0.1,ma+(ma*0.2)+0.1]);
            if bt_val==1;
                leg=legend('418T4','418V34','418V38');
                legend(leg,'boxoff')
%                 set(leg,'Location','Best')
%                 set(leg,'FontSize',8)
%                 set(leg,'Interpreter','none')
                set(gca,'LegendColorbarListeners',[]); 
                setappdata(gca,'LegendColorbarManualSpace',1);
                setappdata(gca,'LegendColorbarReclaimSpace',1);
            end
            title('Nivå 418T4, ventillägen')
            ylabel('Nivå/Ventillägen [%]')
            xlabel('tid [s]')
            grid on
        case '4'
            x=data.signal(1).data;
            y=[data.signal(115).data];
            scnsize=get(0,'ScreenSize');
            subplot(3,4,1)
            set(gcf,'Position',[scnsize(1),scnsize(2)+scnsize(2)+200,scnsize(3),scnsize(4)-280])
            da=findobj(gca,'Type','line');
            if ~isempty(get(da)) && length(y(1,:))==length(da)
                for ii=1:length(y(1,:))
                set(da(ii),'XData',x,'YData',y(:,ii));
                drawnow
                end
            else
                plot(x,y);
            end
            temp=y;
            [ir,ic]=find(temp==max(temp(:)));
            ma=temp(ir(1),ic(1));
            [ir,ic]=find(temp==min(temp(:)));
            mi=temp(ir(1),ic(1));

            axis([x(1),x(end),mi-(0.05*abs(mi)),ma+(0.05*abs(ma))]);
            if bt_val==1;
                leg=legend('321K301');
                legend(leg,'boxoff')
%                 set(leg,'Location','Best')
%                 set(leg,'FontSize',8)
%                 set(leg,'Interpreter','none')
                set(gca,'LegendColorbarListeners',[]); 
                setappdata(gca,'LegendColorbarManualSpace',1);
                setappdata(gca,'LegendColorbarReclaimSpace',1);
            end
            title('Flöde 321')
            ylabel('Massflöde [kg/s]')
            xlabel('Tid [s]')
            grid on

            x=data.signal(1).data;
            y=[data.signal(116).data,data.signal(117).data,data.signal(118).data,data.signal(119).data];
            subplot(3,4,2)
            da=findobj(gca,'Type','line');
            if ~isempty(get(da)) && length(y(1,:))==length(da)
                for ii=1:length(y(1,:))
                set(da(ii),'XData',x,'YData',y(:,ii));
                drawnow
                end
            else
                plot(x,y);
            end
            temp=y;
            [ir,ic]=find(temp==max(temp(:)));
            ma=temp(ir(1),ic(1));
            [ir,ic]=find(temp==min(temp(:)));
            mi=temp(ir(1),ic(1));

            axis([x(1),x(end),0,100]);
            if bt_val==1;
                leg=legend('323_1','323_2','323_3','323_4');
                legend(leg,'boxoff')
                %                 set(leg,'Location','Best')
                %                 set(leg,'FontSize',8)
                %                 set(leg,'Interpreter','none')
                set(gca,'LegendColorbarListeners',[]);
                setappdata(gca,'LegendColorbarManualSpace',1);
                setappdata(gca,'LegendColorbarReclaimSpace',1);
            end
            title('Flöde 323')
            ylabel('Massflöde [kg/s]')
            xlabel('Tid [s]')
            grid on
            
            x=data.signal(1).data;
            y=[data.signal(120).data,data.signal(121).data,data.signal(122).data,data.signal(123).data];
            subplot(3,4,3)
            da=findobj(gca,'Type','line');
            if ~isempty(get(da)) && length(y(1,:))==length(da)
                for ii=1:length(y(1,:))
                set(da(ii),'XData',x,'YData',y(:,ii));
                drawnow
                end
            else
                plot(x,y);
            end
            temp=y;
            [ir,ic]=find(temp==max(temp(:)));
            ma=temp(ir(1),ic(1));
            [ir,ic]=find(temp==min(temp(:)));
            mi=temp(ir(1),ic(1));

            axis([x(1),x(end),0,30]);
            if bt_val==1;
                leg=legend('327_1','327_2','327_3','327_4');
                legend(leg,'boxoff')
%                 set(leg,'Location','Best')
%                 set(leg,'FontSize',8)
%                 set(leg,'Interpreter','none')
                set(gca,'LegendColorbarListeners',[]); 
                setappdata(gca,'LegendColorbarManualSpace',1);
                setappdata(gca,'LegendColorbarReclaimSpace',1);
            end
            title('Flöde 327')
            ylabel('Massflöde [kg/s]')
            xlabel('Tid [s]')
            grid on
            
            x=data.signal(1).data;
            y=[data.signal(124).data,data.signal(125).data];
            subplot(3,4,4)
            da=findobj(gca,'Type','line');
           if ~isempty(get(da)) && length(y(1,:))==length(da)
                for ii=1:length(y(1,:))
                set(da(ii),'XData',x,'YData',y(:,ii));
                drawnow
                end
            else
                plot(x,y);
            end
            temp=y;
            [ir,ic]=find(temp==max(temp(:)));
            ma=temp(ir(1),ic(1));
            [ir,ic]=find(temp==min(temp(:)));
            mi=temp(ir(1),ic(1));

            axis([x(1),x(end),mi-(abs(mi)*0.05)-0.1,ma+(abs(ma)*0.05)+0.1]);
            if bt_val==1;
                leg=legend('21415HTDP','22415HTDP');
                legend(leg,'boxoff')
%                 set(leg,'Location','Best')
%                 set(leg,'FontSize',8)
%                 set(leg,'Interpreter','none')
                set(gca,'LegendColorbarListeners',[]); 
                setappdata(gca,'LegendColorbarManualSpace',1);
                setappdata(gca,'LegendColorbarReclaimSpace',1);
            end
            title('415HTDP')
            ylabel('Massflöde [kg/s]')
            xlabel('Tid [s]')
            grid on
            
            x=data.signal(1).data;
            y=[data.signal(126).data,data.signal(127).data,data.signal(128).data];
            subplot(3,4,5)
            da=findobj(gca,'Type','line');
            if ~isempty(get(da)) && length(y(1,:))==length(da)
                for ii=1:length(y(1,:))
                set(da(ii),'XData',x,'YData',y(:,ii));
                drawnow
                end
            else
                plot(x,y);
            end
            temp=y;
            [ir,ic]=find(temp==max(temp(:)));
            ma=temp(ir(1),ic(1));
            [ir,ic]=find(temp==min(temp(:)));
            mi=temp(ir(1),ic(1));

            axis([x(1),x(end),mi-(abs(mi)*0.05),ma+(abs(ma)*0.05)]);
            if bt_val==1;
                leg=legend('21415P301','21415P302','21415P303');
                legend(leg,'boxoff')
%                 set(leg,'Location','Best')
%                 set(leg,'FontSize',8)
%                 set(leg,'Interpreter','none')
                set(gca,'LegendColorbarListeners',[]); 
                setappdata(gca,'LegendColorbarManualSpace',1);
                setappdata(gca,'LegendColorbarReclaimSpace',1);
            end
            title('21-415-Pumpar')
            ylabel('Rotationshastighet [rpm]')
            xlabel('Tid [s]')
            grid on
            
            x=data.signal(1).data;
            y=[data.signal(129).data,data.signal(130).data,data.signal(131).data];
            subplot(3,4,6)
            da=findobj(gca,'Type','line');
           if ~isempty(get(da)) && length(y(1,:))==length(da)
                for ii=1:length(y(1,:))
                set(da(ii),'XData',x,'YData',y(:,ii));
                drawnow
                end
            else
                plot(x,y);
            end
            temp=y;
            [ir,ic]=find(temp==max(temp(:)));
            ma=temp(ir(1),ic(1));
            [ir,ic]=find(temp==min(temp(:)));
            mi=temp(ir(1),ic(1));

            axis([x(1),x(end),mi-(abs(mi)*0.05),ma+(abs(ma)*0.05)]);
            if bt_val==1;
                leg=legend('22415P301','22415P302','22415P303');
                legend(leg,'boxoff')
%                 set(leg,'Location','Best')
%                 set(leg,'FontSize',8)
%                 set(leg,'Interpreter','none')
                set(gca,'LegendColorbarListeners',[]); 
                setappdata(gca,'LegendColorbarManualSpace',1);
                setappdata(gca,'LegendColorbarReclaimSpace',1);
            end
            title('22-415-Pumpar')
            ylabel('Rotationshastighet [rpm]')
            xlabel('Tid [s]')
            grid on
            
            x=data.signal(1).data;
            y=[data.signal(132).data,data.signal(133).data,data.signal(134).data];
            subplot(3,4,7)
            da=findobj(gca,'Type','line');
           if ~isempty(get(da)) && length(y(1,:))==length(da)
                for ii=1:length(y(1,:))
                set(da(ii),'XData',x,'YData',y(:,ii));
                drawnow
                end
            else
                plot(x,y);
            end
            temp=y;
            [ir,ic]=find(temp==max(temp(:)));
            ma=temp(ir(1),ic(1));
            [ir,ic]=find(temp==min(temp(:)));
            mi=temp(ir(1),ic(1));

            axis([x(1),x(end),mi-(abs(mi)*0.05),ma+(abs(ma)*0.05)]);
            if bt_val==1;
                leg=legend('21414P1','21414P2','21414P3');
                legend(leg,'boxoff')
%                 set(leg,'Location','Best')
%                 set(leg,'FontSize',8)
%                 set(leg,'Interpreter','none')
                set(gca,'LegendColorbarListeners',[]); 
                setappdata(gca,'LegendColorbarManualSpace',1);
                setappdata(gca,'LegendColorbarReclaimSpace',1);
            end
            title('21-414-Kondensatpumpar')
            ylabel('Hastighet [%]')
            xlabel('Tid [s]')
            grid on
            
            x=data.signal(1).data;
            y=[data.signal(137).data,data.signal(138).data,data.signal(139).data];
            subplot(3,4,8)
            da=findobj(gca,'Type','line');
            if ~isempty(get(da)) && length(y(1,:))==length(da)
                for ii=1:length(y(1,:))
                set(da(ii),'XData',x,'YData',y(:,ii));
                drawnow
                end
            else
                plot(x,y);
            end
            temp=y;
            [ir,ic]=find(temp==max(temp(:)));
            ma=temp(ir(1),ic(1));
            [ir,ic]=find(temp==min(temp(:)));
            mi=temp(ir(1),ic(1));

            axis([x(1),x(end),mi-(abs(mi)*0.05),ma+(abs(ma)*0.05)]);
            if bt_val==1;
                leg=legend('22414P1','22414P2','22414P3');
                legend(leg,'boxoff')
%                 set(leg,'Location','Best')
%                 set(leg,'FontSize',8)
%                 set(leg,'Interpreter','none')
                set(gca,'LegendColorbarListeners',[]); 
                setappdata(gca,'LegendColorbarManualSpace',1);
                setappdata(gca,'LegendColorbarReclaimSpace',1);
            end
            title('22-414-Kondensatpumpar')
            ylabel('Hastighet [%]')
            xlabel('Tid [s]')
            grid on
            
            x=data.signal(1).data;
            y=[data.signal(135).data,data.signal(136).data];
            subplot(3,4,9)
            da=findobj(gca,'Type','line');
            if ~isempty(get(da)) && length(y(1,:))==length(da)
                for ii=1:length(y(1,:))
                set(da(ii),'XData',x,'YData',y(:,ii));
                drawnow
                end
            else
                plot(x,y);
            end
            temp=y;
            [ir,ic]=find(temp==max(temp(:)));
            ma=temp(ir(1),ic(1));
            [ir,ic]=find(temp==min(temp(:)));
            mi=temp(ir(1),ic(1));

            axis([x(1),x(end),mi-(abs(mi)*0.05)-0.1,ma+(abs(ma)*0.05)+0.1]);
            if bt_val==1;
                leg=legend('21414P5','21414P6');
                legend(leg,'boxoff')
%                 set(leg,'Location','Best')
%                 set(leg,'FontSize',8)
%                 set(leg,'Interpreter','none')
                set(gca,'LegendColorbarListeners',[]); 
                setappdata(gca,'LegendColorbarManualSpace',1);
                setappdata(gca,'LegendColorbarReclaimSpace',1);
            end
            title('21-414-Dränagepumpar')
            ylabel('Hastighet [%]')
            xlabel('Tid [s]')
            grid on
            
            x=data.signal(1).data;
            y=[data.signal(160).data*100,data.signal(161).data*100];
            subplot(3,4,10)
            da=findobj(gca,'Type','line');
           if ~isempty(get(da)) && length(y(1,:))==length(da)
                for ii=1:length(y(1,:))
                set(da(ii),'XData',x,'YData',y(:,ii));
                drawnow
                end
            else
                plot(x,y);
            end
            temp=y;
            [ir,ic]=find(temp==max(temp(:)));
            ma=temp(ir(1),ic(1));
            [ir,ic]=find(temp==min(temp(:)));
            mi=temp(ir(1),ic(1));

            axis([x(1),x(end),mi-(abs(mi)*0.05)-0.1,ma+(abs(ma)*0.05)+0.1]);
            %axis([x(1),x(end),mi-(abs(mi)*0.05),ma+(abs(ma)*0.05)]);
            if bt_val==1;
                leg=legend('Deriverad BÅTT T21','Deriverad BÅTT T22');
                legend(leg,'boxoff')
%                 set(leg,'Location','Best')
%                 set(leg,'FontSize',8)
%                 set(leg,'Interpreter','none')
                set(gca,'LegendColorbarListeners',[]); 
                setappdata(gca,'LegendColorbarManualSpace',1);
                setappdata(gca,'LegendColorbarReclaimSpace',1);
            end
            title('Derivata av filtrerad BÅTT')
            ylabel('Deriverad BÅTT [%/min]')
            xlabel('Tid [s]')
            grid on
            
            x=data.signal(1).data;
            y=[data.signal(142).data,data.signal(143).data];
            subplot(3,4,11)
            da=findobj(gca,'Type','line');
            if ~isempty(get(da)) && length(y(1,:))==length(da)
                for ii=1:length(y(1,:))
                set(da(ii),'XData',x,'YData',y(:,ii));
                drawnow
                end
            else
                plot(x,y);
            end
            temp=y;
            [ir,ic]=find(temp==max(temp(:)));
            ma=temp(ir(1),ic(1));
            [ir,ic]=find(temp==min(temp(:)));
            mi=temp(ir(1),ic(1));

            axis([x(1),x(end),mi-(abs(mi)*0.05)-0.1,ma+(abs(ma)*0.05)+0.1]);
            if bt_val==1;
                leg=legend('21411V509','21411V511');
                legend(leg,'boxoff')
%                 set(leg,'Location','Best')
%                 set(leg,'FontSize',8)
%                 set(leg,'Interpreter','none')
                set(gca,'LegendColorbarListeners',[]); 
                setappdata(gca,'LegendColorbarManualSpace',1);
                setappdata(gca,'LegendColorbarReclaimSpace',1);
            end
            title('Dumpflöde genom dumpventiler, T21')
            ylabel('Massflöde [kg/s]')
            xlabel('Tid [s]')
            grid on
            
            x=data.signal(1).data;
            y=[data.signal(144).data,data.signal(145).data];
            subplot(3,4,12)
            da=findobj(gca,'Type','line');
            if ~isempty(get(da)) && length(y(1,:))==length(da)
                for ii=1:length(y(1,:))
                set(da(ii),'XData',x,'YData',y(:,ii));
                drawnow
                end
            else
                plot(x,y);
            end
            temp=y;
            [ir,ic]=find(temp==max(temp(:)));
            ma=temp(ir(1),ic(1));
            [ir,ic]=find(temp==min(temp(:)));
            mi=temp(ir(1),ic(1));

            axis([x(1),x(end),mi-(abs(mi)*0.05)-0.1,ma+(abs(ma)*0.05)+0.1]);
            if bt_val==1;
                leg=legend('22411V509','22411V511');
                legend(leg,'boxoff')
%                 set(leg,'Location','Best')
%                 set(leg,'FontSize',8)
%                 set(leg,'Interpreter','none')
                set(gca,'LegendColorbarListeners',[]); 
                setappdata(gca,'LegendColorbarManualSpace',1);
                setappdata(gca,'LegendColorbarReclaimSpace',1);
            end
            title('Dumpflöde genom dumpventiler, T22')
            ylabel('Massflöde [kg/s]')
            xlabel('Tid [s]')
            grid on
    end % End switch case
    t=str2num(get(handles.interv,'String'));
    pause(t)

    clear M
end

set(handles.stop,'Enable','off')
set(handles.close,'Enable','on')
set(handles.Update,'Enable','on')
set(handles.avsluta,'Enable','on')

guidata(hObject, handles);
% --- Executes on button press in close.
function close_Callback(hObject, eventdata, handles)
% hObject    handle to close (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

close all

% --- Executes on button press in get_file.
function get_file_Callback(hObject, eventdata, handles)
% hObject    handle to get_file (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

[filename, pathname] = uigetfile( ...
{'*.dat','APROS filer (*.dat)'}, ...
   'Välj filer','MultiSelect', 'on');

[m,n]=size(filename(1,:));
if n==2
    k = strcmp('F2_3.dat', filename(1));
    if k==1
        APR_files=[filename(1);filename(2)];
    else
        APR_files=[filename(2);filename(1)];
    end
    tmp1=[pathname,char(APR_files(1))];
    tmp2=[pathname,char(APR_files(2))];

    handles.APR_pathfile=strvcat(tmp1,tmp2);
else
    handles.APR_pathfile=[pathname,filename];
end

set(handles.close,'Enable','on');
set(handles.Update,'Enable','on');
set(handles.psetup,'Enable','on');
guidata(hObject, handles);

% --- Executes on button press in stop.
function stop_Callback(hObject, eventdata, handles)
% hObject    handle to stop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

set(handles.stop,'Enable','off')

% --- Executes on button press in avsluta.
function avsluta_Callback(hObject, eventdata, handles)
% hObject    handle to avsluta (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

close all
close(APROS_plot)



function interv_Callback(hObject, eventdata, handles)
% hObject    handle to interv (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of interv as text
%        str2double(get(hObject,'String')) returns contents of interv as a double


% --- Executes during object creation, after setting all properties.
function interv_CreateFcn(hObject, eventdata, handles)
% hObject    handle to interv (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on slider movement.
function slider_Callback(hObject, eventdata, handles)
% hObject    handle to slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function slider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on button press in psetup.
function psetup_Callback(hObject, eventdata, handles)
% hObject    handle to psetup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

set(handles.stop,'Enable','off')
APR_pathfile=handles.APR_pathfile;
fid=fopen(APR_pathfile);
num_var=str2num(fgetl(fid));
signaler='';
for i=1:num_var
    signaler = strvcat(signaler,fgetl(fid));
end
fclose(fid);
M = dlmread(APR_pathfile,'%f',num_var+1,0);
% Store filinfo
data.type = 'APROS';
data.file = APR_pathfile;
data.nvar = size(signaler,1);

% Store signal data
for i=1:data.nvar
    data.signal(i).label = signaler(i,:);
    data.signal(i).unit = '';
    data.signal(i).lowlimit = '';
    data.signal(i).highlimit = '';
    data.signal(i).gain = '';
    data.signal(i).desc = '';
end

APROS_siglist(data.signal.label);


% --- Executes on button press in b_text.
function b_text_Callback(hObject, eventdata, handles)
% hObject    handle to b_text (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of b_text


% --- Executes on button press in dd120_check.
function dd120_check_Callback(hObject, eventdata, handles)
% hObject    handle to dd120_check (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of dd120_check


