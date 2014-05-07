function data_listbox_callback(src,~,hfig)

global knum;
global cn;

CmsCoreProp=get(hfig,'userdata');
axes(CmsCoreProp.handles.coremap);

old_knum=cpos2knum(CmsCoreProp.i,CmsCoreProp.j,CmsCoreProp.core.mminj);
col=CmsCoreProp.core.s(old_knum).color;
rectangle('Position',[CmsCoreProp.j(1)-0.3, CmsCoreProp.i(1)-0.3, 0.6, 0.6], 'LineWidth',3,'ButtonDownFcn',{@mickey_core,hfig},'EdgeColor',CmsCoreProp.clmap(col,:));


if(CmsCoreProp.core.s(old_knum).crd(cn) < CmsCoreProp.core.crdsteps)
    % White CRD rectangles
    crdsteps=CmsCoreProp.core.crdsteps;
    for i = 1 : CmsCoreProp.core.irmx
        for j = 1 : CmsCoreProp.core.irmx
            for k=1:CmsCoreProp.core.tot_crd
                if(i==CmsCoreProp.core.sc(k).pos(2) && j==CmsCoreProp.core.sc(k).pos(1) && CmsCoreProp.core.sc(k).konrod(cn) < crdsteps)
                    x =[2*i-0.35,2*i-0.35,2*i-1-0.2,2*i-1-0.2];
                    x=x+0.25;
                    y =[2*j-0.5,2*j-1.2,2*j-1.2,2*j-0.5];
                    y=y+0.3;
                    fill(x,y,[1.0,1.0,1.0],'LineWidth',1);
                    break;
                end
            end
        end
    end
    % CRD inserted values
    if(crdsteps > 100)
        crddiv=10;
    else
        crddiv=1;
    end
    for i = 1 : CmsCoreProp.core.irmx
        for j = 1 : CmsCoreProp.core.irmx
            for k=1:CmsCoreProp.core.tot_crd
                if(i==CmsCoreProp.core.sc(k).pos(2) && j==CmsCoreProp.core.sc(k).pos(1)&&CmsCoreProp.core.sc(k).konrod(cn) < crdsteps)
                    ce=sprintf('%d',CmsCoreProp.core.sc(k).konrod(cn)/crddiv);
                    text(2*i-0.48, 2*j-0.5, ce,...
                        'Color', 'black',...
                        'FontSize', 10,...
                        'FontUnits', 'normalized',...
                        'FontWeight', 'bold',...
                        'HorizontalAlignment', 'center',...
                        'ButtonDownFcn',{@mickey_core,hfig});
                    break;
                end
            end
        end
    end
end


toplistvalue=get(CmsCoreProp.handles.data_listbox,'ListboxTop');

ival=get(src,'Value');
ibun=CmsCoreProp.isort(ival);
set(CmsCoreProp.handles.bur_listbox,'value', ival,'ListboxTop',toplistvalue);

CmsCoreProp.j=CmsCoreProp.core.s(ibun).pos(2);
CmsCoreProp.i=CmsCoreProp.core.s(ibun).pos(1);

knum=cpos2knum(CmsCoreProp.i,CmsCoreProp.j,CmsCoreProp.core.mminj);

set(hfig,'userdata',CmsCoreProp);

rectangle('Position',[CmsCoreProp.j(1)-0.3, CmsCoreProp.i(1)-0.3, 0.6, 0.6], 'LineWidth',3,'ButtonDownFcn',{@mickey_core,hfig});


% paint_core([],[],hfig);


end