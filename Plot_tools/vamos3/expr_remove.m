function expr_remove()

exprfile = [prefdir filesep 'vamos_saved_expressions.mat'];

if fopen(exprfile) > 0
	load(exprfile);
	
	for i=1:length(expressions)
		liststr(i) = {expressions(i).label};		
	end
	
	[selexpr,ok] = listdlg('ListString',liststr,'SelectionMode','single','Name','Select expressions to remove');
	if (ok == 1)
		if (selexpr == 1)
			if length(expressions) > 1
				expressions = expressions(2:end);
				save(exprfile,'expressions');
			else
				delete(exprfile);
			end
		elseif (selexpr == length(expressions))
			expressions = expressions(1:end-1);
			save(exprfile,'expressions');
		else
			expressions = expressions([1:selexpr-1 selexpr+1:end]);
			save(exprfile,'expressions');
		end
	end
end
