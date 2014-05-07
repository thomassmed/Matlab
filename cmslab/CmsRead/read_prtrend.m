function sig=read_prtrend(filename,signal)
%
%   sig=read_prtrend(filename,signal)
%
read_prtrend_pp2=which('read_prtrend.pp2');
eval_str=['!pp2 ',filename,' 0 lib=',read_prtrend_pp2,' st=init p1=',signal,' exit=yes'];
eval(eval_str);
sig=load('HMS.SCRATCH');