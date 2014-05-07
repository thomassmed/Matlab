function set_filt_matvar
hfig=gcf;
cmsplot_prop=get(hfig,'userdata');
kan=cmsplot_prop.core.kan;
if cmsplot_prop.core.if2x2 == 2
    str = ['Matlab Variable (1 by ',sprintf('%i',kan),') or (1 by ',sprintf('%i',kan*4),')'];
else
    str = ['Matlab Variable (1 by ',sprintf('%i',kan),')'];
end
matvar=inputdlg(str,'Matlab variable',1,cmsplot_prop.filter.filt_matvar_string);
if isempty(matvar), return; end

cmsplot_prop.filt_matvar_string=matvar;
matvar=evalin('base',matvar{1});
if size(matvar,2)>size(cmsplot_prop.data,2),
   if cmsplot_prop.if2x2 == 0 && cmsplot_prop.core.if2x2 == 2,
       matvar=dis2x2to1x1(matvar,cmsplot_prop.core.mminj2x2);
       warning('IncompatibleFilter','Filter is 2x2 but not distribution');
   end
elseif size(matvar,2)<size(cmsplot_prop.data,2),
      if cmsplot_prop.if2x2 == 2,
          matvar=dis1x1to2x2(matvar,cmsplot_prop.core.mminj2x2);
      end
end
    
if size(matvar,1)==kan&&size(matvar,2)==1,
    matvar=matvar';
end
matvar=matvar>0;
cmsplot_prop.filter.filt_matvar=matvar;
set(gcf,'userdata',cmsplot_prop);
cmsplot_now;