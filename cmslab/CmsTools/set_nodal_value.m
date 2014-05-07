function [nodal,nodal2,w2,nodal3,w3]=set_nodal_value(number,lim,hz,kmax)
% [nodal,nodal2,w2,nodal3,w3]=set_nodal_value(number,lim,hz,kmax)
if isempty(number),
    nodal=[];nodal2=[];w2=[];nodal3=[];w3=[];
    return;
end

isame=find(diff(number)==0); %Take care of the case when there is no real change
while ~isempty(isame),
    number(isame(1))=[];
    lim(isame(1)+1)=[];
    isame=find(diff(number)==0);
end
    

lim(find(isnan(lim)))=[];
number(find(isnan(number)))=[];
if length(number)==length(lim)&&lim(1)>0,
    lim=[0 lim];
end
z=(0:kmax)*hz;
nodal=zeros(kmax,1);nodal2=nodal;nodal3=nodal;w2=nodal;w3=nodal;
i_done=0;
change_twice=0;
if length(lim)>length(number), number=[number number(length(number))]; end
for j=2:length(lim),
    limnod=find(z<lim(j),1,'last');             % Limit node
    if limnod>i_done,
        if limnod>kmax,
            nodal(i_done+1:kmax)=number(j-1);
            i_done=kmax;
        else
            nodal(i_done+1:limnod)=number(j-1);         % First full nodes up and including the limit node
            nodal2(limnod)=number(j);                   % First mix  
            if limnod<=kmax,
                w2(limnod)=(z(limnod+1)-lim(j))/hz;
                if j<length(lim),
                    if lim(j+1)<z(limnod+1),                           % Change twice?
                        nodal3(limnod)=number(j+1);
                        w2(limnod)=(lim(j+1)-lim(j))/hz;
                        w3(limnod)=(z(limnod+1)-lim(j+1))/hz;
                        change_twice=0;
                    end
                end
            end
            i_done=limnod;
        end
    end
    if i_done>=kmax, break; end
end
% Deal with the last limit
if length(number)==length(lim),
    ll=length(lim);
    limnod=find(z<lim(ll),1,'last'); 
    if isempty(limnod), 
        maxnod=kmax;
    else
        maxnod=min(limnod,kmax);
    end
    if ll>1,
        nodal(i_done+1:maxnod)=number(ll-1);
    end
    if limnod<=kmax,
        nodal2(limnod)=number(ll);
        w2(limnod)=(z(limnod+1)-lim(ll))/hz;
    end
end
if nargout==1,
    nodal=nodal.*(1-w2-w3)+nodal2.*w2+nodal3.*w3;
end
    
    
