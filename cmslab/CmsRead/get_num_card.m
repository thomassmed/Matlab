function value=get_num_card(blob,card)
% Reads one card with only numbers as inputs
% value=get_num_card(blob,card)
if abs(card(1))~=39, card=['''',card,'''']; end
card=char([10,card]);             % Ensure that the card is right after a <CR>
i=strfind(blob,card);
if isempty(i), %Try insert a space first (for .out-files)
    card(1)=[];card=[10 32,card];
    i=strfind(blob,card);
end
card_length=length(card);
if isempty(i),
    value=[];
    return
end
i=i(length(i));                 %Take the last card in the blob (in case there are ovewrite-cards)
slash=find(blob=='/');
islash=find(slash>i(1), 1 );
card_str=blob(i(1)+card_length:slash(islash)-1);
value=sscanf(card_str,'%g');
