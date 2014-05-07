function paint_powl(~,~,hfig)

HotBirdProp=get(hfig,'userdata');
cn=HotBirdProp.cn;
axes(HotBirdProp.handles.patron);
if(HotBirdProp.handles.selection_textbox == 0)
    HotBirdProp.handles.selection_textbox = annotation(hfig,'textbox',[.785 .71 .20 .04], ...
        'string','ENR        POWL','fontweight','bold','LineStyle','none');
else
    set(HotBirdProp.handles.selection_textbox,'string','ENR        POWL');
end
nr=HotBirdProp.cs.s(cn).point_nr;
cmax=HotBirdProp.cs.s(cn).fint(nr);
cmin = 0.8;
ncol = 9;
plmat=ncol*HotBirdProp.cs.s(cn).powl(:,:,nr)/(cmax-cmin)-ncol*cmin/(cmax-cmin)+1;
image(plmat);
set(gca,'XTick',[],'YTick',[]);
HotBirdProp.button=8;

for i=1:HotBirdProp.cs.s(cn).npst
    for j=1:HotBirdProp.cs.s(cn).npst
        if (HotBirdProp.cs.s(cn).powl(i,j,1) > 0)
            if(HotBirdProp.cs.s(cn).ba(i,j) > 0);
                ce=sprintf('%4.2f',HotBirdProp.cs.s(cn).powl(i,j,nr));
                text(j, i, ce,...
                    'Color', 'black',...
                    'FontSize', 10,...
                    'FontWeight', 'bold',...
                    'VerticalAlignment', 'bottom',...
                    'HorizontalAlignment', 'center',...
                    'ButtonDownFcn',{@mickey_patron,hfig});
                ce=sprintf('BA');
                text(j, i, ce,...
                    'Color', 'black',...
                    'FontSize', 10,...
                    'FontWeight', 'bold',...
                    'VerticalAlignment', 'top',...
                    'HorizontalAlignment', 'center',...
                    'ButtonDownFcn',{@mickey_patron,hfig});
            else
                ce=sprintf('%4.2f',HotBirdProp.cs.s(cn).powl(i,j,nr));
                text(j, i, ce,...
                    'Color', 'black',...
                    'FontSize', 10,...
                    'FontWeight', 'bold',...
                    'VerticalAlignment', 'bottom',...
                    'HorizontalAlignment', 'center',...
                    'ButtonDownFcn',{@mickey_patron,hfig});
                ce=sprintf('%4.2f',HotBirdProp.cs.s(cn).enr(i,j));
                text(j, i, ce,...
                    'Color', 'black',...
                    'FontSize', 10,...
                    'FontWeight', 'bold',...
                    'VerticalAlignment', 'top',...
                    'HorizontalAlignment', 'center',...
                    'ButtonDownFcn',{@mickey_patron,hfig});
            end
        end
    end
end
bur= HotBirdProp.cs.s(cn).burnup(HotBirdProp.cs.s(cn).point_nr);
burnr= HotBirdProp.cs.s(cn).point_nr;
fint=HotBirdProp.cs.s(cn).fint(burnr);
kinf=HotBirdProp.cs.s(cn).kinf(burnr);

if (HotBirdProp.axial_btf == 1 && HotBirdProp.kinf_env == 0)
    HotBirdProp.cs.calc_u235(); 
    cc=sprintf('<U235>=%5.3f', HotBirdProp.cs.u235);
    set(HotBirdProp.handles.u235_textbox,'string',cc);    
    btf=HotBirdProp.cs.maxbtfax(nr,1);
    cc=sprintf('burnup=%4.1f  kinf=%7.5f  fint=%5.3f  <btf>=%5.3f',bur,kinf,fint,btf);
    set(HotBirdProp.handles.bottom_textbox,'string',cc);
elseif (HotBirdProp.axial_btf == 1 && HotBirdProp.kinf_env == 1)
    HotBirdProp.cs.calc_u235(); 
    cc=sprintf('<U235>=%5.3f', HotBirdProp.cs.u235);
    set(HotBirdProp.handles.u235_textbox,'string',cc);
    btf=HotBirdProp.cs.maxbtfax_env;
    cc=sprintf('burnup=%4.1f  kinf=%7.5f  fint=%5.3f  <btf>=%5.3f',bur,kinf,fint,btf);
    set(HotBirdProp.handles.bottom_textbox,'string',cc);
elseif (HotBirdProp.axial_btf == 0 && HotBirdProp.kinf_env == 1)    
    HotBirdProp.cs.s(cn).calc_u235;
    cc=sprintf('U235=%5.3f', HotBirdProp.cs.s(cn).u235);
    set(HotBirdProp.handles.u235_textbox,'string',cc);   
    btf=HotBirdProp.cs.s(cn).maxbtf_env;
    cc=sprintf('burnup=%4.1f  kinf=%7.5f  fint=%5.3f  <btf>=%5.3f',bur,kinf,fint,btf);
    set(HotBirdProp.handles.bottom_textbox,'string',cc);
else    
    HotBirdProp.cs.s(cn).calc_u235;
    cc=sprintf('U235=%5.3f', HotBirdProp.cs.s(cn).u235);
    set(HotBirdProp.handles.u235_textbox,'string',cc);   
    btf=HotBirdProp.cs.s(cn).maxbtf(nr);
    cc=sprintf('burnup=%4.1f  kinf=%7.5f  fint=%5.3f  btf=%5.3f',bur,kinf,fint,btf);
    set(HotBirdProp.handles.bottom_textbox,'string',cc);
end
paint_enr([],[],hfig);
HotBirdProp=data_slider(HotBirdProp);
set(hfig,'userdata',HotBirdProp);

end

