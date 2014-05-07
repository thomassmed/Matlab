% function [values]=src2mlab(srcfile ,inpgrp)
%
% Reads data from Polca sourcefile
%.
% Input are path to Polca source file and the name
% of the input group to be read.
%
% Returns array of structs, each struct reprensenting
% one occurance of the input group in the Polca sourcefile.
%
function [values]=src2mlab(srcfile ,inpgrp)

global cards2d;
global cards;
global cardsingrp;

[cardsingrp,cards,cards2d]=getcards(inpgrp);

fid=fopen(srcfile);
inpgrp=upper(inpgrp);

fpos=[];
ngrp=0;


while ~feof(fid),
	card='';
	compline='';
	[compline,card]=readsrcline(fid);
	
	card=upper(card);
	
	switch remblank(card)
		case 'INCLUD'
			if 0<(findstr(compline,inpgrp))
				file=remblank(compline(1:findstr(compline,'=')-1));
				values=src2mlab(file,inpgrp);
			end
			
		case inpgrp
			ngrp=ngrp+1;
			if exist('values') && isnumeric(values) && values==-1
				clear values;
			end
			values(ngrp).(remblank(card))=compline;
			fpos=ftell(fid);
			[compline,card]=readsrcline(fid);
			while card>0 & ~isempty(strmatch(upper(card),cardsingrp))
				card=upper(remblank(card));
				if isfield(values(ngrp),card)
					values(ngrp).(card)=strvcat(values(ngrp).(card),compline);
				else
					values(ngrp).(card)=compline;
				end
				fpos=ftell(fid);
				[compline,card]=readsrcline(fid);
			end
						
		case -1
			% If the card is not found set output to -1
			if ~exist('values')
				values=-1;
			end
			
			clear global cards2d
			clear global cards;
			clear global cardsingrp;
			global grpcards;
			clear global grpcards;
			
			fclose(fid);
			return;
	end
	if ~isempty(fpos)
		fseek(fid,fpos,'bof');
		fpos=[];
	end
end


fclose(fid);
