%
%@(#)   readmast.m 1.1	 95/01/25     10:20:08
%
%function vec=readmast(masfil,par_no,type)
%
%par_no is parameter number in CM master files
%type can be I, F, C1 or C2 for Integer, Float resp Char values
%C2 is used to pack values stored in A2 format
function vec=readmast(masfil,par_no,type)
if nargin ~=3,error('Usage vec=readmast(masfil,par_no,type)');end
if par_no<0 | par_no>200,error('Wrong parameter number');end
vec=mast2mlab(masfil,par_no,type);
