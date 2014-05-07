function gz=set_gz
%set_gz
%
%gz=set_gz
%Sätter in tygdaccelerationen i en
%termohydraulisk vektor

%@(#)   set_gz.m 2.1   96/08/21     07:57:29

gz = -ones(get_thsize,1)*9.81;

%Noderna där elevationen blir positivt tryckfall
k = [get_lp2nodes get_corenodes get_risernodes];

%Noder med inget elevationstryckfall
l = [1 get_lp1nodes]; 

%Verkliga noder
n = get_realnodes; 
gz = gz.*n;

gz(k) = -gz(k);
gz(l) = gz(l)*0;
