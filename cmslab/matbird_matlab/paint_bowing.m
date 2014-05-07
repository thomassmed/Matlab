function paint_bowing(~,~,hfig)

HotBirdProp=get(hfig,'userdata');
[~,cnmax] = size(HotBirdProp.cs.s);

scrsz=HotBirdProp.scrsz;
sidy=scrsz(4)/3.4;
sidx=1.4*sidy;
hfig6=figure('position',[scrsz(4)/1.0 scrsz(3)/12 sidx sidy]);
set(hfig6,'Name','Bundle channel bowing');
set(hfig6,'color',[.99 .99 .99]);
set(hfig6,'Menubar','none');
set(hfig6,'numbertitle','off');
set(hfig6,'userdata',HotBirdProp);

%% Channel bow mm:
HotBirdProp.handles.data_text1=annotation(hfig6,'textbox',[0.03 0.88 0.40 0.08], ...
    'string','Channel bow mm','fontweight','bold','LineStyle','none');
set(HotBirdProp.handles.data_text1,'LineStyle','none');
set(HotBirdProp.handles.data_text1,'FontWeight','bold');
set(HotBirdProp.handles.data_text1,'FontSize',11);
set(HotBirdProp.handles.data_text1, 'FontUnits', 'normalized');
set(HotBirdProp.handles.data_text1,'BackgroundColor', [0.99,0.99,0.99]);
%% Channel bow mm:
HotBirdProp.handles.data_text2=annotation(hfig6,'textbox',[0.03 0.77 0.60 0.08], ...
    'string','+ away from CRD,   - towards CRD','fontweight','bold','LineStyle','none');
set(HotBirdProp.handles.data_text2,'LineStyle','none');
set(HotBirdProp.handles.data_text2,'FontWeight','bold');
set(HotBirdProp.handles.data_text2,'FontSize',11);
set(HotBirdProp.handles.data_text2, 'FontUnits', 'normalized');
set(HotBirdProp.handles.data_text2,'BackgroundColor', [0.99,0.99,0.99]);
%%  Bowing popupmenu

HotBirdProp.handles.bowing=uicontrol('Style', 'popupmenu',...
    'String', '0.00|0.25|0.50|0.75|1.00|1.25|1.50|1.75|2.00|2.25|2.50|2.75|3.00|-0.25|-0.50|-0.75|-1.00|-1.25|-1.50|-1.75|-2.00|-2.25|-2.50|-2.75|-3.00',...
    'units','Normalized',...
    'position', [0.45 0.88 .15 .08],...
    'Callback',{@calc_bow,hfig});
set(HotBirdProp.handles.bowing,'BackgroundColor', [0.99,0.99,0.99]);
set(HotBirdProp.handles.bowing,'FontSize',11);
set(HotBirdProp.handles.bowing,'FontUnits','normalized');
set(HotBirdProp.handles.bowing,'FontWeight','bold');
set(HotBirdProp.handles.bowing,'HorizontalAlignment','right');


%%  Channel penalty button
HotBirdProp.handles.channel_penalty=uicontrol (hfig6,'style', 'pushbutton', 'string','Channel penalty','FontWeight','bold', ...
    'units','Normalized','position', [0.65 0.88 0.27 0.08], 'callback',{@channel_penalty,hfig});
