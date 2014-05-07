%@(#)   p2c.m 1.1	 98/12/08     14:25:29
%
%p2c 	Convert decimal-point to decimal-comma
%function function str2=p2c(str1, formatstr)
%       str1      - input floating point
%       formatstr - format for floating point ex. %7.2f.
%	str2      - output string
%	Example:
%       fprintf(fid,'Total: %s\n', p2c(value,'%15.2f'));

function str2=p2c(str1, formatstr)

str2 = sprintf(formatstr, str1);
x = find(str2 == '.');
if isempty(x);return;end
str2(x) = ',';


