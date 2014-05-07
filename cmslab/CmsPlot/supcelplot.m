function supcelplot

hfig=gcf;
cmsplot_prop=get(hfig,'userdata');
konrod = cmsplot_prop.konrod;
kmax = cmsplot_prop.core.kmax;

if cmsplot_prop.core.if2x2 == 2
    mminj = cmsplot_prop.core.mminj2x2;
    itleng = cmsplot_prop.core.kan;
    knum = cmsplot_prop.core.knum2x2;
else
    mminj = cmsplot_prop.core.mminj;
    itleng = length(konrod);
    knum = cmsplot_prop.core.knum;
end
    dist = cmsplot_prop.data;
if cmsplot_prop.core.if2x2 == 2
    ikan = convert2x2('2asspos',cmsplot_prop.core.knum,cmsplot_prop.core.mminj,'full');
else
    [ikan,~]=filtcr(konrod,mminj);
end
if strcmp(cmsplot_prop.filetype,'.res') && cmsplot_prop.coreinfo.fileinfo.Sim == 5 && iscell(dist)
    subgeoms = cmsplot_prop.subgeom;
    core = cmsplot_prop.core;
    hz = cmsplot_prop.hz;
    distcell = check_dist(dist,mminj,knum,cmsplot_prop.core.sym,1);
    clear dist
    kmax = cmsplot_prop.core.kmax;
    subbel = SubNode2NodePos(subgeoms,hz,kmax);
    for i = 1:length(subgeoms)
        for j = 1:kmax
            dist(j,i) = mean(distcell{i}(subbel{i} == j,:));
        end
    end
    
end

for i=1:itleng, 
    mdist(:,i)=sum(dist(:,ikan(i,:))')';
end
pmax=max(max(mdist))-min(min(mdist)); 


for i=1:itleng
  k=2*crnum2crpos(i,mminj);
  xx=k(2)-1;yy=k(1)+1;
  y=(yy:-2/(kmax-1):yy-2);
  h(i)=line(xx+mdist(:,i)/pmax*2,y,'color','black');
end

end