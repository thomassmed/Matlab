%@(#)   history.m 1.1	 05/07/13     10:29:33
%

function [dist, storlek] = history(i)

distnames = ['BURNUP '
'BURSID '
'BURCOR '
'DNSHIS '
'CRHIS  '
'CRHFRC '
'CREIN  '
'CREOUT '
'EFPH   '
'U235   '
'U236   '
'U238   '
'Np239  '
'Pu239  '
'Pu240  '
'Pu241  '
'Pu242  '
'Am241  '
'Am242  '
'Ru103  '
'Rh103  '
'Rh105  '
'Ce143  '
'Pr143  '
'Nd143  '
'Nd147  '
'Pm147  '
'Pm148  '
'Pm148m '
'Pm149  '
'Sm147  '
'Sm149  '
'Sm150  '
'Sm151  '
'Sm152  '
'Sm153  '
'Eu153  '
'Eu154  '
'Eu155  '
'Gd155  '
'BAeff  '
'CREFPH '
'CRDEPL '
'CRFLUE '
'PRMEFPH'
'PRMU234'
'PRMU235'
'BOXEFPH'
'BOXFLU '];

storlek = size(distnames,1);

if nargin > 0
	dist = remblank(distnames(i,:));

else
	dist = -1;

end

