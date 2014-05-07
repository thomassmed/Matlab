function [sc,str]=GetScale(str)
isc=strfind(str,'REAL VALUE');
if isc,
    scaling=str(isc:end);
    istar=strfind(scaling,'*');
    ieq=strfind(scaling,'=');
    sc=sscanf(scaling(istar+1:ieq-1),'%g');
    str=str(1:isc-1);
else
    isc=strfind(str,'Renorm');
    if isc,
        scaling=str(isc(1)+9:isc(1)+24);
        sc=sscanf(scaling,'%g');
    else
        sc=1;
    end
end

    