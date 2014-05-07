function y = set_nodeheight(height);
%set_nodeheight
%
% y = set_nodeheight(height)
% Sätter nodhöjderna till en termohydraulisk vektor

%@(#)   set_nodeheight.m 2.2   02/02/27     12:12:18

global geom

ncc = geom.ncc;

height = height./geom.nsec;
height1 = zeros(7+ncc,1);
height1(6+ncc)=height(6);
height1(5:(5+ncc))=height(5)*ones(ncc+1,1);
height1(7+ncc)=0;
height1(1:4)=height(1:4);
y = set_geometri(height1).*get_realnodes;
