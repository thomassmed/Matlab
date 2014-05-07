%%
cur_dir=pwd;
cur_dir=[cur_dir,filesep];
addpath([cur_dir,'CmsTools']);
addpath([cur_dir,'S3kPlot']);
addpath([cur_dir,'CmsRead']);
addpath([cur_dir,'CmsPlot']);
addpath([cur_dir,'func']);
addpath([cur_dir,'CmsMatstab/model_th']);
addpath([cur_dir,'CmsMatstab/model_neu']);
addpath([cur_dir,'CmsMatstab/model_fuel']);
addpath([cur_dir,'CmsMatstab/matstab_tools']);
addpath([cur_dir,'CmsMatstab']);

opt.Interpreter='tex';opt.Default='No';
spara=questdlg('Do you want to save the path for future sessions?','Save Path','Yes','No',opt);

if strcmp(spara,'Yes')
 savepath;
end
%
clear cur_dir opt spara