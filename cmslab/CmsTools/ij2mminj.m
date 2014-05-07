function [mminj,sym,knum,ia,ja]=ij2mminj(ia,ja,nload,isymc)
% Converts vecctors of ia and ja to contour-vector mminj and
%
% [mminj,sym,knum]=ij2mminj(ia,ja)
%
% Input
%   ia - vector of i-indices
%   ja - vector of j-indices
%
% Output
%   mminj - first assembly position for each row - compact description frequently used to
%           describe core geometry
%   knum  - vector of channel numbers for full symmetry. Matrix for
%           symmetric case, then each row contains symmetric channel numbers
%
% figures out the symmetry, sym can be:
%                       Quarter Core - 'NW','NE','SW','SE'
%                       Half Core 'N','S','W','E'
%                       Full Core 'FULL'
%
% Example
%   icor=hms_pp2_read(hermes_file,'_ICOOR');
%   jcor=hms_pp2_read(hermes_file,'_JCOOR');
%   [mminj,sym,knum]=ij2mminj(icor,jcor);
%
% See also cor2vec, cpos2knum, knum2cpos, sym_full, vec2cor
%          Control rods: mminj2crmminj

%%

% TODO: fix bug for knum when symmetry is full
% TODO: add 1/8 core?
% First figure out what imax is
if nargin==2, nload=ones(size(ia)); end
if nargin<4, isymc=1;end
%%
if max(nload)>1,
    ia0=ia;
    ja0=ja;
    ia=2*ia0-(nload<3);
    ja=2*ja0-mod(nload,2);
end    

%%
for i=min(ia):max(ia)
   ii=find(ia==i);
   mmaxj(i)=max(ja(ii));
   mminj(i)=min(ja(ii));
end
for j=min(ja):max(ja)
   jj=find(ja==j);
   mmaxi(j)=max(ia(jj));
   mmini(j)=min(ia(jj));
end
imax=max([ia(:);ja(:)]); % This is iamax EXCEPT if we have quarter-core NW
% So check if we have quarter core NW:
umaxj=unique(mmaxj);ibort=find(umaxj==0);umaxj(ibort)=[];
umaxi=unique(mmaxi);ibort=find(umaxi==0);umaxi(ibort)=[];
if length(umaxi)==1&&length(umaxj)==1,   % If this is true, we DO have NW quarter core sym
    imax=2*imax;
    sym='NW';
end
%% Then determine symmetry

if min(ja)>1,               % Right half 
   if min(ia)>1,            % and lower
       if max(ia)==max(ja),
           sym='SE';
       else
           sym='ESE';
       end
   elseif max(mmaxi)<imax,  % and upper
       sym='NE';
   else
       sym='E';            % Right half only
   end
elseif max(ja)<imax,        % Left half
   if min(ia)>1,            % and lower 
       sym='SW';
   elseif max(ia)<imax,     % and upper
       sym='NW';
   else
       sym='W';            % Left half only
   end
elseif min(ia)>1,           % Lower half
    sym='S';               % South half              
elseif max(ia)<imax,        % North half
    sym='N';
else
    sym='FULL';
end
%% And finally, arrive at what we need, mminj
switch sym
    case 'E'
        for i=1:imax,
            mminj(i)=imax+1-mmaxj(i);
        end
    case 'W'
        % do nothing, mminj is already OK
    case 'N'
        for i=max(ia)+1:imax,
            mminj(i)=mmini(i);
        end
    case 'S'
        for i=1:min(ia)-1,
            mminj(i)=mminj(imax+1-i);
        end
    case 'FULL'
        % do nothing, mminj is already OK
    case 'SE'
        for i=min(ia):max(ia),
            mminj(i)=imax+1-mmaxj(i);
        end
        % Fill up for low indices
        for i=1:min(ia)-1,      
            mminj(i)=imax+1-mmaxj(imax+1-i);
        end  
    case 'ESE'
        iase=[ia;ja];
        jase=[ja;ia];
        [mminj,symse,knumse]=ij2mminj(iase,jase);
    case 'NE'
        for i=min(ia):max(ia),
            mminj(i)=imax+1-mmaxj(i);
        end
        % Fill for high indices
        for i=max(ia)+1:imax,      
            mminj(i)=mminj(imax+1-i);
        end
    case 'SW'
        % Fill for low indices
        for i=1:min(ia)-1,
            mminj(i)=mminj(imax+1-i);
        end
    case 'NW'
        % Fill for high indices
        for i=max(ia)+1:imax,
            mminj(i)=mminj(imax+1-i);
        end
end  
mminj=mminj(:); %Assure mminj is a column vector
%% Now populate knum
knum(:,1)=cpos2knum(ia,ja,mminj);
kan=sum(length(mminj)-2*(mminj-1));
iamax=length(mminj);
switch sym
    case 'E'
        knum(:,2)=kan+1-knum(:,1); % Assume rotational for now
    case 'W'
        knum(:,2)=kan+1-knum(:,1); % Assume rotational for now
    case 'N'
        knum(:,2)=kan+1-knum(:,1); % Assume rotational for now
    case 'S'
        knum(:,2)=kan+1-knum(:,1); % Assume rotational for now
    case 'FULL'
        % do nothing, knum is already OK
    case 'SE'
        if isymc==1
            knum(:,2)=kan+1-knum(:,1);  % Takes care of NW quarter assuming rotational
            ia_sym=iamax+1-ja;          % Or ia_sym=(iamax/2+1-(ja-iamax/2)
            ja_sym=ia;
            knum(:,3)=cpos2knum(ia_sym,ja_sym,mminj);
            knum(:,4)=kan+1-knum(:,3);
        else
            ia_sym=iamax+1-ia;
            ja_sym=iamax+1-ja;
            knum(:,2)=cpos2knum(ia_sym,ja_sym,mminj); %NW
            knum(:,3)=cpos2knum(ia_sym,ja,mminj);     %NE
            knum(:,4)=cpos2knum(ia,ja_sym,mminj);     %SW
        end
    case 'ESE'
        ll=size(knumse,1);ll2=ll/2;
        knum=zeros(ll2,8);
        knum(:,1)=knumse(1:ll2,1);
        knum(:,2)=knumse(ll/2+1:ll,1);
        ia1=iamax+1-ia;
        ja1=iamax+1-ja;
        knum(:,3)=cpos2knum(ia1,ja,mminj);
        knum(:,4)=cpos2knum(ja,ia1,mminj);
        knum(:,5)=cpos2knum(ia1,ja1,mminj);
        knum(:,6)=cpos2knum(ja1,ia1,mminj);
        knum(:,7)=cpos2knum(ia,ja1,mminj);
        knum(:,8)=cpos2knum(ja1,ia,mminj);
     case 'NE'
        knum(:,2)=kan+1-knum(:,1);  % Takes care of SW quarter assuming rotational
        ia_sym=iamax+1-ja;
        ja_sym=ia;
        knum(:,3)=cpos2knum(ia_sym,ja_sym,mminj);
        knum(:,4)=kan+1-knum(:,3);
    case 'SW'
        knum(:,2)=kan+1-knum(:,1);
        ia_sym=ja;
        ja_sym=iamax+1-ia;
        knum(:,3)=cpos2knum(ia_sym,ja_sym,mminj);
        knum(:,4)=kan+1-knum(:,3);
    case 'NW'
        knum(:,2)=kan+1-knum(:,1);
        ia_sym=ja;
        ja_sym=iamax+1-ia;
        knum(:,3)=cpos2knum(ia_sym,ja_sym,mminj);
        knum(:,4)=kan+1-knum(:,3);
end