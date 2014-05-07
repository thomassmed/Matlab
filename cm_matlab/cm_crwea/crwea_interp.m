% $Id: crwea_interp.m 44 2012-07-16 10:18:15Z rdj $
%
function [crpos_intp,cprmin_intp]=crwea_interp(crpos,operpoints,cprmin,operlimit)

% Added conservatim to CR position
CRPOS_ADD=2;

l=length(operpoints);
lu=length(unique(operpoints));

if l ~= lu
    %disp(['Operpoints contains non distinct values. Removed ' ...
    %    num2str(l-lu) ' of ' num2str(l) ' points.']);
    [operpoints,i,j]=unique(operpoints);
    crpos=crpos(i);
    cprmin=cprmin(i);
end

if length(operpoints)<2
   %disp('Single operpoint, no interpolation done!');
   crpos_intp=nan;
   cprmin_intp=nan;
   return;
end

crpos_intp=interp1(operpoints,crpos,operlimit);

crpos_intp=crpos_intp+CRPOS_ADD;

cprmin_intp=interp1(crpos,cprmin,crpos_intp);

