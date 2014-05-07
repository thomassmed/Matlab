function card_str=rem_2blanks(card_str)
%%
while min(diff(strfind(card_str,' ')))<2,
    card_str=strrep(card_str,'  ',' ');
end