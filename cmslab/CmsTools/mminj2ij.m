function [ia,ja]=mminj2ij(mminj,isym)
% [ia,ja]=mminj2ij(mminj,isym)

% TODO: make it more complete, intervjua SOL
%% assume full core symmetry if there are no
if nargin<2, isym=1;end
kan=sum(length(mminj)-2*(mminj-1));
iafull=length(mminj);
%% First generate i and j for full core symmetry
ij=knum2cpos(1:kan,mminj);
%% Then select according to symmetry
switch isym
    case 1
        ia=ij(:,1);
        ja=ij(:,2);
    case 3 % Half core rotational 'E'
        iE=ij(:,1)>iafull/2;
        ia=ij(iE,1);
        ja=ij(iE,2);
    case 9 % Quarter core 'SE'
        iSE=ij(:,1)>iafull/2&ij(:,2)>iafull/2;
        ia=ij(iSE,1);
        ja=ij(iSE,2);     
end
