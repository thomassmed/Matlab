function get_positions_for_submeshplot
% get_positions_for_submeshplot is used by plot_sub_mesh to get an area of
% the core that will be plotted with submesh
%
% See also plot_sub_mesh PlotSubMeshData get_submesh_data

% Mikael Andersson 2012-01-03
%% find assembly handel and "parent" handle of cmsplot and set some iteration parameters
submeshfig = gcf;
submeshplot_prop=get(submeshfig,'userdata');
hfig = submeshplot_prop.hcmsplot;
coreinfo = submeshplot_prop.coreinfo;
figure(hfig);
contin = 1;
point = 1;
nx = zeros(1,2);
ny = zeros(1,2);
cmsplot_prop=get(submeshplot_prop.hcmsplot,'userdata');
if max(strcmp(fieldnames(cmsplot_prop),'corecross')) && (~isempty(max(cmsplot_prop.corecross(1) == findall(0,'type','rectangle'))) || (max(cmsplot_prop.corecross(1) == findall(0,'type','line'))) ~= 0)
    delete(cmsplot_prop.corecross);
end
corecross = zeros(2);
%% start the loop where the points are choosen
while contin == 1
    % get new assembly
    figure(hfig);
    [xx,yy,button]=ginput(1);
    switch button
        case 1 
            nx(point)=fix(xx);
            ny(point)=fix(yy);
                  
        otherwise
            contin = 0;
            if length(nx) == 3
                nx(3) = [];
                ny(3) = [];
            end
            break;
    end
    
    if point == 3
        nx(1) = nx(3);
        ny(1) = ny(3);
        nx(:,2) = 0;
        delete(corecross);
        xl = [nx(1) nx(1)+1;nx(1)+1 nx(1)];
        yl = [ny(1) ny(1);ny(1)+1 ny(1)+1];
        
        corecross(:,1) = line(xl, yl, 'color', 'black', 'erasemode', 'none', 'linew', 2);
        point = 2;
    else
        xl = [nx(point) nx(point)+1;nx(point)+1 nx(point)];
        yl = [ny(point) ny(point);ny(point)+1 ny(point)+1];
        corecross(:,point) = line(xl, yl, 'color', 'black', 'erasemode', 'none', 'linew', 2);
        point = point +1;
    end
    
end
%% draw rectangle
if min(nx) == 0
    cmsplot_prop.corecross = corecross(corecross~=0);
    nx = nx(nx~=0);
    ny = ny(ny~=0);
else
    delete(corecross(corecross~=0));
    rect = rectangle('position',[min(nx),min(ny),abs(diff(nx))+1,abs(diff(ny))+1],'linew', 2.5);
    cmsplot_prop.corecross = rect;
end
set(hfig,'userdata',cmsplot_prop);
%% get nessesary data for plot
ias = min(nx):max(nx);
jas = min(ny):max(ny);
assems = zeros(2,length(ias)*length(jas));
itvar = 1;
for i = 1:length(ias)
    for j = 1:length(jas)
        assems(:,itvar) = [jas(j) ias(i)]; 
        itvar  = itvar +1; 
    end
end
if coreinfo.core.if2x2 == 2
    knums = sort(cpos2knum(assems(1,:),assems(2,:),coreinfo.core.mminj2x2));
else
    knums = sort(cpos2knum(assems(1,:),assems(2,:),coreinfo.core.mminj));
end

figure(submeshfig)
% submeshplot_prop.subnodedata = subnodedata;
submeshplot_prop.knums = knums;
submeshplot_prop.positions = {ias jas};
set(submeshfig,'userdata',submeshplot_prop);
%% this function contains PlotSubMeshData which is the function that plots the data
get_submesh_data; 

end
