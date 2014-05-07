function status= is_absolute(filename)
% returns true if filename is an absolute name
%
% status= is_absolute(filename)
% is_absolute returns true if filename is an absolute name.
if strncmp(computer,'PC',2);
    filename=upper(filename);
    status=((abs(filename(1))>64&&abs(filename(1))<91)&&abs(filename(2))==58)||abs(filename(1))==47||abs(filename(1))==92;
else
    status = strncmp(filename,'/',1);
end