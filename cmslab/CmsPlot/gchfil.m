function cur_hfil=gchfil
%GCHFIL Get current hdf5-file
%
% cur_hfil=gchfil;
%
%
% Example
%  hfile=gchfil;
%
% See also gcdp, gcv
hfig=gcf;
cmsplot_prop=get(hfig,'userdata');
cur_hfil=cmsplot_prop.filename;