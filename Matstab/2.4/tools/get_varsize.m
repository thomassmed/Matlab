function nv=get_varsize(typ)
%get_varsize
%
%nv=get_varsize(typ)
%Antalet tillstånd per nod
%Om typ='neut' fås neutroniken
 
%@(#)   get_varsize.m 2.1   96/08/21     07:57:07

if nargin==1,
  nv=12;
else
  nv = 13;
end
