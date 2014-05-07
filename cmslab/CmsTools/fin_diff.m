function varargout=fin_diff(funfcn,varargin)
% Calculates the finite difference of a function fcn 
%
% [d1,d2,...]=fin_diff(@fcn,p1,p2,p3,p4,p5,..)
%
%
% Example: 
%   [P_c,jm_c,a_c,tl_c]=fin_diff(@eq_Wl,P,jm,alfa,tl,A); 
%


y0=funfcn(varargin{:});

for j=1:nargout,
  Delta=0.0001*max(max(abs(varargin{j})));
  if Delta==0,
      varargout{j}=0*y0;
  else
      varargin{j}=varargin{j}+Delta;
      yd=funfcn(varargin{:});
      varargout{j}=(yd-y0)/Delta;
      varargin{j}=varargin{j}-Delta;
  end
end
