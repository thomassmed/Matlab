% function [line,inpcard]=readsrcline(fid)
%
% Reads one line from the sourcefile,
% also handles continuation lines marked by a "*" in the seventh column.
% If the "COMMEN" card if found then it continues to the next line.
% 
% Function uses the global cards2d-variable to detect whether it should
% read a 2d core map or standard free form format.
%
function [line,inpcard]=readsrcline(fid)
	global cards2d;
	global cards;
	
	% Get one line from the file
	line=fgetl(fid);
	
	% Check if "end of file"
	if size(line,2)<=0,
		line=-1;
		inpcard=-1;
		return;
	end
	
	% Check if line is a comment or empty, stop reading if "end of file" is found
	while ~sum(~isspace(line)) | isempty(line) | (strcmp(line(1),'!')) | ((size(line,2)>6) & strcmp(upper(line(1:6)),'COMMEN')),
		if line<0
			line=-1;
			inpcard=-1;
			break;
		end
		line=fgetl(fid);
	end
	
	% Read input card from current line
	if size(line,2)>=6, inpcard=line(1:6);
	else inpcard=remblank(upper(line(1:size(line,2))));
	end

	% Check if to read 2D core map
	if strmatch(upper(inpcard), cards2d) & (isempty(line(7:size(line,2))) | isspace(line(7:size(line,2)))) | strcmp(upper(inpcard),'CONROD'),
		line='';
		nextline=fgetl(fid);
			while isempty(strmatch(nextline(1:6),cards)) & ~strcmp(nextline(1:6),'COMMEN') & ~strcmp(nextline(1),'!')
				line=strvcat(line,nextline);
				if feof(fid)
					break;
				end
				fpos=ftell(fid);
				nextline=fgetl(fid);
			end
		if ~isempty(strmatch(nextline(1:6),cards))
			fseek(fid,fpos,'bof');
		end
		return;
	end
	
	% Read free form as default
	fpos=ftell(fid);
	nextline=fgetl(fid);
	fseek(fid,fpos,-1);
	if (nextline>0) & (size(nextline,2)>7) & strcmp(nextline(7),'*'),
		line=[stripline(line) ' ' readsrcline(fid)];
	else
		line=stripline(line);
	end
