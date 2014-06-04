function options=set_msopt(varargin)
%Create or change matstab options structure
%options=set_msopt('param1',value1,'param2','value2',...) creates an
%structure with the given parameter values. Other parameters is set to
%default values.
%
% msopt=set_msopt
%
%Recognized parameters and default vales:
%                   Lam: [ start guess {-0.1+3.5j}]  
%              Algorithm [ AESOPS | Newton | {Combined} ] 
%               Display: [ on | {off} ] 
%           SteadyState: [ {on} | off ]
%                Global: [ {on} | off ]
%               LeftEig: [ on | {off} ] 
%              CoreOnly: [ on | {off} ]
%             Harmonics: [ positive scalar {0} ]
%               CoreSym: [1 | {2}] 
%              DistFile: [ filename ]    
%              ParaFile: [ filename {parameter.inp} ]  
%             MstabFile: [ filename {DistFile.mat} ]  
%            MasterFile: [ filename {read from DistFile} ]  
%            RestartFile:[filename {read from s3kfile} ]
%            s3kfile:    [filename]
%            LibFile:    [filename {read from RestartFile} ]
%            SaveOption: [ small | {medium} | large ] 
%            NodalCode   [ SIM3 | POLCA4 | POLCA7]
%            NeuModel    [ NEU1 | NEU3]
%            OptionFile: [ filename {msuseropt.m}]     
%            Midpoint:   [ on | {off} ]
%            XSmodel     [ xs_cms | xs_cms_df | fastxs | {fastxs_lin} | ramcof ]
%            Init        [ {on} | off ]
%            XSInit      [ on {off} ]
%            BYP         [ {SUP} | S3K | Number as fixed fraction ]
%            Freq        [ {off} | Number in Hz ]


% TODO: Fix so that matstab('s3k.inp','Coresym',1) works

% Somewhat hidden possibilities (that may or may not work):
%     GlobalFullMaxiter: [ positive scalar {15} ]                  
%         GlobalFullTol: [ positive scalar {1e-5} ]
%          GlobalLamTol: [ positive scalar (5e-4)]
%     GlobalHalfMaxiter: [ positive scalar {15} ]   
%         GlobalHalfTol: [ positive scalar {1e-5} ]
%   HarmonicFullMaxiter: [ positive scalar {15} ]     
%       HarmonicFullTol: [ positive scalar {1e-5} ]
%   HarmonicHalfMaxiter: [ positive scalar {15} ]   
%       HarmonicHalfTol: [ positive scalar {1e-5} ]
%      LeftEigGlobalTol: [ positive scalar {1e-10} ]
%  LeftEigGlobalMaxiter: [ positive scalar {5} ]
%          PowerVoidTol: [ positive scalar {5e-3} ]
%      PowerVoidMaxiter: [ positive scalar {20} ]
%            PowerVoidW: [ vector 25x1 {3x1;3x0.95;19x0.97} ] 
%          PowerVoidWFa: [ vector 30x1 {0.9x30} ]    
%   PowerVoidNeuMaxiter: [ positive scalar {10} ]
%       PowerVoidNeuTol: [ positive scalar {1e-7} ]
%      PowerVoidNeuDisp: [ on | {off} ]   
%     PowerVoidNeuGamma: [ positive scalar {0.98} ]
%    PowerVoidThMaxiter: [ positive scalar {30} ]
%       PowerVoidThDisp: [ on | {off} ]
%      ThJacUpdateLimit: [ positive scalar {0.001} ]  

options=struct(...
'GlobalFullMaxiter',      15, ... %Calc options
'GlobalFullTol',          1e-5, ...     
'GlobalLamTol',           5e-4,...
'GlobalHalfMaxiter',      15, ... 
'GlobalHalfTol',          1e-5, ...    
'HarmonicFullMaxiter',    15, ...
'HarmonicFullTol',        1e-5, ...    
'HarmonicHalfMaxiter',    15, ...
'HarmonicHalfTol',        1e-5, ...    
'LeftEigGlobalTol',       1e-10, ...
'LeftEigGlobalMaxiter',   5, ...
'PowerVoidTol',           5e-3, ...  
'PowerVoidMaxiter',       20, ...
'PowerVoidW',             [ones(3,1);0.95*ones(3,1);0.97*ones(19,1)], ...  
'PowerVoidWFa',           0.9*ones(30,1), ...  
'PowerVoidNeuMaxiter',    10, ...
'PowerVoidNeuTol',        1e-7, ...
'PowerVoidNeuDisp',       'off', ...
'PowerVoidNeuGamma',      0.98, ...  
'PowerVoidThMaxiter',     30, ...
'PowerVoidThDisp',        'off', ...
'ThJacUpdateLimit',       0.001, ...
'Lam',                    'auto', ...
'Algorithm',              'AESOPS',...
'Display',                'off', ...
'SteadyState',            'on', ...% Flow Control
'Global',                 'on', ...
'LeftEig',                'off', ...
'CoreOnly',               'off', ...
'Harmonics',              0, ...
'CoreSym',                2,...
'input',                  [],...
'DistFile',               [], ...  %Files
'ParaFile',               [], ...
'SourceFile',               [],...
'MstabFile',              [], ...
'MasterFile',             [], ...
'RestartFile',            [],...
'xpo',                    10000,...
'LibFile',                [],...
's3kfile',                [],...
'SaveOption',               'medium', ...
'NodalCode',                'SIM3',...
'NeuModel',                 'NEU1',...
'OptionFile',             [],...
'Midpoint',                'on',...
'Init',                    'off',...
'XSinit',                   'off',...
'XSmodel',                  'xs_cms',...
'Qrel',                     nan(1),...
'Wtot',                     nan(1),...
'Tin',                     nan(1),...
'NoPump',                   'off',...
'BYP',                      'FRAC',...
'Freq',                     nan(1) );

