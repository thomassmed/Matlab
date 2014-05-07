function [PinDelta,PinRelErr]=pin_delta(pindis1,pindis2,perctp1,perctp2)
% pin_delta - Calculates the difference between two pin distributions
%
% [PinDelta,PinRelErr]=pin_delta(pindis1,pindis2)
% [PinDelta,PinRelErr]=pin_delta(pinfile1,pinfile2) % Only power will be compared
%
% Input:
%   pindis1 - First distribution
%   pindis2 - Second distribution
%
%  Output:
%   PinDelta - Difference
%   RelErr   - Relative difference in %
%
% Example:
%   pinpow1=read_pinfile('pinfile1.pin');
%   pinpow2=read_pinfile('pinfile2.pin');
%   [PinDelta,PinRelErr]=pin_delta(pinpow1,pinpow2)
%
% See also read_pinfile, pmap2ptraj, pindis2cordis, pin_oper

if nargin<3, perctp1=1;perctp2=1;end

if ~iscell(pindis1), %Assume pinfile-names are given
    pindis1=read_pinfile(pindis1); % Note limited to POWER!!
    pindis2=read_pinfile(pindis2);
end

if ~iscell(pindis1{1}),
    temp{1}=pindis1;
    pindis1=temp;
    temp{1}=pindis2;
    pindis2=temp;
end
    
PinDelta=pindis1;
PinRelErr=pindis1;
[iafull,jafull]=size(pindis1{1});
maxsta=length(pindis1);
for ista=1:maxsta,
    for i=1:iafull,
        for j=1:jafull,
            if ~isempty(pindis1{ista}{i,j})
                PinDelta{ista}{i,j}=perctp1*pindis1{ista}{i,j}-perctp2*pindis2{ista}{i,j};
                if nargout>1,
                    PinRelErr{ista}{i,j}=100*PinDelta{ista}{i,j}./(pindis1{ista}{i,j});
                end
            end
        end
    end
end
if maxsta==1,
    PinDelta=PinDelta{1};
    PinRelErr=PinRelErr{1};
end
