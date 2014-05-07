% Get delimiter from card
%
% idel=get_del(card_str)
function idel=get_del(card_str)
icr=find(card_str==10);
icomma=strfind(card_str,',');
idel=sort([icr icomma]);
