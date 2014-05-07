%CMSPLOT plots cms-generated core data
%
% function hfig=cmsplot(filename,matvar);
%
% Input:
%   filename - name on base file, *.res, *.out, *.sum, *.mat (default .res)
%   matvar   - matlab variable
%
% Output:
%   hfig     - handle to figure
%
% Example: 
%   cmsplot
%   cmsplot('s3-1.res')
%   cmsplot s3-1.res
%   [fue_new,Oper]=read_restart_bin('s3-1.res');cmsplot s3-1.res fue_new.vhist
%   pow=reads3_out('s3-1.out','3RPF');cmsplot s3-1.out pow
%   pow=reads3_out('s3-1.out','3RPF');cmsplot('s3-1.out',pow)
%
% See also compare2, set_cmsplot_prop
function varargout=cmsplot(filename,matvar,varargin)

if nargin==0
    [filename,pathname]=uigetfile({'*.res;*.mat;*.hms;*.h5;*.hdf5;*.out;*.sum;*.dat;*.cms;*.RESTART','CMS-files (*.cms,*.res,*.RESTART,*.mat,*.hms,*.h5,*hdf5,*.out,*.sum,*.dat)';...
        '*.cms','cms-files (*.cms)';...
        '*.res','Restart-files (*.res,*.RESTART)';...
        '*.out','Output-files (*.out)';...
        '*.sum','Output-files (*.sum)';...
        '*.mat','Files saved by Matstab (*.mat)';...
        '*.hms','Hermes-files (*.hms)';...
        '*.h5;*.hdf5','Database Files (*.h5, *.hdf5)';...
        '*.dat','Polca Distribution files (*.dat)';...
        '*.*', 'All files (*.*)'},...
        'Pick a file');
    if filename==0, return, end
    filename=[pathname,filename];
    filename=file('normalize',filename);
else
    [pathname,filename,ext]=fileparts(filename);
    if ~isempty(pathname)
        pathname=[pathname,filesep];
    end
    if isempty(ext), ext='.cms'; end
    filename=[pathname,filename,ext];
    filename=expandpath(filename);
end


EXT = identfile(filename);
EXT=['.',EXT];
cmsplot_prop.filename=filename;
cmsplot_prop.filetype=EXT;

if nargin<2,
    switch EXT
        case '.res'
            cmsplot_prop.dist_name='Power';
        case '.mat'
            cmsplot_prop.dist_name='evoid';
        case '.out'
            cmsplot_prop.dist_name='3RPF';
        case '.hms'
            cmsplot_prop.dist_name='3RPF';
        case '.cms'
            cmsplot_prop.dist_name='3RPF - Relative Power Fraction';
        case '.dat'
            cmsplot_prop.dist_name='Power';
    end
    cmsplot_prop.matvar_string={''};
    cmsplot_prop.matvar_plot=0;
else
    cmsplot_prop.matvar_plot=1;
    if ~ischar(matvar),
        cmsplot_prop.dist_name=inputname(2);
        cmsplot_prop.matvar_string{1}=inputname(2);
    else
        cmsplot_prop.dist_name=matvar;
        cmsplot_prop.matvar_string{1}=matvar;
    end
end

scrsz = get(0,'ScreenSize');
switch cmsplot_prop.filetype
    case {'.h5','.hdf5'}
        posi=[.466*scrsz(3) scrsz(4)*.45 scrsz(3)*.528 scrsz(4)*.5];
        hfig = figure('Position',posi, 'color',[0.8 0.8 0.8], 'CloseRequestFcn', @closeCmsPlotWindow);
    otherwise
        [NW,NE,SW,SE]=get_scrpos;
        posi=NE;
        if nargin>2,
            switch upper(varargin{1})
                case 'NW'
                    posi=NW;
                case 'NE'
                    posi=NE;                    
                case 'SW'
                    posi=SW;
                case 'SE'
                    posi=SE;                    
            end
        end
        hfig = figure('Position',posi, 'color',[0.8 0.8 0.8], 'CloseRequestFcn', @closeCmsPlotWindow);
end
set(hfig,'inverthardcopy','off');
set(hfig,'menubar','none');

h=zeros(10,20);


h(1,1)=uimenu('label','File');
h(1,2)=uimenu(h(1,1),'label','Open','callback','get_cmsplotfile;');
h(1,3)=uimenu(h(1,1),'label','Save Image','callback','[FileName,PathName] = uiputfile({''*.jpg;*.tif;*.png;*.gif'',''All Image Files'';''*.*'',''All Files'' },''Save Image'',''submeshplot.jpg''); saveas(gcf,[PathName FileName]); ');



