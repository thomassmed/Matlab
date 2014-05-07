%@(#)   printsfg.m 1.1	 05/07/13     10:29:38
%
%
%function printsfg(fid,ifrom,ito,buid,mminj,ppos,comment,block);
function printsfg(fid,ifrom,ito,buid,mminj,ppos,comment,block);
if nargin<8, block='F1';end
if nargin<7, comment=0;end
if ito==0,
   tostr=ppos;
%  tostr='BA101';
else
  cpos=knum2cpos(ito,mminj);
  tostr=cpos2axis(cpos);
end
buid=remblank(buid);
if comment==0,
  if fid>0,
    fprintf(fid,'%s%s%s%s','P,',buid,',,',tostr);
    if strcmp(upper(block),'F3'),if ifrom~=0, fprintf(fid,'%s',',,L');end;end
    fprintf(fid,'\n');
  else
    fprintf('%s%s%s%s','P,',buid,',,',tostr);
    if strcmp(upper(block),'F3'),if ifrom~=0, fprintf('%s',',,L');end;end
    fprintf('\n');
  end
else
  if comment==1,
    cpos=knum2cpos(ifrom,mminj);
    crstring=cpos2supc(cpos);
    comm=['C,Supercell ',crstring,' tom'];
  elseif comment==2,
    cpos=knum2cpos(ito,mminj);
    crstring=cpos2supc(cpos);
    comm=['C,Provdrag ',crstring];
  elseif isstr(comment)
    comm=['C,',comment];   
  end
  if fid>0,
    fprintf(fid,'%s\n',comm);
  else
    fprintf('%s\n',comm);
  end
end
