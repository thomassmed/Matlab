function c=get_sym(msopt)
% Get scaling factor as a function of core symmetry for matstab
%
%c=get_sym
% Half core gives c=2, quarter core => c=4
 
if nargin==0,
    global msopt
end

j=[1 2 2 2 4 4 4 4 8 NaN NaN 2 2];
c=j(msopt.CoreSym);
