function [dr,fd,Qrel,Wtot,Wrel,drh,fdh]=get_drfd(matfiles)
% get_drfd    Get decay ratio (dr) and frequency from mat-files
%
% [dr,fd]=get_drfd(matfiles);
% [dr,fd,Qrel,Wtot]=get_drfd(matfiles);
% [dr,fd,Qrel,Wtot,dr_harm,fd_harm]=get_drfd(matfiles);
%
% Example:
%     matfiles={'/cms/t2-jef/c18/s3k/s3k-1.mat','/cms/t2-jef/c19/s3k/s3k-1.mat'};
%     [dr,fd]=get_drfd(matfiles)
%
% See Also
% plotdrfd, drfd2file

if ~iscell(matfiles), matfiles=cellstr(matfiles);end

dr=nan(length(matfiles),1);fd=dr;Qrel=dr;Wtot=dr;Wrel=dr;
for i=1:length(matfiles),
  matfile=char(matfiles{i});
  s=load(matfile,'stab');
  if isfield(s,'stab'),
      stab=s.stab;
      [dr(i),fd(i)]=p2drfd(stab.lam);
      if nargout>2,
          load(matfile,'Oper');
          Qrel(i)=Oper.Qrel;
          Wtot(i)=Oper.Wtot;
          Wrel(i)=Oper.Wtot/Oper.Wnom*100;
      end
      if nargout>4,
          if isfield(stab,'lamh')
              [drh(i,:),fdh(i,:)]=p2drfd(stab.lamh);
          end
      end
  else
      fprintf(1,'stab not found in file %s\n',matfile);
  end
end  
if nargout>4,
    if exist('drh','var')
        fill_nans=nan(length(matfiles)-size(drh,1),size(drh,2));
        drh=[drh;fill_nans];
        fdh=[fdh;fill_nans];
    else
        drh=[];
        fdh=[];
    end
end
        