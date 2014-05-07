function paint_exp(~,~,hfig)

HotBirdProp=get(hfig,'userdata');
cn=HotBirdProp.cn;
axes(HotBirdProp.handles.patron);
reset(gca);
HotBirdProp.cs.s(cn).calcexp();
nr=HotBirdProp.cs.s(cn).point_nr;

if (HotBirdProp.handles.selection_textbox == 0)
    HotBirdProp.handles.selection_textbox = annotation(hfig,'textbox',[.77 .81 .20 .04], ...
        'string','ENR                     EXP','fontweight','bold','LineStyle','none');
else
    set(HotBirdProp.handles.selection_textbox,'string','ENR                     EXP');
end

cmax = max(max(HotBirdProp.cs.s(cn).exp(:,:,nr)));
cmin = cmax;
for i=1:HotBirdProp.cs.s(cn).npst
    for j=1:HotBirdProp.cs.s(cn).npst
        if(HotBirdProp.cs.s(cn).enr(i,j) > 0)
            if(HotBirdProp.cs.s(cn).exp(i,j,nr) < cmin)
                cmin = HotBirdProp.cs.s(cn).exp(i,j,nr);
            end
        end
    end
end


% cmin = min(min(HotBirdProp.cs.s(cn).exp(:,:,nr)));
% cmin = 0;
ncol = 9;
HotBirdProp.button=3;

vitmat=ones(HotBirdProp.cs.s(cn).npst)*1;
image(vitmat,'ButtonDownFcn',{@mickey_patron,hfig});

% plmat=ncol*HotBirdProp.cs.s(cn).exp(:,:,nr)/(cmax-cmin)-ncol*cmin/(cmax-cmin)+1;
% image(plmat);
set(gca,'XTick',[],'YTick',[]);



  hold on;
    
    cmax = HotBirdProp.cs.s(cn).nr_fue;
    cmin = min(min(HotBirdProp.cs.s(cn).lfu));
    ncol = HotBirdProp.cs.s(cn).nr_fue;
    enrmat=ncol*HotBirdProp.cs.s(cn).lfu/(cmax-cmin)-ncol*cmin/(cmax-cmin)+1;
    
    
    
    if(strcmp(HotBirdProp.cs.s(cn).type, 'Atrium10'))
        rectangle('Position',[4.5, 4.5, 3, 3], 'LineWidth',2,'FaceColor',[0.8,0.9,1]);
    elseif  (strcmp(HotBirdProp.cs.s(cn).type, 'GE14') || strcmp(HotBirdProp.cs.s(cn).type, 'GNF2'))
        t = 0 : 0.1 : 2*pi;
        x = 1.0*cos(t) + 4.5;
        y = 1.0*sin(t) + 6.5;
        fill(x, y,[0.8,0.9,1])
        y = 1.0*cos(t) + 4.5;
        x = 1.0*sin(t) + 6.5;
        axis('square');
        fill(x, y,[0.8,0.9,1]);
    elseif  (strcmp(HotBirdProp.cs.s(cn).type, 'Svea96Optima2'))
        
        x =[5.7,5.7,4.5,0.0,0.0,4.5,5.7, 5.7, 6.3, 6.3, 7.5,11.5,11.5, 7.5, 6.3, 6.3];
        y =[0.0,4.5,5.7,5.7,6.3,6.3,7.5,11.5,11.5, 7.5, 6.3, 6.3, 5.7, 5.7, 4.5, 0.0];
        fill(x,y,[0.8,0.9,1],'LineWidth',2);
    end
    
    t = 0 : 0.05 : 2*pi;
    for i = 1 : HotBirdProp.cs.s(cn).npst
        for j = 1 : HotBirdProp.cs.s(cn).npst
            x = 0.38*cos(t) + i;
            y = 0.38*sin(t) + j;
            if (HotBirdProp.cs.s(cn).enr(i,j) > 0)
                fill(x, y,HotBirdProp.clmap(enrmat(i,j),:), 'ButtonDownFcn',{@mickey_patron,hfig});
%                 rectangle('Position',[i-0.5, j-0.5, 1, 1], 'LineWidth',1);
            end
        end
    end


for i=1:HotBirdProp.cs.s(cn).npst
    for j=1:HotBirdProp.cs.s(cn).npst
        if (HotBirdProp.cs.s(cn).pow(i,j,1) > 0)
%             if(HotBirdProp.cs.s(cn).ba(i,j) > 0);
%                 ce=sprintf('%4.2f',HotBirdProp.cs.s(cn).exp(i,j,nr));
%                 text(j, i, ce,...
%                     'Color', 'black',...
%                     'FontSize', 10,...
%                     'FontWeight', 'bold',...
%                     'VerticalAlignment', 'bottom',...
%                     'HorizontalAlignment', 'center',...
%                     'ButtonDownFcn',{@mickey_patron,hfig});
%                 ce=sprintf('BA');
%                 text(j, i, ce,...
%                     'Color', 'black',...
%                     'FontSize', 10,...
%                     'FontWeight', 'bold',...
%                     'VerticalAlignment', 'top',...
%                     'HorizontalAlignment', 'center',...
%                     'ButtonDownFcn',{@mickey_patron,hfig});
%             else
                ce=sprintf('%4.1f',HotBirdProp.cs.s(cn).exp(i,j,nr));
                text(j, i, ce,...
                    'Color', 'black',...
                    'FontSize', 10,...
                    'FontWeight', 'bold',...
                    'FontUnits', 'normalized',...
                    'VerticalAlignment', 'middle',...
                    'HorizontalAlignment', 'center',...
                    'ButtonDownFcn',{@mickey_patron,hfig});
%                 ce=sprintf('%4.2f',HotBirdProp.cs.s(cn).enr(i,j));
%                 text(j, i, ce,...
%                     'Color', 'black',...
%                     'FontSize', 10,...
%                     'FontWeight', 'bold',...
%                     'VerticalAlignment', 'top',...
%                     'HorizontalAlignment', 'center',...
%                     'ButtonDownFcn',{@mickey_patron,hfig});    
%             end
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