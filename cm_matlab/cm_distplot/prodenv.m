%@(#)   prodenv.m 1.2	 96/03/08     13:13:55
%
function prodenv
p=getenv('MATLABPATH');
path(p);
startup;
clear functions
