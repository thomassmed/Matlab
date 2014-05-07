function java_init(varargin)

global cs;

if (nargin < 1)
    return;
else
    cn=0;
    for i=1:nargin
        cn=cn+1;
        if (strfind(char(varargin(cn)),'cax'))
            caxfile{i}=file('normalize', char(varargin(cn)));
            filetype=1;
        elseif (strfind(char(varargin(cn)),'inp'))
            caifile{i}=file('normalize', char(varargin(cn)));
            filetype=0;
        else
            return;
        end
    end
end




if (filetype == 1)
    for i=1:nargin
        s=InitHotBirdCax(caxfile{i},i);
        cc.s(i)=s;
    end
    cs=c_cax(cc.s);
    cs.cnmax = nargin;
    java_calcbtfax();
    java_calcbtfaxenv();
    java_calc_mean_u235();
    java_calc_rod();
    cs.maxmin_values;
    java_get_plotdata();
    
else
    for i=1:nargin
        s=InitHotBirdCai(caifile{i},i);
        cc.s(i)=s;
    end
    cs=c_cax(cc.s);
    cs.cnmax = nargin;
    java_calc_mean_u235();
    java_calc_rod();
end



%java_calcbow(1,1.0)


% cs.s(1).calc_channel_bow(1.50);

% java_writecaifile(1);
% java_start_casmo(1);



% tab = [0,1.25;5,1.25;10,1.25;20,1.25;30,1.25];
% java_calc_maxfint_tab(1,tab);
% java_calc_maxfint_tab(2,tab);
% java_check_maxfint();
%
% java_calc_maxbtf_tab(1,tab);
% java_calc_maxbtf_tab(2,tab);
% java_adjust_btf();



% java_reset_powp(1);




% java_calc_u235(1);

% java_decrease_enr(1,1,1);
% java_increase_enr(2,1,1);

% java_bigcalc(1);
% java_bigcalc(2);

% java_calcbtfax();
%

% java_calc_mean_u235();

% java_get_matlab_data(1)
% java_get_matlab_data(2)
% java_calcbtfax();
% java_bigcalc(1);




% java_decrease_u235_barod(3,1)


% java_writebtffile;
% java_get_plotdata;
% java_autba(1,1);

end


function [s]=InitHotBirdCax(caxfile,cn)
s=cax(cn);
s.readcaifile(caxfile);
s.readcaxfile(caxfile);
s.init;
s.gettype;
s.bigcalc;
s.calcbtf;
s.calc_u235;
end


function [s]=InitHotBirdCai(caifile,cn)

s=cax(cn);
s.readcaifile(caifile);
s.init;
s.gettype();
s.update_enr_ba();
s.calc_u235();
end

