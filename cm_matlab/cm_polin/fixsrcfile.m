function newfile=fixsrcfile(srcfil)

% Open file
fid=fopen(srcfil);
file=fread(fid);
fclose(fid);
%
% Remove comments and merge continuation lines
%

% Find lines
po=find(file==10);
po=[1;po;length(file)+1];

% Find comments
com=strfind(char(file)','COMMEN');
com2=strfind(char(file)','!');
com=[com,com2];
com=sort(com);
if ~isempty(com)
	if com(1)==1
		com(2:length(com))=com(2:length(com))-1;
	else
		com=com-1;
	end
end

cleanfile=[];

% Remove comments
for i=1:size(po,1)-1

	% Check if line is comment line
	if ~sum(po(i)==com)
		line=file(po(i):po(i+1)-1);
		
		% Remove comments at end of line
		icom=find(line(9:size(line))=='*');
		icom2=find(line(9:size(line))=='!');
		icom=[icom;icom2];
		if ~isempty(icom)
			line=line(1:icom+7);
		end
		
		% Check for continuation
		icon=find(line=='*');
		if icon
			line=line(9:length(line));
			line=remblank(line);
			cleanfile=[cleanfile(1:length(cleanfile)); line];
		else
			cleanfile=[cleanfile;line];
		end
	else
		i=i+1;
	end
end


%
% Insert content of included files
%

% Find new lines
po=find(cleanfile==10);
po=[1;po;length(cleanfile)+1];

% Find include statement
inc=strfind(char(cleanfile)','INCLUD');
inc=inc-1;

newfile=[];

for i=1:size(po,1)-1
	line=cleanfile(po(i):po(i+1)-1);
	if find(po(i) == inc)
		% Find '='
		ieq=find(line=='=');
		incfile=remblank(line(9:ieq-1));
		newfile=[newfile;10;fixsrcfile(char(incfile)');10];
	else
		newfile=[newfile;line];
	end
end
