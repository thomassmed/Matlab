function [filenames,figs,ListName]=AppendixPlot(SearchPattern,Str2Find,varargin) 
% AppendixPlot - Create report plots from cms-files 
% 
% FileNames = AppendixPlot(SearchPattern,Str2Find) 
% AppendixPlot(FileNames,Str2Find) 
% 
% Inputs 
%   SearchPattern - Search pattern for file names 
%   FileNames - Cellarray of file names (alternative input)  
%   Str2Find - Cellarray of categorie names 
%
% Outputs 
%   FileNames - Cellarray of files used   
%
% Options for figure 
%   x,y label 
%   legend, title and text options 
%
% Examples 
%   filenames = AppendixPlot('0000*.cms','Core Averaged LPRM') 
%   fnames{1}='1000-7600-2trip.cms'; 
%   fnames{2}='2000-7600-2trip.cms'; 
%   Str2Find{1}='Core Averaged LPRM'; 
%   Str2Find{2}='Relative Power'; 
%   AppendixPlot(fnames,Str2Find)    
%
% See also s3kplot cmsplot  

%% get the files of interest
if nargin==0,
    [filenames,PathName]=uigetfile('*.cms','*.cms files','MultiSelect','on');
    if ~iscell(filenames),
        if filenames==0;return;end
    end
    filenames=cellstr(filenames);
    fullfilenames=filenames;
    for i=1:length(filenames),
        fullfilenames{i}=fullfile(PathName,filenames{i});
    end
elseif iscell(SearchPattern), 
    filenames=SearchPattern;  %Make
    fullfilenames=filenames;
else
    files=dir(SearchPattern);
    filenames=cell(length(files),1);
    for i=1:length(files),
        filenames{i}=files(i).name;
    end
    fullfilenames=filenames;
end
if nargin<2,
    get_listname(fullfilenames);
    figs=[];ListName=[];
    return
end

%% Sort categories
%Str2Find='Core Averaged LPRM';       %Names of main category

if ~exist('ListName','var'),
    if ischar(Str2Find) 
    Str2Find=cellstr(Str2Find); 
    end
    for i=1:length(filenames),
        [cmsinfo,core_data] = read_cms(fullfilenames{i});
        Names=cmsinfo.ScalarNames;
        icount(i)=0;
        t{i}=core_data(1,:);
        for j=1:length(Str2Find)
            ifind=strmatch(Str2Find(j),Names);
            for j=1:length(ifind),
                ListName{icount(i)+j}=Names{ifind(j)};
                plotdata{i,icount(i)+j}=core_data(ifind(j),:);
            end
            icount(i)=icount(i)+length(ifind);
        end
    end
end

if ~exist('ListName','var'), 
    error(['Variable not found: ',Str2Find{1}]);
end

for j=1:length(ListName)
    %% Plot
    figs(j)=figure;
    hold all
    for i=1:length(filenames),
        plot(t{i},plotdata{i,j})
    end
    %% Fix Plot
    grid on
    xlabel(cmsinfo.ScalarNames{1});
    ylabel(ListName{j})
    for i=1:length(filenames),filenames{i}=file('tail',filenames{i});end
    legend(filenames,'location','Best');
    h=title(ListName{j});
    set(h,'FontSize',12,'FontWeight','Bold')
    figure(gcf)
end 