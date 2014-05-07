function knum = sym2knum(mminj,sym,symkind)
% sym2knum will give a knum matrix/vector for a given symmetry and mminj.
%   
%   knum = sym2knum(mminj,sym)
%   
% Input
%   mminj       - first assembly position for each row - compact description frequently used to
%                 describe core geometry
%   sym         - the symmetry of the core
% Output
%   knum        - vector of channel numbers for full symmetry. Matrix for
%                 symmetric case, then each row contains symmetric channel numbers
%   
% works for symmetries:
%                        Quarter Core - 'NW','NE','SW','SE'
%                        Half Core 'N','S','W','E'
%                        Full Core 'FULL'
% Example:
%
% knum = sym2knum(suminfo.core.mminj,suminfo.core.sym)
% 
% See also ij2mminj, mminj2ij

% Mikael Andersson 2011-10-12



if nargin == 2
    symkind = 'rot';
else
    symkind = sumkind; %% TODO: add mirror symmetry
    warning('Sorry mirror symmetry is not implemented yet')
    return
end

[ia ja] = mminj2ij(mminj);
iafull = length(mminj);
switch upper(sym)
    case 'FULL'
        [~,~,knum]=ij2mminj(ia,ja);
    
    case 'S'
        is = ia>iafull/2;
        ia = ia(is);
        ja = ja(is);
        [mm,d,knum]=ij2mminj(ia,ja);
    case 'N'
        is = ia<=iafull/2;
        ia = ia(is);
        ja = ja(is);
        [mm,d,knum]=ij2mminj(ia,ja)
    case 'E'
        is = ja>iafull/2;
        ia = ia(is);
        ja = ja(is);
        [mm,d,knum]=ij2mminj(ia,ja);
    case 'W'
        is = ja<iafull/2;
        ia = ia(is);
        ja = ja(is);
        [mm,d,knum]=ij2mminj(ia,ja);
    case 'NW'
        is = ia<=iafull/2 & ja<iafull/2;
        ia = ia(is);
        ja = ja(is);
        [mm,d,knum]=ij2mminj(ia,ja);  
    case 'SW'
        is = ia>iafull/2 & ja<iafull/2;
        ia = ia(is);
        ja = ja(is);
        [mm,d,knum]=ij2mminj(ia,ja);
	case 'SE'
        is = (ia>iafull/2 & ja>iafull/2);
        ia = ia(is);
        ja = ja(is);
        [mm,d,knum]=ij2mminj(ia,ja);
    case 'NE'
        is = ia<=iafull/2 & ja>iafull/2;
        ia = ia(is);
        ja = ja(is);
        [mm,d,knum]=ij2mminj(ia,ja);
    
    otherwise
    warning('symmetri not supported')
    return
        
end



