function [dist_max,dist_min]=find_scale(dists,operator)

%%
if ~iscell(dists), temp=dists;clear dists;dists{1}=temp;end
if iscell(dists{1})
    eval(['dist = cellfun(@' operator ',dists{1});']);
    dist_max=dist;
    dist_min=dist;
    for i=2:length(dists),
        eval(['dist = cellfun(@' operator ',dists{i});']);
        dist_max=max(dist_max,dist);
        dist_min=min(dist_min,dist);
    end
elseif min(size(dists{1}))==1 
    dist_max=dists{1};
    dist_min=dists{1};
    for i=2:length(dists),
        dist_max=max(dist_max,dists{i});
        dist_min=min(dist_min,dists{i});
    end
else
    dist=eval([operator,'(dists{1});']);
    dist_max=dist;
    dist_min=dist;
    for i=2:length(dists),
        dist=eval([operator,'(dists{',sprintf('%i',i),'});']);
        dist_max=max(dist_max,dist);
        dist_min=min(dist_min,dist);
    end
end