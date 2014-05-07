%@(#)   sok.m 1.2	 10/09/09     10:43:32
%


function f = sok

hand=get(gcf,'userdata');
h=get(hand(1),'userdata');
sokt=get(hand(2),'string');
delete(gcf);

%handles = get(gcf, 'userdata');
%hM = get(handles(6), 'userdata');
%plvec = get(hM, 'userdata');
%rita = plvec;

curfile = setprop(5);
[asyid, mminj] = readdist7(curfile, 'asyid');

l = length(sokt);
if l == 5
	sokt = sprintf('%s%s', sokt, char(32));
end


knum = strmatch(sokt, asyid);
pixpos = [];
if ~isempty(knum)
	pixpos=knum2cpos(knum,mminj);
else
	fprintf(1, '\n\nDen sökta patronen finns inte i härden.\n\n');
end
	
	

if ~isempty(pixpos)
    p=pixpos;
    X=[p(2)+.2 p(2)+.9 p(2)+.9 p(2)+.2];
    Y=[p(1)+.2 p(1)+.2 p(1)+.9 p(1)+.9];
    h = patch(X,Y, [0.7, 0.2, 1.0]);
    pause(5);
    delete(h);
    
end








