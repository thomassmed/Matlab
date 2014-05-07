%% Get metadata from sim-dep.sum
cmsinfo=ReadCore('sim-dep.cms');
%% Read in FLC 2D MAP from sim-dep.sum
FLC=ReadCore(cmsinfo,'2FLC');
%% Find flcmax and the envelope map 
fl_envelope=FLC{1};
flmax=nan(length(FLC),1);
for i=1:length(FLC),
    flmax(i)=max(FLC{i});
    fl_envelope=max(fl_envelope,FLC{i});
end
plot(flmax)
%% 
cmsplot sim-dep.cms fl_envelope

