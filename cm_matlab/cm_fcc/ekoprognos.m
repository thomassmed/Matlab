function ekoprognos()
% This is the machine-generated representation of a MATLAB object
% and its children.  Note that handle values may change when these
% objects are re-created. This may cause problems with some callbacks.
% The command syntax may be supported in the future, but is currently 
% incomplete and subject to change.
%
% To re-open this system, just type the name of the m-file at the MATLAB
% prompt. The M-file and its associtated MAT-file must be on your path.

load ekoprognos                        

a = figure('Color',[0.9 0.6 0.8], ...
	'Colormap',mat0, ...
	'Position',[442 302 686 566], ...
	'Tag','Fig1');
b = uicontrol('Parent',a, ...
	'Units','points', ...
	'BackgroundColor',[0.9 0.6 0.8], ...
	'FontSize',18, ...
	'Position',[159.247 443.859 237.176 27.9529], ...
	'String','EKONOMIPROGNOS', ...
	'Style','text', ...
	'Tag','StaticText1');
b = uicontrol('Parent',a, ...
	'Units','points', ...
	'BackgroundColor',[0.4 0.9 0.5], ...
	'Callback',mat1, ...
	'FontSize',16, ...
	'Position',[23.7176 363.812 196.518 33.0353], ...
	'String','get new sourceprog-file', ...
	'Tag','Pushbutton1');
b = uicontrol('Parent',a, ...
	'Units','points', ...
	'BackgroundColor',[0.4 0.9 0.5], ...
	'Callback',mat2, ...
	'FontSize',16, ...
	'Position',[22.8706 324.847 196.518 33.0353], ...
	'String','get new fuelprog-file', ...
	'Tag','Pushbutton1');
b = uicontrol('Parent',a, ...
	'Units','points', ...
	'BackgroundColor',[0.4 0.9 0.5], ...
	'Callback',mat3, ...
	'FontSize',16, ...
	'Position',[338.824 363.388 195.671 33.0353], ...
	'String','edit sourceprog-file', ...
	'Tag','Pushbutton1');
b = uicontrol('Parent',a, ...
	'Units','points', ...
	'BackgroundColor',[0.4 0.9 0.5], ...
	'Callback',mat4, ...
	'FontSize',16, ...
	'Position',[341.365 324.847 195.671 33.0353], ...
	'String','edit fuelprog-file', ...
	'Tag','Pushbutton1');
b = uicontrol('Parent',a, ...
	'Units','points', ...
	'BackgroundColor',[0.4 0.9 0.5], ...
	'Callback','!makeprogmaster', ...
	'FontSize',16, ...
	'Position',[203.294 235.482 162.635 71.1529], ...
	'String','create masterprog-file', ...
	'Tag','Pushbutton1');
b = uicontrol('Parent',a, ...
	'Units','points', ...
	'BackgroundColor',[0.4 0.9 0.5], ...
	'Callback','!nedit indata_prog.txt &', ...
	'FontSize',12, ...
	'Position',[183.812 155.012 219.388 27.9529], ...
	'String','update indata-prog.txt', ...
	'Tag','Pushbutton2');
b = uicontrol('Parent',a, ...
	'Units','points', ...
	'BackgroundColor',[0.4 0.9 0.5], ...
	'Callback','brprog;', ...
	'FontSize',16, ...
	'Position',[210.071 72 162.635 47.4353], ...
	'String','run brprog', ...
	'Tag','Pushbutton1');
b = uicontrol('Parent',a, ...
	'Units','points', ...
	'BackgroundColor',[0.4 0.9 0.5], ...
	'Callback','!nedit brprog.lis &;', ...
	'FontSize',16, ...
	'Position',[211.765 11.8588 162.635 47.4353], ...
	'String','visa printfil', ...
	'Tag','Pushbutton1');
b = uicontrol('Parent',a, ...
	'Units','points', ...
	'BackgroundColor',[0.4 0.9 0.9], ...
	'Callback','delete(gcf),clear all', ...
	'FontSize',20, ...
	'Position',[430.306 19.4824 127.906 63.5294], ...
	'String','AVSLUTA', ...
	'Tag','Pushbutton3');
b = uicontrol('Parent',a, ...
	'Units','points', ...
	'BackgroundColor',[1 1 1], ...
	'Callback','cykel=get(gco,''string'');', ...
	'FontSize',14, ...
	'Position',[188.047 410.824 61.8353 24.5647], ...
	'Style','edit', ...
	'Tag','EditText1');
b = uicontrol('Parent',a, ...
	'Units','points', ...
	'BackgroundColor',[0.9 0.6 0.8], ...
	'FontSize',20, ...
	'Position',[0 411.671 203.294 27.9529], ...
	'String','nuvarande cykel:', ...
	'Style','text', ...
	'Tag','StaticText2');
b = uicontrol('Parent',a, ...
	'Units','points', ...
	'BackgroundColor',[1 1 1], ...
	'Position',[224.471 340.518 116.047 8.47059], ...
	'String',' ', ...
	'Style','listbox', ...
	'Tag','Listbox1', ...
	'Value',1);
b = uicontrol('Parent',a, ...
	'Units','points', ...
	'BackgroundColor',[1 1 1], ...
	'Position',[223.624 376.941 113.506 7.62353], ...
	'String',' ', ...
	'Style','listbox', ...
	'Tag','Listbox2', ...
	'Value',1);
b = uicontrol('Parent',a, ...
	'Units','points', ...
	'BackgroundColor',[1 1 1], ...
	'Position',[278.682 310.871 6.77647 22.8706], ...
	'String',' ', ...
	'Style','listbox', ...
	'Tag','Listbox3', ...
	'Value',1);
b = uicontrol('Parent',a, ...
	'Units','points', ...
	'BackgroundColor',[1 1 1], ...
	'Position',[276.988 190.588 9.31765 42.3529], ...
	'String',' ', ...
	'Style','listbox', ...
	'Tag','Listbox4', ...
	'Value',1);
b = uicontrol('Parent',a, ...
	'Units','points', ...
	'BackgroundColor',[1 1 1], ...
	'Position',[280.376 123.671 6.77647 27.1059], ...
	'String',' ', ...
	'Style','listbox', ...
	'Tag','Listbox5', ...
	'Value',1);
b = uicontrol('Parent',a, ...
	'Units','points', ...
	'BackgroundColor',[1 1 1], ...
	'Position',[282.071 59.2941 5.08235 11.8588], ...
	'String',' ', ...
	'Style','listbox', ...
	'Tag','Listbox6', ...
	'Value',1);