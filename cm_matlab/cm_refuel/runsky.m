function [stat, res]=runsky(skyffelcmd, polcacmd, skyinpfile, compkhotfile)

[stat(1), res{1}]=system([skyffelcmd ' ' skyinpfile]);

disp(res{1});

[stat(2), res{2}]=system([polcacmd ' ' compkhotfile]);

disp(res{2});