function detpos=detloc2detpos(detloc,mminj)
% detloc2detpos - translates DET.LOC map to detector position by fuel channel number
%
% detpos=detloc2detpos(detloc,mminj)
% detpos=detloc2detpos(fue_new) (or resinfo)
%
% Input:
%   detloc - DET.LOC map
%   mminj  - Core contour
%   Alternate input: fue_new or resinfo (which contains detloc and mminj)
%
% Output:
%   detpos - Channel # of the fuel channel NW of the detector
%
% Example:
%   fue_new=read_restart_bin('s3.res');
%   detpos=detloc2detpos(fue_new);
%   mminj=fue_new.mminj;detloc=fue_new.detloc;
%   detpos=detloc2detpos(detloc,mminj);
%
% See also read_restart_bin, cor2vec, cpos2knum, ij2mminj, knum2cpos, vec2cor

% Written: Thomas Smed 2009-05-04
if nargin==1,
    if isstruct(detloc) % take care of fue_new, resinfo or filename as input
        if max(strcmp('core',fieldnames(detloc)))
            % resinfo
            resinfo = detloc;
            mminj=resinfo.core.mminj;
            detloc = resinfo.core.detloc;
        else
            % fue_new
            fue_new = detloc;
            mminj=fue_new.mminj;
            detloc = fue_new.detloc;
        end

    elseif ischar(resfile)
          % filename
            resinfo = ReadRes(detloc,'full');
            mminj=resinfo.mminj;
            detloc = resinfo.core.detloc;

    else
        error('Either two inputs detloc and mminj are needed OR one input argument fue_new. Try >> help detloc2detpos');
    end
end

%%
[idet,jdet]=find(detloc);
for i=1:length(idet),
    detpos(detloc(idet(i),jdet(i)))=cpos2knum(2*idet(i),2*jdet(i),mminj);
end