h(2,1)=uimenu('label','Data');

h(3,1)=uimenu('label','Option');
h(3,10)=uimenu(h(3,1),'label','Refresh','callback','cmsplot_now;');
h(3,2)=uimenu(h(3,1),'label','max','callback','set_cmsplot_prop operator max; set_cmsplot_prop rescale auto;cmsplot_now');
h(3,3)=uimenu(h(3,1),'label','average','callback','set_cmsplot_prop operator mean; set_cmsplot_prop rescale auto ;cmsplot_now');
h(3,4)=uimenu(h(3,1),'label','min','callback','set_cmsplot_prop operator min; set_cmsplot_prop rescale auto;cmsplot_now');
h(3,5)=uimenu(h(3,1),'label','minmax','callback','set_cmsplot_prop operator minmax; set_cmsplot_prop rescale auto;cmsplot_now');
h(3,9)=uimenu(h(3,1),'label','axial offset','callback','set_cmsplot_prop operator aocalc; set_cmsplot_prop rescale auto;cmsplot_now');
h(3,16)=uimenu(h(3,1),'label','Nodplane','callback','set_node_plane;');
h(3,6)=uimenu(h(3,1),'label','scale max','callback','cms_setscale max;');
h(3,7)=uimenu(h(3,1),'label','scale min','callback','cms_setscale min;');
h(3,8)=uimenu(h(3,1),'label','autoscale','callback','set_cmsplot_prop rescale auto;cmsplot_now');
h(3,15)=uimenu(h(3,1),'label','auto on all state point','callback','set_cmsplot_prop rescale all;cmsplot_now');
% h(3,12)=uimenu(h(3,1),'label','Colormap');
% h(3,13)=uimenu(h(3,12),'label','White above scale','callback','set_colormap jett;cmsplot_now;');
% h(3,14)=uimenu(h(3,12),'label','Dark above scale','callback','set_colormap jet_mod;cmsplot_now;');

h(4,1)=uimenu('label','Filter');
%h(4,2)=uimenu(h(4,1),'label','show cr-modules','callback','set_filter(''crods'');');
h(4,3)=uimenu(h(4,1),'label','show nhyd','callback','set_filter(''nhyd'')','enable','off');
h(4,4)=uimenu(h(4,1),'label','show nfta','callback','set_filter(''nfta'')','enable','off');
h(4,5)=uimenu(h(4,1),'label','show bat','callback','set_filter(''bat'')');
h(4,6)=uimenu(h(4,1),'label','MATLAB-vector','callback','set_filt_matvar;');
h(4,7)=uimenu(h(4,1),'label','remove filter','callback','remove_filter');

h(5,1)=uimenu('label','Layout');
h(5,2)=uimenu(h(5,1),'label','fullcore','callback','set_cmsplot_prop(''plotsym'',''FULL'');cmsplot_now;');
h(5,3)=uimenu(h(5,1),'label','halfcore');
h(5,31)=uimenu(h(5,3),'label','E','callback','set_cmsplot_prop(''plotsym'',''E'');cmsplot_now;');
h(5,32)=uimenu(h(5,3),'label','W','callback','set_cmsplot_prop(''plotsym'',''W'');cmsplot_now;');
h(5,33)=uimenu(h(5,3),'label','N','callback','set_cmsplot_prop(''plotsym'',''N'');cmsplot_now;');
h(5,34)=uimenu(h(5,3),'label','S','callback','set_cmsplot_prop(''plotsym'',''S'');cmsplot_now;');
h(5,4)=uimenu(h(5,1),'label','quartercore');
h(5,41)=uimenu(h(5,4),'label','SE','callback','set_cmsplot_prop(''plotsym'',''SE'');cmsplot_now;');
h(5,42)=uimenu(h(5,4),'label','NE','callback','set_cmsplot_prop(''plotsym'',''NE'');cmsplot_now;');
h(5,43)=uimenu(h(5,4),'label','NW','callback','set_cmsplot_prop(''plotsym'',''NW'');cmsplot_now;');
h(5,44)=uimenu(h(5,4),'label','SW','callback','set_cmsplot_prop(''plotsym'',''SW'');cmsplot_now;');
h(5,2)=uimenu(h(5,1),'label','Show controlrods','callback','set_cmsplot_prop(''crods'',''black'');cmsplot_now');
h(5,3)=uimenu(h(5,1),'label','Hide controlrods','callback','set_cmsplot_prop(''crods'',''no'');cmsplot_now;');

