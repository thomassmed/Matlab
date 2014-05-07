% Read data from cms-files
%
% Files
% Read from various files
%   ReadCore               - Reads from many different types of CMS-files
% Read from restart files
%   ReadRes                - Reads from binary restart file
%   read_restart_bin       - Reads from binary restart file (old version)
%   unfold_restart_title   - unfold_restart_title Extracts information from cell arry created by read_restart_bin
% Read from library files
%   xs_cms                 - Read cross section from library file
%   read_cdfile            - Reads the cd-file info, finds the position and structure of the segments.
%   read_cdfile_data       - reads non-XS data from cd-file
%   GetNodalWeight         - Calculates the nodal heavy metal weight
%   df_cms                 - Read discontinuity factors from library file
%   cas2sim                - DF is N E S W in core orientation
%   xs_pin_lib             - Uses the fast xs library
%   xs_unpack              - xs_unpack - Unpacks result from xs_pin_lib
%   read_no_pins           - read_no_pin  Reads the number of heated pins per node from library file
%   read_beta_sim3         - Read delayed groups from lib-file
%   xsinterp2              - INTERP2 2-D interpolation with extrapolation (table lookup).
%   xsinterp3              - INTERP3 3-D interpolation with extrapolation (table lookup).
%
% Read from CMS ASCII output files
%   ReadOut                - Read from outfile, output format kmax by kan
%   ReadSum                - Read from summary file
%   ReadOut3D              - Reads 3D distribution from outfile, output format kmax by kan
%   ReadOut2D              - Reads 2D distribution from outfile, output format iafull by iafull
%   ReadPriMac             - Reads 3D macroscopic xs from outfile output format IDR by IDR by KD (includes reflector) 
%   ReadTip                - Reads Tip-related distributions from .out and .det files  
%   read_drfd_s3kout       - Reads decay ratio and frequency from s3k output file
%
% Read from cms files
%   read_cms               - Reads *.cms output files from cms.
%   read_cms_scalar        - Reads scalar quantities from *.cms files
%   read_cms_dist          - Reads distributions from *.cms files
%   AppendixPlot           - Plots selected (scalar) quantities from *.cms files
%
% Read from pin files
%   read_pinfile           - reads binary data from pinfile created by Simulate 3, 4 or 5
%   read_pinfile_asyid     - reads binary data from pinfile for given assembly identity (serial)
%   pin_delta              - Calculates the difference between two pin distributions
%   pin_oper               - Performes an operation between two pin distributions
%   pmap2ptraj             - Change the format to pin-oriented format
%   pindis2cordis          - reduces a pin distribution to a core distribution
%   Pin2Node               - Transform from Pin to Node format 
%   Node2Pin               - Transforms from Node to Pin format
%
% Read from ENIGMA output files
%   ReadEnigma             - Reads from ENIGMA output files
%
% Read and parse from input files
%   file                   - Manipulate file names
%   read_simfile           - Reads in simulate input files and parses  'INC.FIL' cards
%   get_card               - Read one card from input file
%   get_del                - Get delimiter from card
%   get_mcard              - Get multiple cards, output sliced per 'column'
%   get_mcardj             - Get multiple cards, output sliced per card
%   get_num_card           - Reads one card with only numbers as inputs
%   get_num_mcard          - Many cards with numbers only
%   get_tab_card           - get_card Read card on table format
%   remblank               - remove blanks from strings
%   remleadblank           - remove leading blanks from strings
%   remleadblank_comma     - Removes leading blank and commas in a string
%   rem_2blanks            - Removes two (or more) consecutive spaces from a string
%   rensa                  - Cleans matrices from dummy defaults
%   print_crdpos           - prints the card CRD.POS from a konrod 
%   ReadAscii              - Read an arbitrary ascii file
%   findrow                - Finds a certain row in a ascii file read into a cell array
%   ClearNewPage           - Clears new page printout
%   cell2blob              - Translate from cell array to one-dimensional string (blob)
%   blob2cell              - Translate from array to one-dimensional string (blob) to cell array
%
% Read from hermes files
%   hms_pp2_read           - Uses pp2 to read from hermes data base into matlab
%
% See also CmsTools

%Remains from earlier
%   read_crd               - 
%   read_tip               - A=read_tipcalc(filename,case_no,calc)
%   read_tipmeas           - [A,kmax]=read_tipmeas(filename)
%   readdist_old           - 
%   readdists3             - 
%   readrestart_old        - 
%   reads3_det_map         - Input:
%   reads3_file            - Process the file
