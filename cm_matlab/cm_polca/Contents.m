%@(#)   Contents.m 1.11	 06/09/13     15:16:26
%
% Polca Toolbox
%
% Importing data from coremaster
%    kinf2mlab -  Calculate kinf from distributionfile
%    readcell  -  Read celldata from cd-file
%    readdist  -  Read from distribution files 
%    readsum   -  Read from sum-file
%    readpolca -  Low level read function (mex-file)
%    readmast  -  Read data from master files
%    readbuntyp-  Read buntyp distribution from source-file
%    
% Graphic representation
%    distplot    -  Plot distribution files in color 
%    setprop     -  Script control of distplot
% 
% Printout
%    cor2fil     - print coremap on file  
%    cor2scr     - print coremap on screen  
%    cr2fil      - print cr map to file 
%    cr2scr      - print cr map to screen 
%    crpat2fil   - print cr-patterns to file (one or two in parallel) 
%    hcor2fil    - print halfcoremap on file    
% 
% Geometry
%    cor2cr      -  full core map to control rod value vector
%    cor2vec     -  core-matrix to channel number vector
%    cpos2knum   -  core position to channel number
%    cpos2crpos  -  channel position to control rod position
%    cr2core     -  control rod value vector to full core map
%    cr2map      -  control rod value vector to control rod map
%    crnum2crpos -  control rod channel number to control rod core position
%    crpos2crnum -  control rod core position to control rod channel number
%    crpos2knum  -  control rod core position to channel number
%    flopos      -  find flow measurement positions
%    full2half   -  Full core channel number to half core channel number
%    getranbui   -  find peripheral buidnts
%    half2full   -  Half core channel number to full core channel number
%    hrot2qrot   -  Gives qrotsym to a hrotsym core
%    knum2cpos   -  channel number to core position
%    knumhalf    -  get right/left channel numbers
%    map2cr      -  control rod map to control rod value vector
%    mminj2crmminj - calculates crcoreshape from fuelcoreshape
%    randvec     -  find core zones
%    vec2core    -  channel number vector to core-matrix
%    whereis     -  find bundle in core
%    xy2ij       -  Transforms x-y (in metres) to ij-coordinates
%    ij2xy       -  Transforms  ij-coordinates to x-y (in metres)
%
% Filtering
%    buidfilt    - Filter on vector of buidnts
%    diagfilt    - Filters out chessboard
%    filtbun     - Filter on one buntyp
%    filtcr      - Filter on control rods < some upper limit
%    mfiltbun    - Filter on several buntypes
%    oldcrbun    - Filters out old controlled bundles in a new core
% 
% Time and date handling
%    addmon      - add/subtract months to/from a date
%    dat2tim     - convert date to continuous time
%    datplot     - plot versus time
%    month       - find month boundaries and month names
%    tim2dat     - convert continuous time to date
% 
% Fuel cycle cost analysis
%    fuelcost    - Gives delta burnup type-wise
%    printfcost  - Prints delta burnup
% 
% Miscellaneous
%    bukoll      - Compare 'BUIDNT' in two distribution-files
%    crdiff      - Compute an plot difference in crburn
%    dopbundle   - Create 'BUIDNT'-card for anaload-input
%    findfile    - Find and sort some specified distr. files on a dir.
%    findtip     - Find and sort tip-files on a directory
%    flowcheck   - finds flow in measurement position
%    lhgrburn    - find worst lhgr in controlled fuel
%    lowkinf     - lists fuel bundles whith low kinf
%    nyscax      - plots a supercell-axplot in a printable form
%    plotworst   - plots worst points (w.r.t. given burnup-dependent limitation)
%    pltip       - Plot tip-analyses of a cycle
%    printsskarta- Creates an overview of a simulation
%    simbilaga   - prepares plots for simulations
%    stabindex   - Compute and plot stability indices
