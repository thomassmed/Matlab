function y = get_realnodes;
%
% y = get_realnodes
%
% UTDATA : Etta på de noder som kan relateras till en volym.

%@(#)   get_realnodes.m 2.2   02/02/27     12:07:13

global geom

nin = geom.nin;

temp = ones(get_thsize,1);
temp(nin) = zeros(length(nin),1);

y = temp;

return;

