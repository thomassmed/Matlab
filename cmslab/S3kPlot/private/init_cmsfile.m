function h=init_cmsfile(h,hmainFig,Groups,nlab)


for i=1:nlab,
    h(2,i+1)=uimenu(h(2,1),'label',Groups.Labels{i},'callback',{@get_selection,i});
end
h(2,nlab+1)=uimenu(h(2,1),'label','All','callback',{@get_selection,nlab+1});