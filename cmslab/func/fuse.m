function func_list=fuse(func_list,mhome)
% func_list=fuse(fun)
% find functions used in function fun
% skips functions in matlabs own toolboxes, 
% i.e skip path defined by $MATLAB (/usr/prods/matlab at FKA)



if nargin<2, 
 %skicka med mhome, slipper anropa unix i varje rekursion
  [stat,mhome]=unix('echo $MATLAB'); 
  mhome=mhome(1:end-1); % ta bort eol
end

func=deblank(func_list(end,:));
ip=find(func=='.');
if isempty(ip), % se till att func är filnamn (.m eller .mexsol)
  func_list(end,:)=[];
  func_list=strvcat(func_list,which(func));
  func=deblank(func_list(end,:));
  ip=find(func=='.');
end

filtyp=func(ip(end):end);

if strcmp(filtyp,'.m')
  % läs in fil
  fid=fopen(func,'r');
  s=fscanf(fid,'%c');
  fclose(fid);
  
  % ta bort kommentarer  
  ic=findstr(s,'%');
  ieol=find(s==10);
  for i=ic
    k=find(ieol-i>0);
    s(i:ieol(k(1)))=' ';
  end

  % ta bort tecken som inte är kan ingå i funktionsnamn
  iascii=find(~(s>47 & s<58 |s>64 & s<91 |s==95| s>96 & s<123));
  s(iascii)=' ';
  s=deblank(s);
  t_list=[];
  
  % gåigenom s och kolla funktions kandidater 
  while ~isempty(s)
    [t,s]=strtok(s);
    % vill bara kolla namn en gång och bara om t(1) är en bokstav
    if isletter(t(1)) & isempty(strmatch(t,t_list)) 
      t_list=strvcat(t_list,t); % lägg till t på t_list
      f=which(t,func); %kolla om t finns på sökvägen
    else 
      f='';
    end
    
    % kolla om det är en "egen" funktion, matlab funktioner hoppas över
    if ~any(strcmp(f,{'built-in','variable',''})) & isempty(strmatch(mhome,f))
      if isempty(strmatch(f,func_list))   %funktionen finns i listan ?
%       & strcmp(f(end-1:end),'.m')           %endast .m-filer OK
        func_list=strvcat(func_list,f); % lägg till funktionen
        func_list=fuse(func_list,mhome);
      end
    end
  end
else 
  % Gå ej vidare i .mexsol fil 
end

    

