%@(#)   sload.m 1.1	 03/08/19     08:46:23
%
function [varargout]=sload(file,varargin)
if nargout~=(nargin-1), error('Inconsistent number of arguments');return;end
load(file,varargin{:});
for i=1:nargout
  s=varargin{i};
  t=eval(s);
  varargout(i)={t};
end
