function set_pinvar

pinfig = gcf;
pinplot_prop=get(pinfig,'userdata');

matvar=inputdlg('Matlab variable','',1,{''});

evalstr=['pinplot_prop=get(gcf,''userdata'');pinplot_prop.data=',matvar{1},';pinplot_prop.rescale=''auto'''];
    evalstr=[evalstr,';set(gcf,''userdata'',pinplot_prop);'];
    evalin('base',evalstr);
    pinplot_prop=get(pinfig,'userdata');
    data = pinplot_prop.data;
%     planes = size(data,3);
eval(['newdata = ' lower(pinplot_prop.datacalc) '(data,3);']);
npini = size(data,1);
npinj = size(data,2);
if max(strcmp(fieldnames(pinplot_prop),'circs'))
    delete(pinplot_prop.circs);
end
if max(strcmp(fieldnames(pinplot_prop),'numbplots'))
    delete(pinplot_prop.numbplots);
    pinplot_prop = rmfield(pinplot_prop,'numbplots');
end
    datastr = [matvar{1} ' - ' pinplot_prop.datacalc  '   '];
    datastring{1} = datastr;
    datastring{2} = '';
    datastring{3} = '';
    for i = 1:3
        set(pinplot_prop.nodtext(i),'String',datastring{i},'FontSize',10); 
    end
%% plot circles
t = 0 : 0.05 : 2*pi;
for i = 1:npini
    for j = 1:npinj
        % take care of datacalc (mean, max, min) and pow or exp
        x = 0.39*cos(t) + i;
        y = 0.39*sin(t) + j;
        if (newdata(j,i) > 0)
            circs(j,i) = fill(x, y,newdata(j,i));
        else
            circs(j,i) = fill(x, y,[1 1 1]);
        end
    end
end    
pinplot_prop.circs = circs;    
    

    
    
    
    
    
    
    
set(pinfig,'userdata',pinplot_prop);
    
end