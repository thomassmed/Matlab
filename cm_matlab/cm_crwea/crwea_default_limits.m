% $Id: crwea_default_limits.m 44 2012-07-16 10:18:15Z rdj $
%
% function [limit_names,s]=crwea_default_limits()
%
% Default limits from report FTB-2011-0215
%
function [s,limit_names]=crwea_default_limits()


% F1/F2 108% H2
s(1).name='F1/F2 108% H2';
s(1).slmcpr=1.06;
s(1).powlimit=116;
s(1).flowlimit=8170;


% F1/F2 108% H3
s(2).name='F1/F2 108% H3';
s(2).slmcpr=1.06;
s(2).powlimit=119;
s(2).flowlimit=7720;



% F2 120% H2
s(3).name='F2 120% H2';
s(3).slmcpr=1.06;
s(3).powlimit=129;
s(3).flowlimit=8740;


% F2 120% H3
s(4).name='F2 120% H3';
s(4).slmcpr=1.06;
s(4).powlimit=133;
s(4).flowlimit=8140;



% F3 109% H2
s(5).name='F3 109% H2';
s(5).slmcpr=1.06;
s(5).powlimit=118;
s(5).flowlimit=10280;


% F3 109% H3
s(6).name='F3 109% H3';
s(6).slmcpr=1.06;
s(6).powlimit=121;
s(6).flowlimit=9720;


for i=1:length(s)
    limit_names{i}=s(i).name;
end
