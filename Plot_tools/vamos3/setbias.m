function setbias(src,eventdata,ax)
sigh = gco;

uds = get(sigh,'UserData');
ydata = get(sigh,'YData');

if isfield(uds,'bias')
	oldbias = uds.bias;
	bias = inputdlg('Bias','Bias',1,{num2str(uds.bias)});
else
	oldbias = 0;
	bias = inputdlg('Bias','Bias',1,{num2str(0)});
end
if ~isempty(bias)
	bias = str2num(bias{1});

	uds.bias = bias;
	
	ydata = ydata + (bias -oldbias);

	set(sigh,'YData',ydata);
	set(sigh,'UserData',uds);
end
