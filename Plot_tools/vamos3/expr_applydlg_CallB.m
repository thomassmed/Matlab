function expr_applydlg_CallB(src,eventdata,varsel)


for i=1:length(varsel)

	signals(i) = get(varsel(i),'Value');

end
set(gcf,'UserData',signals);


uiresume();
