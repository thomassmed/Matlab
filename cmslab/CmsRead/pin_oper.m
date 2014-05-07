function PinOut=pin_oper(pindis1,pindis2,oper)
% pin_oper - Performes an operation between two pin distributions
%
% [PinDelta,PinRelErr]=pin_delta(pindis1,pindis2)
%
% Input:
%   pindis1 - First distribution
%   pindis2 - Secon distribution
%
%  Output:
%   PinOut - Result of performed operation
%
% Example:
%   pinpow1=read_pinfile('pinfile1.pin');
%   pinpow2=read_pinfile('pinfile2.pin');
%   PinOut=pin_delta(pinpow1,pinpow2,'/');
%
% See also read_pinfile, pmap2ptraj, pindis2cordis, pin_delta
if ~iscell(pindis1{1}),
    temp{1}=pindis1;
    pindis1=temp;
    temp{1}=pindis2;
    pindis2=temp;
end


dot='.';
if nargin<3, oper='-';end

if strcmp(oper,'+'), dot=[];end
if strcmp(oper,'-'), dot=[];end

PinOut=pindis1;
[iafull,jafull]=size(pindis1{1});
maxsta=length(pindis1);
for ista=1:maxsta,
    for i=1:iafull,
        for j=1:jafull,
            if ~isempty(pindis1{ista}{i,j})
                evstr=['PinOut{ista}{i,j}=pindis1{ista}{i,j}',dot,oper,'pindis2{ista}{i,j};'];
                eval(evstr);
             end
        end
    end
end
if maxsta==1,
    PinOut=PinOut{1};
end
