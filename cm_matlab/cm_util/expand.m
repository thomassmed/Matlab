%@(#)   expand.m 1.1	 03/08/19     08:46:22
%
function filename=expand(filename,extension);

% expand(filename,extension);
%
% examp: expand('test','inp')       ->  test.inp
%        expand('test.inp','inp')   ->  test.inp
%        expand('test.dat','inp')   ->  test.dat.inp
%        expand('testinp','inp')    ->  testinp.inp
%

% Philipp Haenggi, Leibstadt 4.9.96

len=length(filename);
if len==0
  return
elseif len<4
  filename=[filename '.' extension];
elseif ~strcmp(filename(len-3:len),['.' extension])
  filename=[filename '.' extension];
end
