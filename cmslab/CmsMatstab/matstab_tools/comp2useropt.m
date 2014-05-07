function opt=comp2useropt(compfile)
fid=fopen(compfile);

opt=set_msopt;
field_names=fieldnames(opt);
rad=fgetl(fid);
while rad~=-1
  icomm=findstr(rad,'%');icomm=[icomm,findstr(rad,'!')];
  if ~isempty(icomm), rad=rad(1:min(icomm)-1); end
  if ~isempty(remblank(rad)),
     idel=[findstr(rad,9),findstr(rad,32)];
     field=sscanf(rad(1:min(idel)-1),'%s');
     rad=rad(min(idel):end);
     ifield=find(strcmpi(field_names,field),1);
     if isempty(ifield),
        disp('**************************************************************************');
        disp(['Warning: ',field,' is not recognized as an option.']);
        disp('The statement:');
        disp([field,' ',rad]);
        disp(['in file ',compfile,' will be ignored.']);
        disp('Type set_msopt in matlab command window to see your options.');
        disp('**************************************************************************');
     else
         val=getfield(opt,field_names{ifield});
        if ischar(val)||isempty(val),
            new_value=sscanf(rad,'%s');
        else
            new_value=eval(rad);
        end
        opt=set_msopt(opt,field,new_value);
     end
     rad=remblank(rad(min(idel):end));
  end
  rad=fgetl(fid);
end
