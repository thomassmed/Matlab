%@(#)   knumsym.m 1.1	 06/04/05     15:02:23
%
% function mat=knumsym(mminj,sym)
%
% This function returns a matrix of rod numbers. It supports symmetries
% 'full', 'hrot' and 'qrot'. Each row in the matrix contains symmetry
% elements (rods).
%
% mminj - describes the core
% sym   - symmetry (= 'full', 'hrot', 'qrot', 1, 3 or 5)

function mat=knumsym(mminj,sym)
% symmetries from POLCA:
% Full      1
% HMir      2
% HRot      3 (default in this function)
% QMir      4
% QRot      5
% Periodic  6
if nargin < 2
    sym = 3;
elseif isstr(sym)
    switch lower(sym)
        case 'full'
            sym = 1;
        case 'hmir'
            sym = 2;
        case 'hrot'
            sym = 3;
        case 'qmir'
            sym = 4;
        case 'qrot'
            sym = 5;
        case 'periodic'
            sym = 6;
        otherwise
            sym = 0;
    end
end
% supported now is sym = 1, 3 and 5
if rem(sym,2)==0
    error('Not supported symmetry in knumsym')
end
switch sym
    case 1
        mat = 1:antkan(mminj);
        mat = mat';
    case 3
        [ri,le] = knumhalf(mminj);
        mat = [ri le];
    case 5
        [ur,ul,ll,lr]=knumquarter(mminj);
        mat = [ur ul ll lr];
end
