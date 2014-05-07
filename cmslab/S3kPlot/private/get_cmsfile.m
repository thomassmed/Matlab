%Create function for s3kplot 2 work (callback from s3kplot figure)
function get_cmsfile                    %Maingoal with operation
hmainFig=gcf;                           %Get figure handle
s3kplot_prop=get(hmainFig,'userdata');  %Get properties for choosen file
h=s3kplot_prop.h;                       %Get handle for uimenu's
[filename,pathname]=uigetfile('*.cms','select a cmsfile'); %Get the new file by userinput
if filename==0, return;end

filename=[pathname,filename]; set(hmainFig,'name',filename);        %Get full filename and display it

%Read data from file
[cmsinfo,data] = read_cms(filename);
filters=cmsinfo.filters;

if iscell(filters.Mask), filters.Mask=filters.Mask{1};end
nlab=max(filters.Mask);                      %Stop point
hc=get(h(2,1),'children');                      %Get selection handle
delete(hc);                                     %Delete old selection object
h=init_cmsfile(h,hmainFig,filters,nlab);         %Set up new selection object

s3kplot_prop.h=h;                      %Store properties in figure userdata
s3kplot_prop.data=data;
s3kplot_prop.Names=cmsinfo.ScalarNames;
s3kplot_prop.filters=filters;
s3kplot_prop.filename=filename;
set(hmainFig,'userdata',s3kplot_prop);

get_selection(1);       %Use corevalues as default selection