numberargs = nargin; % we might change this value, so assign it

Names = fieldnames(options);
[m,n] = size(Names);
names = lower(Names);

i = 1;
while i <= numberargs
    arg = varargin{i};
    if ischar(arg)                         % arg is an option name
        break;
    end
    if ~isempty(arg)                      % [] is a valid options argument
        if ~isa(arg,'struct')
            error(sprintf(['Expected argument %d to be a string parameter name ' ...
                    'or an options structure\ncreated with MSOPTSET.'], i));
        end
        for j = 1:m
            if any(strcmp(fieldnames(arg),Names{j,:}))
                val = getfield(arg, Names{j,:});
            else
                val = [];
            end
            if ~isempty(val)
                if ischar(val)
                    val = deblank(val);
                end
                [valid, errmsg] = checkfield(Names{j,:},val);
                if valid
                    options = setfield(options, Names{j,:},val);
                else
                    error(errmsg);
                end
            end
        end
    end
    i = i + 1;
end

% A finite state machine to parse name-value pairs.
if rem(numberargs-i+1,2) ~= 0
    error('Arguments must occur in name-value pairs.');
end
expectval = 0;                          % start expecting a name, not a value
while i <= numberargs
    arg = varargin{i};
    
    if ~expectval
        if ~ischar(arg)
            error(sprintf('Expected argument %d to be a string parameter name.', i));
        end
        
        lowArg = lower(arg);
        j = strmatch(lowArg,names);
        if isempty(j)                       % if no matches
            error(sprintf('Unrecognized parameter name ''%s''.', arg));
        elseif length(j) > 1                % if more than one match
            % Check for any exact matches (in case any names are subsets of others)
            k = strmatch(lowArg,names,'exact');
            if length(k) == 1
                j = k;
            else
                msg = sprintf('Ambiguous parameter name ''%s'' ', arg);
                msg = [msg '(' Names{j(1),:}];
                for k = j(2:length(j))'
                    msg = [msg ', ' Names{k,:}];
                end
                msg = sprintf('%s).', msg);
                error(msg);
            end
        end
        expectval = 1;                      % we expect a value next
        
    else           
        if ischar(arg)
            arg = deblank(arg);
        end
        field_val=getfield(options,Names{j});
        if  isnumeric(field_val)&&~isempty(field_val),
            if ischar(arg)
                arg=str2double(arg);
            end
        end
        [valid, errmsg] = checkfield(Names{j,:},arg);
        if valid
            options = setfield(options, Names{j,:},arg);
        else
            error(errmsg);
        end
        expectval = 0;
    end
    i = i + 1;
end

if expectval
    error(sprintf('Expected value for parameter ''%s''.', arg));
end

%-------------------------------------------------
function f = getfield(s,field)
%GETFIELD Get structure field contents.
%   F = GETFIELD(S,'field') returns the contents of the specified
%   field.  This is equivalent to the syntax F = S.field.
%   S must be a 1-by-1 structure.  
% 

sref.type = '.'; sref.subs = field;
f = subsref(s,sref);

%-------------------------------------------------
function s = setfield(s,field,value)
%SETFIELD Set structure field contents.
%   S = SETFIELD(S,'field',V) sets the contents of the specified
%   field to the value V.  This is equivalent to the syntax S.field = V.
%   S must be a 1-by-1 structure.  The changed structure is returned.
%

sref.type = '.'; sref.subs = field;
s = subsasgn(s,sref,value);
%-------------------------------------------------
function [valid, errmsg] = checkfield(field,value)
%CHECKFIELD Check validity of structure field contents.
%   [VALID, MSG] = CHECKFIELD('field',V) checks the contents of the specified
%   value V to be valid for the field 'field'. 
%   THIS FUNCTION CAN BE USED TO CHECK IF THE FIELD VALUE IS VALID
%   STILL TO BE IMPLEMENTED


valid = 1;
errmsg = '';
