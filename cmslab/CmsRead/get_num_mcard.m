function A=get_num_mcard(blob,card,matrix_out)
% A=get_num_mcard(blob,card)
% 
% Read multiple cards with only numbers as inputs
if nargin<3, matrix_out=0; end
if abs(card(1))~=39, card=['''',card,'''']; end
card=setstr([10,card]);        % Ensure that the card is right after a <CR>
i=strfind(blob,card);
if isempty(i),
    crd=strrep(card,char(10),'');
    warning(['Card ',crd,' not found']);
    A=[];
    return;
end
card_length=length(card);
slash=find(blob=='/');
                                % pick up the first numerical string
islash=find(slash>i(1), 1 );
card_str=blob(i(1)+card_length:slash(islash)-1);
ii=strfind(card_str,',');card_str(ii)=32*ones(size(ii));
A{1}=sscanf(card_str,'%g');
for j=2:length(i),
  islash=min(find(slash>i(j)));
  card_str=blob(i(j)+card_length:slash(islash)-1);
  ii=strfind(card_str,',');card_str(ii)=32*ones(size(ii));
  A{j}=sscanf(card_str,'%g');
end
if matrix_out,
    for j=1:length(A),
        AA(:,j)=A{j};
    end
A=AA';
end
    

        