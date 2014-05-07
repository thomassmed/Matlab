%@(#)   sfg2pool7.m 1.1	 05/07/13     10:29:41
%

%function sfg2pool7


function sfg2pool7;

hand=get(gcf,'userdata');
h=get(hand(1),'userdata');
sfgfil=get(hand(2),'string');
delete(gcf);





text=readtextfile(sfgfil);
[sm, sn] = size(text);

j=1;




for i = 2:1:sm
	
	if strcmp(text(i,6), ',') & (strcmp(text(i,7), 'P') | strcmp(text(i,7), 'B') | strcmp(text(i, 6:10), ',,,,,'))
		
		pos(j,1:5) = text(i, 1:5);
		aret = '';
		if strcmp(text(i, 6:10), ',,,,,')
			id = '';
			box = '';
			
		
		elseif strcmp(text(i,7), 'B')
			kommapos = find(text(i,:) == ',');
			id = '';
			box = text(i, kommapos(2)+1:kommapos(3)-1);
			
		
		
		
		else
			kommapos = find(text(i,:) == ',');
			id = text(i, kommapos(2)+1:kommapos(3)-1);
			box = text(i, kommapos(3)+1:kommapos(4)-1);
			
		end
		
		lid = length(id);	
		asyid(j,1:16) = sprintf('%s%s',id, setstr(32*ones(1,16-lid)));
		
		lbox = length(box);	
		pbox(j,1:9) = sprintf('%s%s',box,setstr(32*ones(1,9-lbox)));
		
		
		
		j = j + 1;
	
	
		
	end

end



evstr=['save ' 'poolfil.mat' ' pos asyid pbox'];
eval(evstr);

fprintf(1, '\n\nPoolfilen som skapas har fått namnet poolfil.mat\n\n');
