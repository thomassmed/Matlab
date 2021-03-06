function [mdkpunkt,real_kpunkt]=read_mdtabell(Y,M,D)
% [mdkpunkt,real_kpunkt]=read_mdtabell(config);
% [mdkpunkt,real_kpunkt]=read_mdtabell(Y,M,D);
% This function only applies for Forsmark 3.
% mdkpunkt is the name of real_kpunkt in the measuring computer 
% config refers to the configuration of LPRM connected to the measuring computer
% setup can be either: 
% A as used 9606- -990909
%   or 
% B as used 93-9606 and 990909- 
% default is B
% alternatively a date can be given.
%   93   940730    960619   990909
%    | B   |   B     |   A    |  B                     


if nargin==0, 
  warning('No date or config given, LPRM config as of 990909 will be used')
  Y=1999; M=9; D=9;
end
if ischar(Y) 
  %input is config, not a date
  config=upper(Y);
else
  % do some checking in arguments
  if ~exist('M','var'), error('Bad arguments'), end
  if ~exist('D','var'), D=00; end
  if Y<1900, % only using 2 digits for year!
    if Y>80, Y=1900+Y; else Y=2000+Y; end
  end
  date=datenum(Y,M,D);
  % find config at date
  if date<datenum(1994,07,30)       % stabmon installed
     % Antar att kopplingarna var likadana 93 som 94 n�r stabmon installerades.
     % Det �r inte s�kert men jag har inte lyckats kolla upp datta mer. /vdb 00-06-07
    config='B';    
  elseif date<datenum(1996,06,19)  % TEPCO measurments
    config='B';    
  elseif date<datenum(1999,09,09)  % reset to stabmon config
    config='A';
  else
    config='B';
  end
end

tabell=[...
% 
'531KA791  531KA733   531KA733'
'531KA792  531KA734   531KA734'
'531KA793  531KA735   531KA712'
'531KA794  531KA736   531KA720'
'531KB791  531KB705   531KB705'
'531KB792  531KB706   531KB706'
'531KB793  531KB707   531KB708'
'531KB794  531KB708   531KB724'
'531KC791  531KC725   531KC725'
'531KC792  531KC726   531KC726'
'531KC793  531KC727   531KC708'
'531KC794  531KC728   531KC720'
'531KD791  531KD717   531KD717'
'531KD792  531KD718   531KD718'
'531KD793  531KD719   531KD728'
'531KD794  531KD720   531KD720'];
mdkpunkt=tabell(:,1:8);

switch config
  case 'A'
    real_kpunkt=tabell(:,11:18);
  otherwise
    real_kpunkt=tabell(:,22:29);
end
