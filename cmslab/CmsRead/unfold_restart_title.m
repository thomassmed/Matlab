function [ititle,xpo,acycle,versn,jobnam,iheadr,lwr]=unfold_restart_title(Title)
% unfold_restart_title Extracts information from cell arry created by read_restart_bin
% 
% [ititle,xpo,acycle,versn,jobnam,iheadr,lwr]=unfold_restart_title(Title);
% 
%
% Input - Title (= third output argument from read_restart_bin)
%
% Output -
%
% ititle - Title name (TIT.CAS)
% xpo    - exposure point
% acycle - Label for current cycle or transient (DEP.CYC)
% versn  - S3-version 
% jobnam - Job name (TIT.RUN)
% iheadr - Header (TIT.PRO)
%
% Example:
%
% [fue_new,Oper,Title]=read_restart_bin('s3.res');
% [ititle,xpo,acycle,versn,jobnam,iheadr,lwr]=unfold_restart_title(Title);
% [Limits,Xpo,Titles]=read_restart_bin('s3.res',-1);
% [ititle,xpo,acycle,versn,jobnam,iheadr,lwr]=unfold_restart_title(Titles{1});
%
% See also read_restart_bin
versn=Title{1,1};
xpo=Title{1,3}(1);
lwr=Title{1,2}(1:3);
jobnam=Title{1,2}(4:11);
iheadr=deblank(Title{1,2}(12:31));
ititle=deblank(Title{1,2}(32:111));
acycle=Title{1,2}(112:119);