set(HotBirdProp.handles.channel_penalty,'FontWeight','bold');
set(HotBirdProp.handles.channel_penalty,'FontSize',11);
set(HotBirdProp.handles.channel_penalty, 'FontUnits', 'normalized');
set(HotBirdProp.handles.channel_penalty','BackgroundColor', [0.96,0.96,0.96]);

HotBirdProp.handles.bowaxes=axes('position',[0.02 0.02 0.96 0.70]);
set(gca,'XTick',[],'YTick',[]);
set(gca,'color', [0.99,0.99,0.99]);
set(gca,'XColor','white');
set(hfig,'userdata',HotBirdProp);

end


function calc_bow(~,~,hfig)
%%
HotBirdProp=get(hfig,'userdata');

bowval = get(HotBirdProp.handles.bowing,'Value');
bowstr = get(HotBirdProp.handles.bowing,'string');
bow = str2double(char(bowstr(bowval,:)));

for k=1:HotBirdProp.cs.cnmax
    HotBirdProp.cs.s(k).calc_channel_bow(bow);
end

% for k=1:HotBirdProp.cs.cnmax
%     HotBirdProp.cs.s(k).old_channel_bow = bow;
% end

if (HotBirdProp.button == 4)
    paint_btf([],[],hfig);
elseif (HotBirdProp.button == 2)
    paint_pow([],[],hfig);
end

end



function channel_penalty(~,~,hfig)
%%
HotBirdProp=get(hfig,'userdata');
axes(HotBirdProp.handles.bowaxes);
cla;

bur_index = zeros(5,1);
m=1;
i=1;
while (m < HotBirdProp.cs.s(1).Nburnup)
    if (HotBirdProp.cs.s(1).burnup(m) == 0)
        bur_index(i) = m;
        i=i+1;
    elseif (HotBirdProp.cs.s(1).burnup(m) == 2.0)
        bur_index(i) = m;
        i=i+1;
    elseif (HotBirdProp.cs.s(1).burnup(m) == 5.0)
        bur_index(i) = m;
        i=i+1;
    elseif (HotBirdProp.cs.s(1).burnup(m) == 7.0)
        bur_index(i) = m;
        i=i+1;
    elseif (HotBirdProp.cs.s(1).burnup(m) == 10.0)
        bur_index(i) = m;
        i=i+1;
    elseif (HotBirdProp.cs.s(1).burnup(m) == 15.0)
        bur_index(i) = m;
        i=i+1;
    end
    m=m+1;
end



btfmax_1 = zeros(5,1);
for k=1:HotBirdProp.cs.cnmax
    HotBirdProp.cs.s(k).calc_channel_bow(1.0);
end
HotBirdProp.cs.calc_btfax();
for k=1:max(size(bur_index))
    btfmax_1(k) =  HotBirdProp.cs.maxbtfax(bur_index(k));
end

btfmax_2 = zeros(5,1);
for k=1:HotBirdProp.cs.cnmax
    HotBirdProp.cs.s(k).calc_channel_bow(-1.0);
end
HotBirdProp.cs.calc_btfax();
for k=1:max(size(bur_index))
    btfmax_2(k) =  HotBirdProp.cs.maxbtfax(bur_index(k));
end

btfmax_0 = zeros(5,1);
for k=1:HotBirdProp.cs.cnmax
    HotBirdProp.cs.s(k).calc_channel_bow(0.0);
end
HotBirdProp.cs.calc_btfax();
for k=1:max(size(bur_index))
    btfmax_0(k) =  HotBirdProp.cs.maxbtfax(bur_index(k));
end



ce=sprintf('CPR penalty in percent per mm bowing');
text(0.02, 0.90, ce,...
    'Color', 'black',...
    'FontSize', 11,...
    'FontUnits', 'normalized',...
    'FontWeight', 'bold',...
    'VerticalAlignment', 'middle',...
    'BackgroundColor', [0.99,0.99,0.99],...
    'HorizontalAlignment', 'left');
ce=sprintf('Burnup MWd/kgU');
text(0.02, 0.75, ce,...
    'Color', 'black',...
    'FontSize', 11,...
    'FontUnits', 'normalized',...
    'FontWeight', 'bold',...
    'VerticalAlignment', 'middle',...
    'BackgroundColor', [0.99,0.99,0.99],...
    'HorizontalAlignment', 'left');
ce=sprintf('Bowing away from CRD');
text(0.30, 0.75, ce,...
    'Color', 'black',...
    'FontSize', 11,...
    'FontUnits', 'normalized',...
    'FontWeight', 'bold',...
    'VerticalAlignment', 'middle',...
    'BackgroundColor', [0.99,0.99,0.99],...
    'HorizontalAlignment', 'left');
ce=sprintf('Bowing towards CRD');
text(0.65, 0.75, ce,...
    'Color', 'black',...
    'FontSize', 11,...
    'FontUnits', 'normalized',...
    'FontWeight', 'bold',...
    'VerticalAlignment', 'middle',...
    'BackgroundColor', [0.99,0.99,0.99],...
    'HorizontalAlignment', 'left');


for k=1:max(size(bur_index))
    ce=sprintf('%5.2f',HotBirdProp.cs.s(1).burnup(bur_index(k)));
    text(0.10, 0.75-0.09*k, ce,...
        'Color', 'black',...
        'FontSize', 11,...
        'FontUnits', 'normalized',...
        'FontWeight', 'bold',...
        'VerticalAlignment', 'middle',...
        'BackgroundColor', [0.99,0.99,0.99],...
        'HorizontalAlignment', 'left');
    
    ce=sprintf('%5.3f', (btfmax_1(k)/btfmax_0(k)-1)*100   );
    text(0.40, 0.75-0.09*k, ce,...
        'Color', 'black',...
        'FontSize', 11,...
        'FontUnits', 'normalized',...
        'FontWeight', 'bold',...
        'VerticalAlignment', 'middle',...
        'BackgroundColor', [0.99,0.99,0.99],...
        'HorizontalAlignment', 'left');
    
    ce=sprintf('%5.3f', (btfmax_2(k)/btfmax_0(k)-1)*100   );
    text(0.75, 0.75-0.09*k, ce,...
        'Color', 'black',...
        'FontSize', 11,...
        'FontUnits', 'normalized',...
        'FontWeight', 'bold',...
        'VerticalAlignment', 'middle',...
        'BackgroundColor', [0.99,0.99,0.99],...
        'HorizontalAlignment', 'left');
    
end






end

