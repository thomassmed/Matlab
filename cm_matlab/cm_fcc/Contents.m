%@(#)   Contents.m 1.5	 98/01/07     12:20:10
%
% Fuel Cycle Cost Toolbox
%
%
% Operations on output and derivatives of program bunhist
%
%   Operations on primitive file from bunhist
%     sortprint - sort and print result of primitive file
%     lager     - Economics on result file
%     bunhist   - read and unfold variables from bunhist FORTRAN code
%
% Operations on output and derivatives of program bunhist
%     sortfil    - sorts all vectors of a file
%     findfuel   - sorts out fuel in pool, core or clab
%     savesubset - saves subset of a file
%     sortlager  - sort buntyp,burnup into batches, and calculate energy prod.
%
% Printouts
%     pristat - Prints out result to ascii file
%
% Miscellanous
%     bucatch    - finds a bundle identity
%     readbatch  - Read data from a batchdata-file
%                  (normally /cm/fx/div/bunhist/batch-data.txt)
%     skbrapport - Prints an skb report
%     medellhgr  - Gives mean LHGR for a full core
%
% Operations on distribution files
%     fuelcost   - Calculates specific fuel cost for a period of
%                  time between two distribution files. 
%     restvalue  - Calculates restvalue for unloaded fuel
%     restvalue_distfil - Calculates "straight" restvalue for a ditr. file
%
%
%
% Summary of MAIN commands:
%
%     sortprint - Listings of individual bundles
%     lager     - Economic information on batches
%     fuelcost  - Calculates specific fuel cost
%
% type help sortprint
%      help lager
%      help fuelcost
% for further information
