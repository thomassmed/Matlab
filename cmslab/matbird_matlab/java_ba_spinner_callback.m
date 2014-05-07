function java_ba_spinner_callback(cn,y,ba)

global cs;

cs.s(cn).fue(y,5)=ba;
k=0;
cs.s(cn).nr_ba = 0;
for i=1:cs.s(cn).nr_fue
    if (cs.s(cn).fue(i,5) > 0)
        k=k+1;
        cs.s(cn).nr_ba = cs.s(cn).nr_ba + 1;
        cs.s(cn).fue(i,4)=7299+k;
    end
end
if (cs.s(cn).fue(y,5) == 0)
    cs.s(cn).fue(y,4) = nan;
    cs.s(cn).fue(y,5) = nan;
%     set(HotBirdProp.U235BA.handles.ba,'String','NaN');
end


cs.s(cn).update_enr_ba();
% cs.s(cn).bigcalc;
% cs.s(cn).calcbtf;
end