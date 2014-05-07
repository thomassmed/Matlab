function expr_create()

exprfile = [prefdir filesep 'vamos_saved_expressions.mat'];

if fopen(exprfile) > 0
	load(exprfile);
	expressions(length(expressions)+1) = expr_createdlg();
	save(exprfile,'expressions');
else
	expressions(1) = expr_createdlg();
	save(exprfile,'expressions');
end





function [expr] = expr_createdlg()

promptstrings = {'Expression label:'; ...
				 'Number of variables in expression:'; ...
				 'Expression: (Use a,b,c.... for variablenames)' ...
				 };
				 
input = inputdlg(promptstrings);

expr.label = char(input{1});
expr.nvar = str2num(input{2});
expr.string = char(input{3});

