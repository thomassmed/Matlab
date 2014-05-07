function setscalefactor(src,eventdata,ax)
sigh = gco;

uds = get(sigh,'UserData');
ydata = get(sigh,'YData');

if isfield(uds,'factor')
	oldfactor = uds.factor;
	scalefactor = inputdlg('Scalefactor','Scalefactor',1,{num2str(uds.factor)});
else
	oldfactor = 1;
	scalefactor = inputdlg('Scalefactor','Scalefactor',1,{num2str(1)});
end
if ~isempty(scalefactor)
	scalefactor = abs(str2num(scalefactor{1}));

	uds.factor = scalefactor;

	ydata = ydata * (scalefactor/oldfactor);

	set(sigh,'YData',ydata);
	set(sigh,'UserData',uds);
end
