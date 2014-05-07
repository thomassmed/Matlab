function printsrcline(fid,card,line)

LINELENGTH=80; % Max längd på rad i sourcefilen

c=1;

for m=1:size(line,2)
	if c>LINELENGTH & strcmp(line(1,m-1),',')
		space1=char(ones(1,(6-size(card,2)))*32);
		cont=[card,space1,'*',' '];
		fprintf(fid,'\n%s',cont);
		c=1;
	end
	
	if  c>1 & m>1 & strcmp(line(1,m-1),',')
		fprintf(fid,' %c',char(line(1,m)));
	else
		fprintf(fid,'%c',char(line(1,m)));
	end
	
	c=c+1;
end
fprintf(fid,'\n');
