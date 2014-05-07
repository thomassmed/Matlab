function cur_distpath=gcdp
%GCDP Get current distpath
%
% cur_distpath=gcdp;
%
%
% Example
%  dist_path=gcdp;
%
% See also gchfil, gcv
hfig=gcf;
cmsplot_prop=get(hfig,'userdata');
cur_distpath=cmsplot_prop.dist_path;