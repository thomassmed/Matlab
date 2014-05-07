%@(#)   axis2cpos.m 1.1	 05/07/13     10:29:27
%
%
%function cpos=axis2cpos(axstr)
%
% Returns coreposition for given coordinates.
% example cpos=axis2cpos('18MM');
% gives cpos=[18 3]
function cpos=axis2cpos(axstr)

while length(axstr)<4, axstr=[axstr ' '];end

jvecstr=['13'
      '16'
      '18'
      '21'
      '23'
      '26'
      '28'
      '31'
      '33'
      '36'
      '38'
      '41'
      '43'
      '46'
      '48'
      '51'
      '53'
      '56'
      '58'
      '61'
      '63'
      '66'
      '68'
      '71'
      '73'
      '76'
      '78'
      '81'
      '83'
      '86'];
jj=[100 1]';
jvec=abs(jvecstr)*jj;
ivecstr=['XP'
         'XM'
         'VP'
         'VM'
         'UP'
         'UM'
         'TP'
         'TM'
         'SP'
         'SM'
         'RP'
         'RM'
         'PP'
         'PM'
         'OP'
         'OM'
         'MP'
         'MM'
         'LP'
         'LM'
         'KP'
         'KM'
         'IP'
         'IM'
         'HP'
         'HM'
         'GP'
         'GM'
         'FP'
         'FM'];
ivec=abs(ivecstr)*jj;
axi=abs(axstr(3:4))*jj;
cpi=find(ivec==axi);
if length(cpi)>0
  axj=abs(axstr(1:2))*jj;
  cpj=find(jvec==axj);
  if length(cpj)>0
     cpos=[cpi cpj];
  else
     cpos=[0 0];
  end
else
  cpos=[0 0];
end
