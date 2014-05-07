function prep_compare2
prompt={'Enter first matlab variable:','Enter second matlab variable:'};
matvar=inputdlg(prompt,'Input for compare2',2);
if ~isempty(matvar),
    evalstr=['compare2(',matvar{1},',',matvar{2},');']; 
    evalin('base',evalstr);
end