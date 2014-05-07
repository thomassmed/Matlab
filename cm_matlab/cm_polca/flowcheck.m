%@(#)   flowcheck.m 1.3	 05/12/08     10:31:35
%
%function [kanflow,kanname,fleak2]=flowcheck(unit,distfile)
%
%
%  In:  unit name (string), e.g. 'F1','f1','F2'
%       distfile - distribution file name (string)
%  Out: kanflow: Flow in flow measurement position
%       kanname: Result including name on flow measurement position (string)
%       If no distfile is specified  /cm/fx/onl/fx-pdistr.dat is used
%
function [kanflow,kanname,fleak2]=flowcheck(unit,distfile)
if isstr(unit)
  unit=lower(unit);
  UNIT=upper(unit);
  if strcmp(unit,'f1')|strcmp(unit,'f2')|strcmp(unit,'f3')
     if nargin<2
       distfile=['/cm/',unit,'/onl/',unit,'-pdistr'];
     end
     [chflow,mminj]=readdist7(distfile,'chflow');
     [chnum,knam]=flopos(UNIT);
     kanflow=(chflow(chnum))';
     if nargout>2,
       flk2=readdist7(distfile,'FLEAK2');
       fleak2=(flk2(chnum))';
     end
     for i=1:length(chnum),
       stfl=sprintf('%5.2f',kanflow(i));
       if nargout>2,
         stfl=sprintf('%5.2f%7.2f',kanflow(i),fleak2(i));
       end
       kanname(i,:)=[knam(i,:),'  ',stfl];
     end
   else
     disp(['No such unit:',UNIT]);
   end
else
   disp(['Input variable must be a string'])
end
