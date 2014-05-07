function k=get_kan
%gte_kan
%
%k=get_kan
%Hämtar index från nod 2 till
%riserns utlopp genom alla kanaler

%@(#)   get_kan.m 2.2   02/02/27     12:09:29

global geom
ncc=geom.ncc;
nsec=geom.nsec;

k = [get_dcnodes,get_lp1nodes,get_lp2nodes]'*ones(1,ncc+1);

k = [k;get_ch(1)'*ones(1,ncc+1) + ((0:ncc)'*ones(1,1+nsec(5)))'];

k = [k;get_risernodes'*ones(1,ncc+1)];

