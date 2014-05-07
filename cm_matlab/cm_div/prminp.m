%@(#)   prminp.m 1.3	 05/12/08     13:21:50
%
%function prminp(distfile,prmdist)
% Generates LPRM input-card 
% Input: distfile - distribution file name
%        prmdist  - Name on PRM-distribution to be used, default='prmgam'
function prminp(distfile,prmdist)
if nargin<2, prmdist='prmgam';end
prmgam=readdist7(distfile,prmdist);
fid=fopen('prminp.txt','w');
disp('Results will be printed on prminp.txt');
[ip,jp]=size(prmgam);
for i=1:jp,
  fprintf(fid,'%s%i%s','LPRM     ',i,'=');
  for k=4:-1:2, 
    fprintf(fid,'%i%s',round(prmgam(k,i)),',');
  end
  fprintf(fid,'%i',round(prmgam(1,i)));
  fprintf(fid,'\n');
end  
fclose(fid);
