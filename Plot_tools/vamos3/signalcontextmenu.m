function [menu]=signalcontextmenu(handles)

menu = uicontextmenu();

uimenu(menu,'Label','Remove','Callback',{@removesignal,gca});
uimenu(menu,'Label','Crop','Callback',{@cropsignal,gca});
uimenu(menu,'Label','Save signal','Callback',{@timeplot_savedata,gca});
uimenu(menu,'Label','Reset','Callback',{@resetsignal,gca});
alignmenu = uimenu(menu,'Label','Align','Separator','on');
	uimenu(alignmenu,'Label','Align x','Callback',{@doalign,gca,'x'});
	uimenu(alignmenu,'Label','Align y','Callback',{@doalign,gca,'y'});
	uimenu(alignmenu,'Label','Align xy','Callback',{@doalign,gca,'xy'});
scalemenu = uimenu(menu,'Label','Scale signal','Separator','on');
	uimenu(scalemenu,'Label','Factor','Callback',{@setscalefactor,gca});
	uimenu(scalemenu,'Label','Bias','Callback',{@setbias,gca});
	uimenu(scalemenu,'Label','Detrend','Callback',{@dodetrend,gca});
	uimenu(scalemenu,'Label','Adjust fs','Callback',{@setfs,gca});
uimenu(menu,'Label','Line properties','Callback','scribelinedlg(gco)','Separator','on');
