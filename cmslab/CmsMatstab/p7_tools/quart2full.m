%@(#)   quart2full.m 1.1	 06/04/05     16:06:52
%
function kfull=quart2full(kquart,mminj)
mat=knumsym(mminj,5);
kfull=mat(kquart,:);
