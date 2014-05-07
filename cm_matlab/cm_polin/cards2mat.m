function cards=cards2mat(cardsfile)

[card,map,cardsingrp]=textread(cardsfile,'%s%s%s','delimiter',':');

a = find(char(map)=='+');
map = zeros(length(map),1);
map(a) = 1;

cards = [card num2cell(map) cardsingrp];
