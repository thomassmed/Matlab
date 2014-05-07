function records=get_mcardj(blob,card)
% records=get_mcardj(blob,card)
% 
% Read multiple cards
if abs(card(1))~=39, card=['''',card,'''']; end
card=char([10,card]);        % Ensure that the card is right after a <CR>
i=strfind(blob,card);
card_length=length(card);
slash=find(blob=='/');
for j=1:length(i),
  iarg=0;    
  islash=min(find(slash>i(j)));
  card_str=blob(i(j)+card_length:slash(islash)-1);
  while length(card_str)>0,
    card_str=remleadblank_comma(card_str);
    if isempty(card_str), break;end                     % Take care of trailing blanks and commas
    iarg=iarg+1;                                        % Update output argument number
    if abs(card_str(1))==39,                            % Next record in the card is a string
       nextblip=min(strfind(card_str(2:end),''''))+1;
       records{j}{iarg}=card_str(1:nextblip);
       card_str(1:nextblip)=[];
    else                                                % Next record in the card is a number
       nextblank=min(strfind(card_str,' '))-1;
       nextcomma=min(strfind(card_str,','))-1;
       if isempty(nextblank)&&~isempty(nextcomma), 
           nextblank=nextcomma; 
       elseif isempty(nextblank)&&isempty(nextcomma),
           nextblank=length(card_str);
       elseif ~isempty(nextblank)&&~isempty(nextcomma),
           nextblank=min(nextblank,nextcomma);
       end
       h=sscanf(card_str(1:nextblank),'%g');
       records{j}{iarg}=h;
       %eval(['arg',num2str(iarg),'(j)=h;']);
       card_str(1:nextblank)=[];
    end
  end
end
for j=iarg+1:nargout,                                   % In case more output arguments are given in the call than arguments assigned
    eval(['arg',num2str(j),'=[];']);
end

        