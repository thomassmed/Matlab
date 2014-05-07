function set_cmsplot_prop(prop,value)
% set_cmsplot_prop - sets a property for cmsplot
%
% set_cmsplot_prop(prop,value)
%
% Input 
%   prop  - property of cmsplot_prop 
%   value - value for selected property, can be a string, a number, a
%           vector or a full 3D-distribution depending on application
%
%
%  Output 
%   No outputs, the properties are just used to manipulate the current
%   cmsplot-figure
%
% The function is normally used for callbacks from cmsplot,  but it is perfectly 
% alright to use it from the command window or in a function or a script.
% If you only use cmsplot in graphic mode, you should probably stop reading
% now and don't worry. But if you are interested in how it works, keep on
% reading.
%
% Note for hacker-oriented users: what set_cmsplot_prop does is simply to manipute cmsplot_prop,
% which is stored in the property 'userdata' in the figure of a cmsplot. Thus, 
% set_cmsplot_prop('operator','mean');
%
% is equivalent to:
%
% cmsplot_prop=get(gcf,'userdata'); % Pick up the structured variable that
%                                   % contain all properties for the figure
% cmsplot_prop.operator='mean';     % Manipulate it
% set(gcf,'userdata;,cmsplot_prop); % Put it back to the figure so
%                                   % cmsplot_now knows what to do when it's invoked
%
% If you are hacker oriented, you've probably already figure out that there is nothing magic 
% (except that it explains what's going on) with the name cmsplot_prop. The following line does the same job:
%
%  x=get(gcf,'userdata');x.operator='mean';set(gcf,'userdata',x);
%
% Now this only sets the properties. To invoke a new plotting, you have to type 
% cmsplot_now 
% in the command window or press the plot button in the cmsplot-window
% Also, if you're working on a pc, you may actually have to type 
% figure(gcf)
% to actually see what happened
%
% Example:
% 
%   set_cmsplot_prop('rescale','auto');  % Ensures that next time cmsplot_now is invoked, 
%                                        % an automatic scaling will be performed
%   set_cmsplot_prop('scale_min',0.1);   % Sets scalemin to 0.1 Note that this will not really 
%                                        % be used unless we also make sure that rescaling
%                                        % will be performed by doing:
%   set_cmsplot_prop('rescale','yes');
%   set_cmsplot_prop('data',variable);cmsplot_now;   % Will do the same job as  
%   plot_matvar(variable);
%   set_cmsplot_prop  % displays the content of cmsplot_prop
%    
% See also:
% cmsplot, plot_matvar
%

%
% If you have endured this far, you are indeed a hacker and then you know
% that there may be features that are implemented, but not documented.
% To get a clue on what they might be, just pick up a cmsplot_prop by
% invoking a cmsplot and then pick up the the cmsplot_prop that is stored
% in the userdata:
% cmsplot s3.res
% get(gcf,'userdata')
% To understand what these features might be used for, check in cmsplot_now

% Now, with all this helptext, it's almost embarrasing to present the code:
hfig=gcf;   % It;s a good practice to always store gcf in a variable so that whatever happens,
            % we have some control

cmsplot_prop=get(hfig,'userdata'); % Get the properties of current figure

if nargin==0,
    cmsplot_prop
    return
end


if ~isstruct(cmsplot_prop)         % Current figure may not be cmsplot figure. If so, print error message and abort
    error('Check that current figure is a cmsplot-figure. Click on it to make it current.');
    return
end

evalstr=['cmsplot_prop.',prop,'=value;'];   % Prepare to manipulate the properties         
eval(evalstr);                              % Perform the manipulation
set(hfig,'userdata',cmsplot_prop);          % put it back to the userdata so cmsplot_now can find it
