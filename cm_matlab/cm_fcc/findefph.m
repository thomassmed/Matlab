%@(#)   findefph.m 1.2	 94/08/12     12:15:05
%
function [efph,cycles]=findefph(unit)
if nargin<1,
  reakdir=findreakdir;
else 
  reakdir=['/cm/',lower(unit),'/'];
end
