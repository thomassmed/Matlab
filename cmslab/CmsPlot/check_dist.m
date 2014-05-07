function dist=check_dist(dist_in,mminj,knum,sym,s5)

kan=sum(length(mminj)-2*(mminj-1));  % The number of bundles can easily be calculated from mminj

if nargin == 5
    if strcmpi(sym,'full')
        dist = dist_in;
        return
    else
        for k=1:size(knum,2),
            dist(:,knum(:,k))=dist_in;
        end
        return
    end
else
    if(length(size(dist_in))==3),
        dist_in = cor3D2dis3(dist_in,mminj,knum,sym);
    end

    if size(dist_in,2)==kan,  % If this is the case, assume everyting is OK
        dist=dist_in;
        return
    end

    if size(dist_in,1)==kan,  % If this is the case, assume everyting is OK
        dist=dist_in';
        return
    end
end

% Otherwise, we have some manipulating to attend to

switch sym
    case {'E','W','N','S'}
        ncc=kan/2;
    case {'SE','SW','NE','NW'}
        ncc=kan/4;
    otherwise
        ncc=kan;
end

if size(dist_in,1)==ncc&&size(dist_in,2)~=ncc,
    dist_in=dist_in';
end

% if size(dist_in,1) == size(dist_in,2) && size(dist_in,2) ~= kan
    
% else
    kmax=size(dist_in,1);
    dist=NaN(kmax,kan);
% end


for k=1:size(knum,2),
    %TODO: This causes errors in 2-D case
    dist(:,knum(:,k))=dist_in;
end
