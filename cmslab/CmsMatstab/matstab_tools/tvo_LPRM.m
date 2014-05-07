function [lprm,aprm,Ts]=tvo_LPRM(matfile)
%%
load(matfile);
%%
ic_lprm=0;
ic_aprm=0;
v=whos;
for i=1:length(v),
    if length(v(i).name)>5,
        if strcmp(v(i).name(1:6),'CH531K'),
            xx=eval([v(i).name,'.Values']);
            xx=double(xx)';
            if strcmp(v(i).name(1:8),'CH531K95'),
                ic_aprm=ic_aprm+1;
                aprm.Values(:,ic_aprm)=xx;
                aprm.Name{ic_aprm}=v(i).name;
            else
                ic_lprm=ic_lprm+1;
                lprm.Values(:,ic_lprm)=xx;
                lprm.Name{ic_lprm}=v(i).name;
            end
        end
    end
end
Ts=time(2)-time(1);Ts=double(Ts);