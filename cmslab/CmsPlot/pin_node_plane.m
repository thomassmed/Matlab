function pin_node_plane
% pin_node_plane is used by pinplot to set node planes

% Mikael Andersson 2011-12-15
%% get data from fig
pinfig=gcf;
pinplot_prop=get(pinfig,'userdata');
def_answr=pinplot_prop.pindata.kdfuel;
%% get new node plane(s) and check for, one or more node planes and if input is valid

nod=inputdlg('Enter node planes','Node plane',1,{['1' ':' num2str(def_answr)]} );
if ~isempty(nod)
    while 1
        lenghttest = regexp(nod,':');
        if isempty(lenghttest{1})
            node = str2double(nod{1});
            if node >= 1 && node <= def_answr
                set_cmsplot_prop('nod_plane',[node node]);
                PlotPinData;
                return;
            end
        else
            nods = regexp(nod,':','split');
            nod1 = str2double(nods{1}{1});
            nod2 = str2double(nods{1}{2});
            if (nod1 >= 1 && nod1 <= def_answr) && (nod2 >= 1 && nod2 <= def_answr)
                set_cmsplot_prop('nod_plane',[nod1 nod2]);
                PlotPinData;
                return;
            end
        end
        nod=inputdlg('Invalid node planes, enter new node planes','Node plane',1,{['1' ':' num2str(def_answr)]} );
    end
end
        