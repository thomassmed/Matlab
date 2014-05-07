% function [srcvalues]=readsrcfile(varargin)
%
% Reads all data from Polca source file
%
% Input are path to Polca source-file
%
% Returns a struct with arrays of structs in which subcards are represented.
% Each struct in the arrays represents
% one occurance of the input group in the Polca sourcefile.
%
function [srcvalues]=readsrcfile(varargin)

global cards;
global cards2d;

[cardsingrp,cards,cards2d]=getcards('ASMBLY');


fid=fopen(varargin{1});

fpos=[];
ngrp=1;


while ~feof(fid),
	card='';
	compline='';
	[compline,card]=readsrcline(fid);
	
	maincard=remblank(upper(card));
	
	switch maincard
		case 'INCLUD'
			file=remblank(compline(1:findstr(compline,'=')-1));
			a=readsrcfile(file);
			b=fieldnames(a);
			for i=1:size(b)
				srcvalues.(b{i})=a.(b{i});
			end
			
						
		case -1
			clear global cards, 
			clear global cards2d;
			global grpcards;
			clear global grpcards;
			return;
			
		otherwise
			[cardsingrp,cards,cards2d]=getcards(upper(maincard));
			
			if size(varargin)==2
				srcvalues=varargin{2}
			end
			
			if ~exist('srcvalues') 
				srcvalues=0;
			end
			if isfield(srcvalues,(maincard))
				ngrp=size(srcvalues.(maincard),2);
				ngrp=ngrp+1;
			end
			
			
			
			srcvalues.(maincard)(ngrp).(remblank(maincard))=compline;
			fpos=ftell(fid);
			[compline,card]=readsrcline(fid);
			while card>0 & ~isempty(strmatch(upper(card),cardsingrp))
				card=upper(remblank(card));
				if isfield(srcvalues.(maincard)(ngrp),card)
					srcvalues.(maincard)(ngrp).(card)=strvcat(srcvalues.(maincard)(ngrp).(card),compline);
				else
					srcvalues.(maincard)(ngrp).(card)=compline;
				end
				fpos=ftell(fid);
				[compline,card]=readsrcline(fid);
			end
			ngrp=1;
			
	end
	if ~isempty(fpos)
		fseek(fid,fpos,'bof');
		fpos=[];
	end
end


fclose(fid);
