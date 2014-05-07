function dist=hms_pp2_read(hmsfile,dist_name,proc_name)
% Uses pp2 to read from hermes data base into matlab
%
% dist=hms_pp2_read(hmsfile,dist_name[,proc_name])
%
% Input:
%  hmsfile   - Hermes file name
%  dist_name - Name of distribution to be read, 
%                 dimension: ntot by 1 (vector)
%  proc_name - Name of pp2-procedure to be used from matlab.pp2,
%                 default=get_dist        
%
% Examples:
%    burnup=hms_pp2_read(hermes_file,'3EXP');
%    burnup=hms_pp2_read('onldist.hms','BURNUP');
%    burnup=hms_pp2_read('onldist.hms','3EXP/DATA','get_data'); 
%    burnup_PROC=hms_pp2_read('C:\cms\matlab\onldist.hms','3EXP/PROC','get_data');
%    kmax=hms_pp2_read(hermes_file,'MZ_KMAX','get_var');
%
% See also: hms_readdist, hms_distlist
if nargin<3, proc_name='get_dist'; end


%%
mat_pp2=which('matlab.pp2');
dist_name=['"',dist_name,'"'];
eval_string=['!pp2 ',hmsfile,' LIB=',mat_pp2,' VERB=0 ST=',proc_name,' P1=',dist_name];
%%
eval(eval_string)
load HMS_SCRATCH.txt
dist=HMS_SCRATCH;
