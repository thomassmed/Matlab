function pintraj=pmap2ptraj(pmapdist)
% pmap2ptraj - Change the format to pin-oriented format
%
% pintraj=pmap2ptraj(pmapdist)
%
% Input:
%   pmapdist - read with read_pinfile {maxsta}{iafull,jafull}(npin,npin,kdfuel)
%
% Output:
%   pintraj - Time trajectory for each pin, pintraj{iafull,jafull}{npin,npin}(kdfuel,maxsta)
%
% Examples:
%   pinpow=read_pinfile('Recalcs.pin');
%   pintraj=pmap2ptraj(pinpow);
%   plot(pintraj{8,8}{1,4})
%
% See also read_pinfile, pindis2cordis, pin_delta, pin_oper 

%% set up dimesnsions and preallocate
if ~iscell(pmapdist{1}),
    tempdist{1}=pmapdist;
    pmapdist=tempdist;
    clear tempdist
end
[iafull,jafull]=size(pmapdist{1});
maxsta=length(pmapdist);
pintraj=cell(iafull,jafull);
%%
for ista=1:maxsta,
    for i=1:iafull,
        for j=1:jafull,
            if ~isempty(pmapdist{1}{i,j,1}),
                [ip,jp,kmax]=size(pmapdist{1}{i,j});
                if ista==1,pintraj{i,j}=cell(ip,jp);end
                pinbun=pmapdist{ista}{i,j};
                for j1=1:jp,
                    for i1=1:ip,
                        if ista==1,
                            pintraj{i,j}{i1,j1}=nan(kmax,maxsta);
                        end
                        xtemp=pinbun(i1,j1,:);xtemp=xtemp(:);
                        pintraj{i,j}{i1,j1}(:,ista)=xtemp;
                    end
                end
            end
        end
    end
end

            