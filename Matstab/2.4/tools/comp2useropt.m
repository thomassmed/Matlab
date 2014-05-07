function opt=comp2useropt(compfile)
fid=fopen(compfile);

opt=msoptset;
rad=fgetl(fid);
while rad~=-1
  icomm=findstr(rad,'%');
  if length(icomm)>0, rad=rad(1:min(icomm)-1); end
  if length(remblank(rad))>0,
     idel=[findstr(rad,9),findstr(rad,32)];
     field=sscanf(rad(1:min(idel)-1),'%s');
     rad=rad(min(idel):end);
     if ~isfield(opt,field),
         disp('**************************************************************************');
	 disp(['Warning: ',field,' is not recognized as an option']);
	 disp(['Type help msoptset and check for spelling and use of upper and lower case']);
         disp('**************************************************************************');
     else
         val=getfield(opt,field);
	 if ischar(val)|length(val)==0,
	     new_value=sscanf(rad,'%s');
	 else
	     new_value=eval(rad);
         end
	 opt=msoptset(opt,field,new_value);
     end
     rad=remblank(rad(min(idel):end));
  end
  rad=fgetl(fid);
end
