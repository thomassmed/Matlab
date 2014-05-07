%@(#)   whereis.m 1.5	 05/12/08     10:32:16
%
%function ij=whereis(buidnt,distfile);
function ij=whereis(buidnt,distfile);
[dist,mminj]=readdist7(distfile,'asyid');
j=strmatch(buidnt,dist);
if ~isempty(j),ij=knum2cpos(j,mminj);else ij=[];end
