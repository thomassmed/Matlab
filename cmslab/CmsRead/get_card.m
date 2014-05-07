function record=get_card(blob,card)
% Read one card from input file
%
% record=get_card(blob,card)
% 
% Input
%   blob     - string read from file with fread  OR
%   filename - name of ASCII-file to be read from (.txt)
%
% Output
%   record   - The read record. record is a cell-array, use record{1}, record{2} etc to get
%              access to the elements.  Note: use curly {} parantheses.
%
%
% Examples: 
% record=get_card('s3.inp','LIB');
% If you plan to read many cards, it is more efficient to use read_simfile first: 
% blob=read_simfile('s3.inp');record=get_card(blob,card);
% More examples, to get access to the card:
% DIM_CAL=get_card('s3-case-1.txt','DIM.CAL');
% kmax=DIM_CAL{1};iwant=DIM_CAL{2};IF2X2=DIM_CAL{3};
%
% See also get_mcard, get_num_card, read_restart_bin, read_simfile,
%          cell array
%          
%                                                     

% Copyright Studsvik Scandpower 2007

%%
if isempty(find(blob==10,1)), %Assume that filename is given
    blob=read_simfile(blob);
end
if abs(card(1))~=39, card=['''',card,'''']; end
card=char([10,card]);      % Ensure that the card is right after a <CR>
i_card=strfind(blob,card);
if isempty(i_card),
    record={};
else
    card_length=length(card);
    icard=i_card(1);        
    islash=find_eocard(blob(icard+length(card):end));
    card_str=blob(icard+length(card):islash+icard+length(card)-2);
    record=parse_card(card_str);
    for i=2:length(i_card), % Take overwrite cards into account
        icard=i_card(i);
        islash=find_eocard(blob(icard+length(card):end));
        card_str=blob(icard+length(card):islash+icard+length(card)-2);
        rec=parse_card(card_str);
        for j=1:length(rec),
            if ~isempty(rec{j}),
                record{j}=rec{j};
            end
        end
    end       
end

function record=parse_card(card_str)

if isempty(card_str), record=[];return;end
iarg=0;
card_str=strrep(card_str,char(9),' '); % Replace tabs with space
card_str=rem_2blanks(card_str); % Make sure only one space comes at a time
card_str=remleadblank(card_str);
card_str=rem_blankcomma(card_str); % replace all " ," with ","
card_str=rem_commablank(card_str); % replace all ", " with ","
if isempty(card_str), record=[];return;end
if strcmp(card_str(1),','), card_str(1)=[];end
while ~isempty(card_str),
    card_str=remleadblank(card_str);
    if isempty(card_str), break;end                % Take care of trailing blanks and commas
    iarg=iarg+1;
    if abs(card_str(1))==39,                       % Next record in the card is a string
        nextblip=min(strfind(card_str(2:end),''''))+1;
        record{iarg}=card_str(2:nextblip-1);
        card_str(1:nextblip)=[];
    else                                           % Next record in the card is a number
        nextblank=min(strfind(card_str,' '));
        nextcomma=min(strfind(card_str,','));
        if isempty(nextblank)&&~isempty(nextcomma),
            next_del=nextcomma;
        elseif isempty(nextblank)&&isempty(nextcomma),
            next_del=length(card_str);
        elseif ~isempty(nextblank)&&isempty(nextcomma),
            next_del=nextblank;            
        elseif ~isempty(nextblank)&&~isempty(nextcomma),
            next_del=min(nextblank,nextcomma);
        end
        h=sscanf(card_str(1:next_del),'%g');
        record{iarg}=h;
        card_str(1:next_del)=[];
    end
end
