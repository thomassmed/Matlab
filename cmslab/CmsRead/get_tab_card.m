function tab=get_tab_card(blob,card,ntab)
% get_card Read card on tabel format
%
% tab=get_tab_card(blob,card,ntab)
% 
% Input
%   blob     - string read from file with fread  OR
%   filename - name of ASCII-file to be read from (.txt)
%   ntab     - number of variables in table, default=2
% Output
%   tab      - The read table #of values/varible times # of variables (ntab)
%
%
% Examples: 
% pumphead=get_tab_card('s3k.inp','PER.PCV');
% If you plan to read many cards, it is more efficient to use read_simfile first: 
% blob=read_simfile('s3.inp');table=get_card(blob,card);
%
% See also get_mcard, get_num_card, read_restart_bin, read_simfile
%          see also cell array
%          
%                                                     

% Copyright Studsvik Scandpower 2007

%%
if nargin<3, ntab=2; end
if isempty(find(blob==10,1)), %Assume that filename is given
    blob=read_simfile(blob);
end
if abs(card(1))~=39, card=['''',card,'''']; end
card=char([10,card]);      % Ensure that the card is right after a <CR>
i=strfind(blob,card);
card_length=length(card);
icard=i(length(i));        % Take the last card in the blob (in case there are ovewrite-cards)
if isempty(i),
    records=[];
else
    slash=find(blob=='/');
    islash=find(slash>icard,1);                         % Find first '/' after the card
    card_str=blob(icard+card_length:slash(islash)-1);
    idel=get_del(card_str);
    card_str(idel)=32;
    card_str=char(card_str);
    card_str=card_str(idel(1)+1:end);
    value=sscanf(card_str,'%g');
    for i=1:ntab,
        tab(:,i)=value(i:ntab:end);
    end
end

