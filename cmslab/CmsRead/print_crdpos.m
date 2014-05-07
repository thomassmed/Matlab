function print_crdpos(konrod,crmminj,printfile)
% prints the card CRD.POS from a konrod vector
%
% print_crdpos(konrod,crmminj[,printfile])
%
% Input
%   konrod - Vector of control rod positions
%   crmminj - Control rod contour vector
%
%  Output
%    printfile - Name of file to which the card 'CRD.POS' is printed
%                if no file is given, the card is printed to the screen
% Example:
%   fue_new=read_restart_bin('s3.res');
%   print_crdpos(fue_new.konrod,fue_new.crmminj,'crdpos.inp');
%   print_crdpos(fue_new.konrod,fue_new.crmminj);
%
% See also read_crdpos, get_card, read_simfile, read_restart_bin
%  

% Copyright Studsvik Scandpower 2009

%%
if nargin<3,
    fid=1;
else
    fid=fopen(printfile,'w');
end
    %%
card=['''','CRD.POS',''''];
fprintf(fid,'%s %i \n',card,1);
nrows=length(crmminj);
kcount=0;
for i=1:nrows,
    if crmminj(i)>1,
      fprintf(fid,' %i%s%i',crmminj(i)-1,'*',0);
    else
        fprintf(fid,'    ');
    end
    for j=1:crmminj(i),
        fprintf(fid,'     ');
    end
    for j=1:nrows-2*(crmminj(i)-1)
        kcount=kcount+1;
        fprintf(fid,'%5i',round(konrod(kcount)));
    end
    for j=1:crmminj(i),
        fprintf(fid,'     ');
    end
    if crmminj(i)>1,
      fprintf(fid,' %i%s%i',crmminj(i)-1,'*',0);
    end    
    fprintf(fid,'\n');
end

