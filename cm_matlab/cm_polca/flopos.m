%@(#)   flopos.m 1.3	 97/11/04     08:39:25
%
%function [chnum,knam]=flopos(unit)
%
%  Input: 'F1'/'F2'/'F3'
%  Output: channel number in SYMME 1 for:
%  211K   301  311  302  312  303  313  304  314           
%
function [chnum,knam]=flopos(unit)
unit=upper(unit);
if unit=='F1'|unit=='F2'
%  211K   301  311  302  312  303  313  304  314           
  chnum=[ 150  226  578  396  654  495   65  239];
  knam=[
        '211K301'
        '211K311'
        '211K302'
        '211K312'
        '211K303'
        '211K313'
        '211K304'
        '211K314'];
elseif unit=='F3'
  chnum=[62 175 238 247 404 473 507 592 ];
  knam=['KA302'
        'KB302'
        'KA301'
        'KB301'
        'KD301'
        'KC301'
        'KC302'
        'KD302'];
end
