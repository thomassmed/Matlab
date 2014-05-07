% function printsrcdata(srcdata,srcfile)
%
% Prints all input-cards from the source-struct in matlab
% to ASCII-file in Polca-input format
%
function printsrcdata(srcdata,srcfile)



[cards file]=getcardsbwr();


fid1=fopen(['reac_',srcfile],'w');
fid2=fopen(['fuel_',srcfile],'w');


for i=1:size(cards,1);
	card=remblank(cards(i,:));
	if isfield(srcdata,card)
	carddata=srcdata.(card);
	subcards=fieldnames(carddata);
	
	i2=strmatch(card,cards,'exact');
	f=file(i2,:);
	if strcmp(remblank(f),'fuel')
		fid=fid2;
	else
		fid=fid1;
	end
	
	
	for j=1:size(carddata,2)
		fprintf(fid,'COMMENT ---------------------  %s  %d  ---------------------\n',card,j);
		for n=1:size(subcards,1)
			subcarddata=carddata(j).(subcards{n,:});
			if 1<=size(subcarddata) | strcmp(card,subcards{n,:})

				% Fixa space and label
				if (size(subcarddata,1) > 1) & isempty(findstr(subcarddata(1,:),','))
					subcarddata=[ones(size(subcarddata,2),1)*32,subcarddata']';
					label=[subcards{n,:};char(ones(size(subcarddata,1)-1,size(subcards{n,:},2))*32)];
					space=char(ones(size(subcarddata,1),2+(6-size(subcards{n,:},2)))*32);
				else
					label=subcards{n,:};
					space=char(ones(1,2+(6-size(subcards{n,:},2)))*32);
				end
				
				
				if (size(subcarddata,1) > 1) & isempty(findstr(subcarddata(1,:),','))
					output=[label,space,subcarddata];
					for m=1:size(output,1)
						fprintf(fid,'%s\n',char(output(m,:)));
					end
				else
					for m=1:size(subcarddata,1)
						output=[label,space,remblank(subcarddata(m,:))];
						printsrcline(fid,subcards{n,:},output);
					end
				end
			end
		end
		fprintf(fid,'COMMENT -------------------------------------------------------\n');
		fprintf(fid,'\n');
	end
	fprintf(fid,'\n');
	end
end

fclose(fid1);
fclose(fid2);

