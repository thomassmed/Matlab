function PlotS3k(filename)  
% PlotS3k - Plot data from cms-files 
%
% Inputs 
%   filename - Name on cmsfile (*.cms)
%      
% Examples 
%   PlotS3k 
%   PlotS3k sk3.cms 
%   filename='sk3.cms'; PlotS3k(filename)       
% 
% See also AppendixPlot, cmsplot, cms_read, read_cms 

%TODO: Fix absolute path in the case of linux style on PC

if nargin==0, %If no input argument, get cms file
    [filename,pathname]=uigetfile('*.cms','select a cmsfile');
    if filename==0, return;end %Cancel if no file is given
    filename=[pathname,filename];
else
    filename=expandpath(filename);
end

% Read data from file
[cmsinfo,data] = read_cms(filename);
        

filters=cmsinfo.filters;

%% open a new figure
hmainFig=figure('units','Normalized','position',[0.37,0.1,0.6,0.8],'menubar','none','name',filename);
if iscell(filters.Mask), filters.Mask=filters.Mask{1};end
nlab=max(filters.Mask);      %How many groups on file? 

h(1,1)=uimenu(hmainFig,'label','File');                             %Window labels      
h(1,2)=uimenu(h(1,1),'label','Open','callback','get_cmsfile');      %Callback for opening a new file 

h(2,1)=uimenu(hmainFig,'label','Selection');                        %New label selection
h=init_cmsfile(h,hmainFig,filters,nlab);                             %Sort by group 
 
h(3,1)=uimenu(hmainFig,'label','Export');                           %New label export
h(3,2)=uimenu(h(3,1),'label','To ASCII','callback',@Export2ASCII);  %Choose where 2 export
h(3,3)=uimenu(h(3,1),'label','To EXCEL','callback',@Export2Excel);
h(3,4)=uimenu(h(3,1),'label','Whole File to EXCEL','callback',@ExportAll2Excel);    %Export whole file

h(4,1)=uimenu(hmainFig,'label','Specials');     %New label specials
h(4,2)=uimenu(h(4,1),'label','Statitics','callback',@StatMaxMin); %Undergroup statitics

hax=axes('position',[0.25 0.05 0.73 0.87]);     %Axes handle 

s3kplot_prop.hax=hax;                           %Store handle in s3kplot_prop
s3kplot_prop.h=h;                               
s3kplot_prop.data=data;                         %Selected info data
s3kplot_prop.Names=cmsinfo.ScalarNames;         %Selected info names
s3kplot_prop.filters=filters;                   %Selected info filters
s3kplot_prop.filename=filename;                 %Selected info filename
set(hmainFig,'userdata',s3kplot_prop);          %Store properties in figure userdata  
get_selection(1);                               %Plot from data
