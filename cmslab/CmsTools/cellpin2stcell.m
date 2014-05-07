function stcell = cellpin2stcell(pindat)
%% cellpin2stcell converts the "cell format" of pindata from read_pinfile_asyid to 
% to 3D matrix
%
% stcell = cellpin2stcell(pindat)
%
% Input:
%  pindat  - cell structure of pindata
%
% Output:
%  stcell  - a 3D matrix of the pindata, if additional statepoint, they
%  will be in a cellarray
%  
% Examples:
%  pow3=read_pinfile_asyid('recalcs.pin','JLC361');
%  pinpow3 = cellpin2stcell(pow3)
%
% See also read_pinfile_asyid, pmap2ptraj, pindis2cordis, pin_delta, pin_oper


npin = size(pindat,1);
stlen = size(pindat{1});
stpt = stlen(1);
kmax = stlen(2);
stcell = cell(1,stpt);
for k = 1:stpt
    stcell{k} = zeros(npin,npin,kmax);
    for i = 1:npin
        for j = 1:npin
            stcell{k}(i,j,:) = pindat{i,j}(k,:);
        end    
    end
end