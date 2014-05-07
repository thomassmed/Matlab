function data=loadlogg(file,unit)
%data=loadlogg(file,unit)
%laddar in en loggfil genererad av get-pvalues
%file: logg-fil
%unit: F1,F2 eller F3
%data: [yy mm dd hh mm ss data(1:10)']
fid=fopen(file);
m=0;
while 1
  m=m+1;
  while 1
    str=fgetl(fid);
    comstr=['BLOCK: ' unit];
    if findstr(comstr,str),
      s=findstr('19',str);
      data(m,1)=str2num(str(s+2:s+3));
      data(m,2)=str2num(str(s+5:s+6));
      data(m,3)=str2num(str(s+8:s+9));
      s=findstr('.',str);
      data(m,4)=str2num(str(s(1)-2:s(1)-1));
      data(m,5)=str2num(str(s(1)+1:s(1)+2));
      data(m,6)=str2num(str(s(1)+4:s(1)+5));
      break
    end
    if feof(fid),return,end
  end
  for n=1:10,
    while 1
      str=fgetl(fid);
      s=findstr(num2str(n),str);
      if ~isempty(s),
        data(m,n+6)=str2num(deblank(str(20:26)));
        break
      end
    end
  end
end
fclose(file)
