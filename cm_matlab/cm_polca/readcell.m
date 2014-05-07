%@(#)   readcell.m 1.2	 94/08/12     12:10:49
%
%function tab=readcell(filename,fuetyp,tabpar)
function tab=readcell(filename,fuetyp,tabpar)
[size,tabadr,tab,ierr]=readcd(filename,-2,-2,fuetyp,0,1,tabpar);
if ierr==1 disp('At least one table not found in CD file.');end
if ierr==2 disp('Illegal table name in TABPAR().');end
if ierr==3 disp('Illegal CD file (code not OK).');end
