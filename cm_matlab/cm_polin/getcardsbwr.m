function [cards,file]=getcardsbwr()




% Read cards-file
cardsfile=fopen('/cm/tools/matlab/cm_polin/cardsbwr.txt');
grpcards='';
i=1;
while ~feof(cardsfile)
	grpcards=strvcat(grpcards,fgetl(cardsfile));
	i=i+1;
end
fclose(cardsfile);



% Get all inputcards
cards=grpcards(:,1:6);
file=grpcards(:,8:12);




