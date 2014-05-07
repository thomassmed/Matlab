function ruler_createbuttons(fig)

load('siggui_icons.mat');
mtoggle=uitoggletool('Tag','rulerbtn','CData',bmp.markers,'OnCallback',{@ruler_on},'OffCallback',{@ruler_off});
set(mtoggle,'ToolTipString','Activate ruler');
set(mtoggle,'State','off');

mhori=uipushtool('CData',bmp.vertical,'ClickedCallback',{@ruler_sethorizontal});
set(mhori,'ToolTipString','Vertical rulers');
mvert=uipushtool('CData',bmp.horizontal,'ClickedCallback',{@ruler_setvertical});
set(mvert,'ToolTipString','Horizontal rulers');
