function [cardsingrp,cards,cards2d]=getcards(inpgrp)


global grpcards;

% Read cards-file
if isempty(grpcards)
	global grpcards
	cardsfile=fopen('/cm/tools/matlab/cm_polin/cards.txt');
	grpcards='';
	i=1;
	while ~feof(cardsfile)
		grpcards=strvcat(grpcards,fgetl(cardsfile));
		i=i+1;
	end
	fclose(cardsfile);
end

% Find subcards in inputgroup
i=strmatch(inpgrp,grpcards(:,1:6));
cardsingrp=strread(grpcards(i,:),'%s','delimiter','=');
if size(cardsingrp,1)>1
	cardsingrp=strread(cardsingrp{2},'%s','delimiter',',');
else
	cardsingrp='';
end


% Get all inputcards
cards=grpcards(:,1:6);


% Get all 2d cards
cards2d='';
for i=1:size(grpcards)
	if grpcards(i,7)=='+'
		cards2d=strvcat(cards2d,grpcards(i,1:6));
	end
end



