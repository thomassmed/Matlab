function [srcvalues]=readsrcdata(srcdata)

%[cardsingrp,cards,cards2d]=getcards('ASMBLY');

cardspath=which('readsrcdata');
carddata=cards2mat([cardspath(1:length(cardspath)-13) 'cards_new.txt']);
cards=char(carddata{:,1});
cards2d=cards(find(cell2mat(carddata(:,2))==1),:);

file=srcdata;

% Find lines
po=find(file==10);
po=[1;po];

% Initialize some variables;
srcvalues=[];
maincard=[];

% Needed for special threatment of card ASYTYP 
asytypcards=['ASMBLY';'CPRMIN';'PCILIM'];

ii=1;
while ii<size(po,1)

	% Reset some variables;
	ngrp=1;
	card='';
	compline='';
	
	% Get one line from the file, special handling of first line in file
	if po(ii)==1
		line=char(file(po(ii):po(ii+1)-1)');
	else
		line=char(file(po(ii)+1:po(ii+1)-1)');
	end
	% If line is empty -> read next line
	while isempty(line) | ~sum(~isspace(line))
		ii=ii+1;
		line=char(file(po(ii)+1:po(ii+1)-1)');
	end
	
	% Read input card from current line
		if size(line,2)>=6
			card=line(1,1:6);
		else
			card=remblank(upper(line(1:size(line,2))));
		end
		% Check if 2d or 1d card (Special threatment of card ASYTYP)
		if  (strmatch(upper(card), 'ASYTYP') & isempty(strmatch(maincard,asytypcards))) | ~isempty(strmatch(upper(card), cards2d))
			% Start reading first line of map
			maincard=[];
			testlength=6;
			ii=ii+1;
			line=char(file(po(ii)+1:po(ii+1)))';
			while ~isspace(line) | isempty(~strmatch(upper(line(1:testlength)), cards))
				compline=strvcat(compline,char(line(1:size(line,2)-1)));
				% Read next line of map
				ii=ii+1;
				line=char(file(po(ii)+1:po(ii+1)))';
				if size(line,2)<6
					testlength=size(line,2);
				else
					testlength=6;
				end
			end
			% Finished reading core map, Reread this line in next iteration
			ii=ii-1;
		
		% Read non 2d card
		else
			if ~isempty(strmatch(maincard,'TITLE '))
				compline=line(8:size(line,2));
			else
%				compline=remblank(line(8:size(line,2)));
				compline=line(8:size(line,2));
			end
		end
		
	
	
	
	% Storing of input cards in master struct
	if isempty(maincard) 
		% Get subcards of current card
		maincard=remblank(upper(card));
		
%		[cardsingrp,cards,cards2d]=getcards(upper(maincard));
		cardsingrp=char(strread(char(carddata(strmatch(maincard,cards),3)),'%s','delimiter',','));
		
		% Check if field already exsist in struct, if true -> add new post in card-array
		if isfield(srcvalues,(maincard))
			ngrp=size(srcvalues.(remblank(upper(card))),2);
			ngrp=ngrp+1;
		end
		
		% Add maincard to group
		srcvalues.(remblank(maincard))(ngrp).(remblank(maincard))=compline;
	else	
		% Check if card is subcard
		if ~isempty(strmatch(upper(card),cardsingrp))
			% Get element in array to which the subcard should be added
			if isfield(srcvalues,(maincard))
				ngrp=size(srcvalues.(remblank(upper(maincard))),2);
			end
			
			card=remblank(card);
			
			% Check if subcard isfield, if true -> vcat
			if isfield(srcvalues.(maincard)(ngrp),card)
				srcvalues.(maincard)(ngrp).(card)=strvcat(srcvalues.(maincard)(ngrp).(card),compline);
			else
				srcvalues.(maincard)(ngrp).(card)=compline;
			end
		else
			% If no more subcards in group, reset maincard, reread new maincard in next iteration
			maincard=[];
			ii=ii-1;
		end
	end
	
ii=ii+1;
end

clear global cards,cards2d;
