function islash=find_eocard(card)
%
%

%%
icount=1;
blip=find(card(icount:end)==39);
slash=find(card(icount:end)=='/');
while blip(1)<slash(1),
    icount=icount+blip(2);
    blip=find(card(icount:end)==39);
    slash=find(card(icount:end)=='/');
    if length(blip)<2, break;end
end
islash=icount+slash(1)-1;