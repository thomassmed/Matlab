function [btfax,btfax_env] = java_test(varargin)

global cs;
caxfiles=varargin;

for i=1:nargin
    caxfiles{i}=file('normalize',varargin{i});
end

% nr_files=length(caxfiles);

for i=1:nargin
    s=InitHotBirdCax(caxfiles{i},i);
    cc.s(i)=s;
end
cs=c_cax(cc.s);
cs.cnmax = nargin;


java_increase_enr(1,1,1);
java_increase_enr(2,1,1);
java_bigcalc(1);
java_bigcalc(2);
% 
btfax = java_calcbtfax();
btfax_env = java_calcbtfaxenv();
% java_get_matlab_data(1)
% java_get_matlab_data(2)

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
