function [cur_var,cur_data]=gcv
%GCV Get current variable
%
% [cur_var,cur_data]=gcv;
%
% Example
%  kinf3=gcv;
%  [rpf3,RPF3]=gcv;
%
% See also gcdp, gchfil
dist_path=gcdp;
cmsplot_prop=get(gcf,'userdata');
cur_var=hdf5read(cmsplot_prop.filename,dist_path);
cur_data=cmsplot_prop.data;
disp(dist_path);