% CMSTOOLS Geometry manipulation, conversion metric (SI) - English
%
% Geometry
%   ij2mminj        - Converts vectors of ia and ja to contour-vector mminj
%   mminj2ij        - [ia,ja]=mminj2ij(mminj,isym)
%   mminjmmaxj2ij   - calculates ij index from mminj
%   cor2vec         - Convert core map to vector of values
%   cor2veccell     - Convert core map of matrix cell array to a vector cell array of strings
%   vec2cor         - Convert from vector to core map
%   vec2corcell     - Convert from vector cell array of strings to a core map cell array
%   cpos2knum       - Translates core-coordinates to channel number
%   knum2cpos       - Translates channel numbers to core-coordinates 
%   sym_full        - Translate from symmetric distribution to full core
%   knumhalf        - function [right,left]=knumhalf(mminj) (East,rotational)
%   cdis2_2x2       - Expands from any symmetry 1x1 to a 2x2 for plotting in PlotCms
%   cor3D2dis3      - Convert true 3D distribution cor3D(i,j,k) from HDF5 to dis3(kmax,kan)
%   cor3D2mminj     - Calculates mminj, kmax, kan, knum, sym from true 3D distr
%   cordis23D       - Convert  dis3(kmax,kan) true 3D distribution cor3D(i,j,k)
%   sym2sym         - dis2=sym2sym(dis1,sym1,sym2,knum1,knum2)
%   sym_full        - Translate from symmetric distribution to full core
%   expand_fuenew   - transforms fue_new to full core
%   mirror          - mirror - calculates nw and se channel numbers for mirror symmetry
%   set_lim         - Sets the limit for thermohydraulic parameters reda from restart file
%   set_nodal_value - Sets the nodal value for axially varyin thermohydraulic parameters
%
% Geometry, control rods and detectors
%   cr2map           - Convert control rod value vector to control rod map
%   map2cr           - Convert control rod value map to control rod value vector
%   cor2cr           - Reduce full core map  to control rod value vector 
%   cr2core          - function core=cr2core(konrod,mminj[,crmminj])
%   crnum2crpos      - Converts control rod number to control rod position
%   crpos2crnum      - Convert cr postion to cr number
%   crnum2knum       - translates from cr position to channel number
%   pos2chan_num     - calculates bundle channel numbers surrounding a cr or detector
%   mminj2crmminj    - Converts bundle core-contour to control rod core contour
%   filtcr           - Filters out channel numbers for which mink<konrod<maxk
%   konrod2crfrac    - [cr,cr_w,cr_cusp]=konrod2crfrac(fue_new);
%   detloc2detpos    - detloc2detpos - translates DET.LOC map to detector position by fuel channel number
%   detmap2detmat    - detmap2detmat - translates output from read_detmap
%   detpos2detloc    - detloc2detpos - translates detector position by fuel channel number to DET.LOC map
% 
% Conversion between SI and English units
%   Btu2kJkg        - Convert Btu kJ/Kg
%   C2F             - Convert Celsius (centigrades) to Fahrenheit
%   F2C             - Convert Fahrenheit to Celsius (centigrades)
%   kg2lb           - Convert kg to pounds
%   lb2kg           - Convert pound to kg
%   pas2psi         - Convert pascal to psi
%   psi2pas         - Convert psi to pascal
%
%
% Manipulation of cell arrays
%   cell_pack        - packs a cell array
%   cellstrmatch     - cellstrmatch - Finds strings in a cell array of strings
%
% Tip, for reading Tip -distributions, see CmsRead
%   adapt            - Calculates adaption S3 style and Gardel style
%   pri_det          - pri_det - prints detector string info
%   prt_tip          - prt_tip(tipstat[,title,prtfile])
%   tip_stat         - tipstat=tip_stat(Ac,A)
%   lprm2tiprat2     - Calculates in-between tip tiprat
%
% Distribution functions
%   aocalc           - Calculates axial offset 
%   minmax           - Calculates max(abs(dis3-mean(dis3)))*sign
%   isdist           - Determines if a variable is a kmax by kan distribution
%
% Run CMS
%   sim3             - Run Simulate
%   set_version      - Sets default version
%   Res2Inp          - Creates input file from restart file
%
%
% Miscellaneous
%   dub2raa          - Calculates reactivity from doubling time
%   pointkin         - Point kinetics model
%   fin_diff         - Calculates the finite difference of a function fcn 
%   get_phasor       - Calculates phasors from time trajectories
%   rms              - rms - root mean square
%
% See also CmsRead

