function expr_list(exprmenuh,hObject)

exprfile = [prefdir filesep 'vamos_saved_expressions.mat'];

handles = guidata(hObject);

% Ful-lösning för att uppdatera menyn
delete(handles.Saved_expressions);
exprmenuh = uimenu(handles.Expressionsmenu,'Tag','Saved_expressions','Label','Saved expressions','Separator','on');
handles.Saved_expressions = exprmenuh;

if fopen(exprfile) > 0
	load(exprfile);
	
	for i=1:length(expressions)
		uimenu(exprmenuh,'Label',expressions(i).label,'Callback',{@expr_apply,i});
	end

end

guidata(hObject,handles);
