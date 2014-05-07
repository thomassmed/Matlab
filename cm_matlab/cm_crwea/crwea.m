% $Id: crwea.m 70 2013-08-19 12:48:53Z rdj $
%
%function [res]=crwea(config)
%
% If no config is supplied as input argument the GUI is started.
%
% config   - Struct with following fields: 
%   .simfile    - Filename of distplot simfile with simulation parameters
%   .resultfile - Filename of output file (mat) , example 'res.mat'
%   .srcfile    - POLCA source file
%   .options    - POLCA options without the POWSEARCH,FLOSEARCH cards
%   .symme      - Core symmetry used in simulation
%   .bursteps   - Which burnup steps from simfile should be analyzed, example [1 5 10].
%   .dstep      - How many percent should the groups/rod be withdrawn at each steps
%   .max_initial_withdrwawal - Maximum init withdrawal to include in analysis
%   .run_er     - Set to 1 to run analysis in ER
%   .run_vr     - Set to 1 to run analysis in VR
%   .lhgr_save  - Set to true to save LHGR results
%   .lhgr_dim   - Dimensions of LHGR results, 2D or 3D
%   .cpr_save   - Set to true to save CPR results
%   .cpr_dim    - Dimensions of CPR results, 2D or 3D
%   .grps       - Manouveur groups to analyze
%   .rods       - Single control rods to analyze
%
function [cases]=crwea(varargin)

if ~isempty(varargin)
   config=varargin{1};
   if ~isstruct(config)
       error('Failed to read config input'); 
   end
   
   % Create the cases
   cases=crwea_create_cases(config);
   config.ncases=length(cases);
   
   % Save caseinput to resultfile
   save(resultfile,'config','cases');
   
   % Run the cases
   crwea_run(config,cases);
  
else % Start GUI
    crwea_gui
end
