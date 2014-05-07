function expr_apply(src,eventdata,exprnr)

handles = guidata(gcbo);

selfile = get(handles.filelist,'Value');
selsignal = get(handles.signallist,'Value');


exprfile = [prefdir filesep 'vamos_saved_expressions.mat'];

if fopen(exprfile) > 0
	load(exprfile);
	
	label = expressions(exprnr).label;
	exprstr = expressions(exprnr).string;
	nvar = expressions(exprnr).nvar;
end


for i=1:length(selsignal)
	siglist(i,1) = {strtrim(handles.FILES(selfile).signal(selsignal(i)).label)};
end

signals = expr_applydlg(siglist,nvar);

achar = 'a';
for i=1:length(signals)
	eval([char(double(achar)+i-1) '= handles.FILES(selfile).signal(selsignal(signals(i))).data;']);
end

eval(['exprdata = ' exprstr ';']);

labelinput = char(inputdlg('Label of saved data'));
if isempty(labelinput)
	labelinput = label;
end
sigdata.label = sprintf(' %-16s',labelinput);
sigdata.t = gettimevec(handles.FILES(selfile),1);
sigdata.fs = getfs(handles.FILES(selfile),1);
sigdata.data = exprdata;
sigdata.unit = '';
sigdata.lowlimit = '';
sigdata.highlimit = '';
sigdata.gain = '';
sigdata.desc = ['Data from expression: ' label];

if isfield(handles,'exprdatafile')
	n = handles.FILES(handles.exprdatafile).nvar;
	handles.FILES(handles.exprdatafile).signal(n+1) = sigdata;
	handles.FILES(handles.exprdatafile).nvar = n + 1;
else
	handles.exprdatafile = length(handles.FILES)+1;
	
	filedata.type = 'exprdata';
	filedata.file = 'Expressiondata';
	filedata.desc = 'Saved data from expressions';
	filedata.nvar = 1;
		
	filedata.t = nan;
	filedata.nsamples = nan;
	filedata.fs = nan;
	
	filedata.signal = sigdata;
	
	
	handles.FILES(handles.exprdatafile,1) = filedata;
end

guidata(handles.VAMOS2,handles);

updatefilelist(handles.VAMOS2);

function [signals] = expr_applydlg(siglist,nvar)

fig = figure();
set(fig,'Position',[ 200 200 150 50+(nvar*30) ]);
set(fig,'MenuBar','none');
set(fig,'CloseRequestFcn','');

achar = 'a';
vari = 1;

for i=1:nvar
	labelsel(i) = uicontrol(fig,'Style','text','String',[char(double(achar)+i-1) ' = ']);
	varsel(i) = uicontrol(fig,'Style','popupmenu','String',siglist);
	set(labelsel(i),'Position',[5 ((nvar-i)*30)+50 30 20]);
	set(varsel(i),'Position',[40 ((nvar-i)*30)+50 100 25]);
	set(varsel(i),'Value',vari);
	set(varsel(i),'Tag',['varsel' num2str(i)]);
	vari = vari + 1;
	if (vari > size(siglist,1))
		vari = 1;
	end
end

applybtn = uicontrol(fig,'Style','pushbutton','Callback',{@expr_applydlg_CallB,varsel});
set(applybtn,'String','Apply');

movegui(fig,'center');

uiwait();

signals = get(fig,'UserData');

delete(fig);