h(5,7)=uimenu(h(5,1),'label','zoom','callback','cms_zoom');
% h(5,8)=uimenu(h(5,1),'label','flow pos');
h(5,9)=uimenu(h(5,1),'label','Detectors');
h(5,10)=uimenu(h(5,9),'label','On','callback','set_cmsplot_prop(''detectors'',''black'');cmsplot_now;');
h(5,11)=uimenu(h(5,9),'label','Off','callback','set_cmsplot_prop(''detectors'',''off'');cmsplot_now;');
h(5,12)=uimenu(h(5,9),'label','numbers','callback','set_cmsplot_prop(''detectors'',''numbers'');cmsplot_now;');
h(5,13)=uimenu(h(5,1),'label','brighten','callback','brighten(.5)');
h(5,14)=uimenu(h(5,1),'label','darken','callback','brighten(-.5)');
h(5,15)=uimenu(h(5,1),'label','flip scale','callback','cms_flipscale');
% h(5,16)=uimenu(h(5,1),'label','buntyp','callback','buntext');
h(5,17)=uimenu(h(5,1),'label','Axis labels');
h(5,18)=uimenu(h(5,17),'label','ij','callback','set_cmsplot_prop coordinates ij;cmsplot_now');
h(5,19)=uimenu(h(5,1),'label','Show Values');
h(3,20)=uimenu(h(5,19),'label','None','callback','set_cmsplot_prop datalabels no;cmsplot_now');
h(3,21)=uimenu(h(5,19),'label','Value','callback','set_cmsplot_prop datalabels value;cmsplot_now');
h(3,22)=uimenu(h(5,19),'label','nft','callback','set_cmsplot_prop datalabels nft;cmsplot_now');
h(3,23)=uimenu(h(5,19),'label','nhyd','callback','set_cmsplot_prop datalabels nhyd;cmsplot_now');
h(3,24)=uimenu(h(5,19),'label','ibat','callback','set_cmsplot_prop datalabels ibat;cmsplot_now');
h(3,25)=uimenu(h(5,19),'label','knum','callback','set_cmsplot_prop datalabels knum;cmsplot_now');
h(3,26)=uimenu(h(5,19),'label','knum2x2','callback','set_cmsplot_prop datalabels knum2x2;cmsplot_now');
h(3,27)=uimenu(h(5,19),'label','Labels','callback','set_cmsplot_prop datalabels label;cmsplot_now');

h(6,1)=uimenu('label','Special Functions');
h(6,10)=uimenu(h(6,1),'label','Operating data','callback','disp_state_point');
h(6,2)=uimenu(h(6,1),'label','Axplot','callback','set_cmsplot_prop(''axplot'',''new'');cmsplot_now;');
h(6,11)=uimenu(h(6,1),'label','Compare2','callback','Compare2GUI');
h(6,3)=uimenu(h(6,1),'label','Ind. Chan','callback','ind_chan');
h(6,4)=uimenu(h(6,1),'label','SC-plot','callback','supcelplot');
h(6,5)=uimenu(h(6,1),'label','Info');
h(6,6)=uimenu(h(6,5),'label','Neutronic','callback','neu_info;');
h(6,7)=uimenu(h(6,5),'label','Mechanical','callback','th_info;');
h(6,8)=uimenu(h(6,5),'label','Water Rod','callback','wr_info;');

% h(6,10) is occupied in cmsplot_init
h(6,12)=uimenu(h(6,1),'label','surf');
h(6,13)=uimenu(h(6,12),'label','surf staples','callback','DJsPlot(1)');
h(6,14)=uimenu(h(6,12),'label','surf smooth','callback','DJsPlot(2)');

h(10,1)=uimenu('label','Export Data','callback','SavedataGUI(1);');


h=cmsplot_window(cmsplot_prop.filetype,h,'keep');
cmsplot_prop.handles=h;


cmsplot_prop=init_cmsplot_prop(cmsplot_prop);
cmsplot_prop.case_handles=[];
cmsplot_prop.data_handles=[];

set(hfig,'userdata',cmsplot_prop);

if (strcmp(cmsplot_prop.filetype, '.h5') || strcmp(cmsplot_prop.filetype, '.hdf5'))
    h5filetree(filename);
end

cmsplot_init;
cmsplot_now;

if nargout>0,
    varargout{1}=hfig;
end
end

function closeCmsPlotWindow(src, EventData)
    if ishandle(src) % if cmsplot window has somehow been closed, this is needed to close axplot windows
        cmsplot_prop=get(src,'userdata');
        if isempty(cmsplot_prop), delete(src); return;end
        if (cmsplot_prop.axplot >= 0), delete(cmsplot_prop.axplot); end
    end
    delete(src);
end
