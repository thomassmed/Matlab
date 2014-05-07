function [answer] = strfun(cmd, varargin)
% strfun - Manipulate strings
%
% answer=strfun(cmd,args)
% 
% Input
%   cmd  - sub-command to execute. See below.
%   args - argument(s) for specified sub-command.
%
% Output
%   answer - Depends on specified sub-command.
%
% Description
%   The strfun function is the front end for several sub-functions. The first
%   argument to file is the name of the sub-function to invoke. The following
%   sub-functions are available:
%     - equal      strfun('equal', 'str1', 'str2', options)
%                  Compare two strings, return 1 if they are equal, otherwise 0.
%                  This command has two options:
%                    - 'nocase'      - Perform case insensitive comparison.
%                    - 'length' len  - Compare only the first <len> characters
%                                        of the strings.
%
%     - compare    strfun('compare', 'str1', 'str2', options)
%                  Similiar to 'equal' except that it returns -1, 0, or 1,
%                  depending on whether string1 is lexicographically less
%                  than, equal to, or greater than string2.
%
%     - match      strfun('match', 'pattern', 'str', options)
%                  See if pattern matches string; return 1 if it does, 0 if it
%                  does not. If option 'nocase' is specified, then the pattern
%                  attempts to match against the string in a case insensitive
%                  manner.  For the two strings to match, their contents must
%                  be identical except that the following special sequences
%                  may appear in pattern:
%
%                    *         Matches any sequence of characters in string.
%
%                    ?         Matches any single character in string.
%
%                    [chars]   Matches any character in the set given by chars.
%                              If a sequence of the form x-y appears in chars,
%                              then any character between x and y, inclusive,
%                              will match.
%
%                    \x        Matches the single character x. This provides a
%                              way of avoiding the special interpretation of the
%                              characters *?[]\ in pattern.
%
%     - toupper    strfun('toupper', 'str')
%                  Convert string to upper case.
%
%     - tolower    strfun('tolower', 'str')
%                  Convert string to lower case.
%
%     - todouble   strfun('todouble', 'str')
%                  Convert string to double precision value.
%
%     - tointeger
%       toint      strfun('toint', 'str')
%                  Convert string to integer value. If the string starts with
%                  '0x' a hexadecimal value is assumed. If the string starts
%                  with 0 an octal value is assumed.
%
%     - map        strfun('map', {mapping}, 'str', options)
%                  Replace substrings in string based on the key-value pairs in
%                  'mapping'. 'mapping' is a cell array of key, value, key,
%                  value ... etc.
%                  Each instance of a key in the string will be replaced with
%                  its corresponding value. If option 'nocase' is specified,
%                  then matching is done without regard to case differences.
%                  Both key and value may be multiple characters. Replacement is
%                  done in an ordered manner, so the key appearing first in the
%                  list will be checked first, and so on. The string is only
%                  iterated over once, so earlier key replacements will have no
%                  effect for later key matches. For example,
%
%                      strfun('map', {'abc' '1' 'ab' '2' 'a' '3' '1' '0'}, ...
%                             '1abcaababcabababc')
%                  will return the string '01321221'.
%
%                  Note that if an earlier key is a prefix of a later one, it
%                  will completely mask the later one. So if the previous
%                  example is reordered like this,
%                      strfun('map', {'1' '0' 'ab' '2' 'a' '3' 'abc' '1'}, ...
%                             '1abcaababcabababc')
%                  it will return the string '02c322c222c'. 
%
%     - reverse    strfun('reverse', 'str')
%                  Reverse string.
%
%     - repeat     strfun('repeat', 'str', N)
%                  Returns string repeated a specified number of times.
%
%     - index      strfun('index', 'str', idx)
%                  Returns the character at an index of a string. An index 1
%                  corresponds to the first character of the string. The index
%                  may be specified as follows:
%
%                  integer
%                      For numeric indexes, the character specified at this
%                      index is returned (e.g. 2 would refer to "b" in "abcd").
%
%                  end
%                      The last character of the string is returned (e.g. the
%                      the "d" in "abcd").
%
%                  end-N
%                      The last character of the string minus the specified
%                      integer offset N (e.g. end-1 would refer to the "c" in
%                      "abcd").
%
%     - range      strfun('range', 'str', idx1, idx2)
%                  Returns a range of characters from a string, starting from
%                  the first index and ending at the last index. Indexes can be
%                  specified the same was as for the "index" sub-command.
%
%     - replace    strfun('replace', 'str', idx1, idx2, 'newstr)
%                  Replace characters between two indexes with a new sub-string.
%
%     - first      strfun('first', 'find_str', 'str', [start_idx])
%                  Find first occurence of one string (find_str) within another
%                  (str). Return the index of the start of found string or -1 if
%                  none was found.
%                  If a start index (start_idx) is specified, the search starts
%                  at that index.
%
%     - last       strfun('last', 'find_str', 'str', [last_idx])
%                  Find first occurence of one string (find_str) within another
%                  (str). Return the index of the start of found string or -1 if
%                  none was found.
%                  If a last index (idx) is specified, the search will stop when
%                  reaching that index.
%
%     - trim       strfun('trim', 'str', [chars])
%                  Trim characters off both ends of string. If 'chars' is not
%                  specified, white-space characters are trimmed off.
%
%     - trimleft   strfun('trimleft', 'str', [chars])
%                  Trim characters off start of string. If 'chars' is not
%                  specified, white-space characters are trimmed off.
%
%     - trimright  strfun('trimright', 'str', [chars])
%                  Trim characters off end of string. If 'chars' is not
%                  specified, white-space characters are trimmed off.
%
%     - wordend    strfun('wordend', 'str', idx)
%                  Return the index of the character just after the last one in
%                  the word containing character 'idx' of string. 'idx' may be
%                  specified as for the 'index' command. A word is considered to
%                  be any contiguous range of alphanumeric or underscore
%                  characters, or any single character other than these.
%
%     - wordstart  strfun('wordstart', 'str', idx)
%                  Return the index of the first character in the word
%                  containing character 'idx' of string. 'idx' may be specified
%                  as for the 'index' command. See 'wordend' command for the
%                  definition of a word.
%
%     - is         strfun('is', class, 'str')
%                  Return true if string is a valid member of the specified
%                  character class, otherwise return false. The following
%                  character classes are recognized:
%
%                  alphanum
%                  alnum       Any alphanumeric character.
%
%                  alpha       Any alphabetic character.
%
%                  boolean
%                  bool        Any of the boolean forms; 'true', '1', 'yes',
%                              'on', 'false', '0', 'no' or 'off'.
%
%                  control     Any control character.
%
%                  digit       Any numeric digit character.
%
%                  double      Any of the valid forms for a double.
%
%                  false       Any of the false boolean forms; 'false', '0',
%                              'no' or 'off'.
%
%                  graphic
%                  graph       Any graphic character (no white-space).
%
%                  integer
%                  int         Any of the valid forms for an integer.
%
%                  lower       Any lower case alphabet character.
%
%                  print       Any printing character, including white-space.
% 
%                  punct       Any punctuation character.
%
%                  wspace
%                  space       Any white-space character.
% 
%                  true        Any of the true boolean forms; 'true', '1', 'yes'
%                              or 'on'.
% 
%                  upper       Any upper case alphabet character.                                       ?
%
%                  xdigit      Any hexadecimal digit character ([0-9A-Fa-f]).			  
%
% Examples
%     strfun('equal', str1, str2) - Compares str1 and str2
%     ----------------------------------------------------
%     strfun('equal', 'abc', 'abc');
%     % returns 1
%     strfun('equal', 'abc', 'ABC');
%     % returns 0
%     strfun('equal', 'abc', 'ABC', 'nocase');
%     % returns 1
%     strfun('equal', 'abc', 'abcdef', 'length', 3);
%     % returns 1
%     strfun('equal', 'abc', 'ABC123', 'nocase', 'length', 3);
%     % returns 1
%
%     strfun('compare', str1, str2) - Compares str1 and str2
%     ------------------------------------------------------
%     strfun('compare', 'def', 'abc');
%     % returns 1
%     strfun('compare', 'abc', 'abc');
%     % returns 0
%     strfun('compare', 'abc', 'def', 'nocase');
%     % returns -1
%     strfun('compare', 'abc', 'abcdef', 'length', 3);
%     % returns 0
%     strfun('compare', 'abc', 'ABC123', 'nocase', 'length', 3);
%     % returns 0
%
%     strfun('match', pat, str) - Check if pattern <path> matches <str>
%     -----------------------------------------------------------------
%     strfun('match', 'abc123', 'abc123');
%     % returns 1
%     strfun('match', 'abC123', 'abc123');
%     % returns 0
%     strfun('match', 'abC123', 'abc123', 'nocase');
%     % returns 1
%     strfun('match', 'a?c*3', 'abc123');
%     % returns 1
%     strfun('match', '*B*[0-9][0-9]3', 'abc123', 'nocase');
%     % returns 1
%
%     strfun('tolower', str) - Convert string to lower case
%     -----------------------------------------------------
%     strfun('tolower', 'ABC123');
%     % returns 'abc123'
%
%     strfun('toupper', str) - Convert string to upper case
%     -----------------------------------------------------
%     strfun('toupper', 'abc123');
%     % returns 'ABC123'
%
%     strfun('todouble', str) - Convert string to double precision value
%     ------------------------------------------------------------------
%     strfun('todouble', '1.23');
%     % returns '1.2300'
%     strfun('todouble', '-1.23E-02');
%     % returns '-0.0123'
%
%     strfun('toint', str) - Convert string to integer value
%     ------------------------------------------------------
%     strfun('toint', '123');
%     % returns '123'
%     strfun('toint', '0xff'); % Hexadecimal
%     % returns '255'
%     strfun('tointeger', '0100'); % Octal
%     % returns '80'
%
%     strfun('map', {mapping}, str) - Replace substrings in string
%     ------------------------------------------------------------
%     strfun('map', {'abc' '123' 'ab' '45' 'a' '6'}, 'abcabaabc');
%     % returns '123456123'
%
%     strfun('map', {'a' '6' 'ab' '45' 'abc' '123'}, 'abcabaabc');
%     % returns '6bc6b66bc'
%
%     strfun('map', {'abc' '123' 'ab' '45' 'a' '6'}, 'ABCABAABC', 'nocase');
%     % returns '123456123'
%
%     strfun('reverse', str) - Reverse string
%     ---------------------------------------
%     strfun('reverse', 'abc123');
%     % returns '321bca'
%
%     strfun('repeat', str, n) - Repeat string <n> times
%     --------------------------------------------------
%     strfun('repeat', 'abc', 3);
%     % returns 'abcabcabc'
%
%     strfun('index', str, idx) - Get character at the specified index
%     ----------------------------------------------------------------
%     strfun('index', 'abcd', 3);
%     % returns 'c'
%     strfun('index', 'abcd', 'end-2');
%     % returns 'b'
%
%     strfun('range', str, idx1, idx2) - Get range of characters
%     ----------------------------------------------------------
%     strfun('range', 'abcd', 1, 3);
%     % returns 'abc'
%     strfun('range', 'abcd', 2, 'end-1');
%     % returns 'bc'
%
%     strfun('replace', str, idx1, idx2, newstr) - Replace characters
%     ---------------------------------------------------------------
%     strfun('replace', 'abcd', 2, 3, '1234');
%     % returns 'a1234d'
%     strfun('replace', 'abcd', end, end);
%     % returns 'abc'
%
%     strfun('first' 'find_str', 'str', [first_idx]) - Search for a string
%     --------------------------------------------------------------------
%     strfun('first', 'abc', '12abc34abc');
%     % returns 3
%     strfun('first', 'abc', '12abc34abc', 4);
%     % returns 8
%
%     strfun('last' 'find_str', 'str', [first_idx]) - Search for a string
%     -------------------------------------------------------------------
%     strfun('last', 'abc', '12abc34abc');
%     % returns 8
%     strfun('last', 'abc', '12abc34abc', 8);
%     % returns 3
%
%     strfun('trim' 'str', [chars]) - Trim characters off both ends of a string
%     -------------------------------------------------------------------------
%     strfun('trim', '  abc  ');
%     % returns 'abc'
%     strfun('trim', '123abc321', '123');
%     % returns 'abc'
%
%     strfun('trimleft' 'str', [chars]) - Trim characters off start of a string
%     -------------------------------------------------------------------------
%     strfun('trimleft', '  abc  ');
%     % returns 'abc   '
%     strfun('trimleft', '123abc321', '123');
%     % returns 'abc321'
%
%     strfun('trimright' 'str', [chars]) - Trim characters off end of a string
%     ------------------------------------------------------------------------
%     strfun('trimright', '  abc  ');
%     % returns '   abc'
%     strfun('trimright', '123abc321', '123');
%     % returns '123abc'
%
%     strfun('wordend' 'str', idx) - Get index of end of word
%     -------------------------------------------------------
%     strfun('wordend', 'the brown fox', 7); % 7 is the index of 'o' in 'brown'
%     % returns 10 (index of the space after 'brown')
%     strfun('wordend', 'the brown fox', 4); % 4 is the index of the space after
%                                            % 'the'
%     % returns 5
%
%     strfun('wordstart' 'str', idx) - Get index of start of word
%     ---------------------------------------------------------
%     strfun('wordstart', 'the brown fox', 7); % 7 is the index of 'o' in
%                                              % 'brown'
%     % returns 5 (index of 'b' in 'brown')
%     strfun('wordstart', 'the brown fox', 4); % 4 is the index of the space
%                                              % after 'the'
%     % returns 4
%
%     strfun('is', class, 'str') - Check if string belongs to a specific class                                  specific class.
%     ------------------------------------------------------------------------
%     strfun('is', 'lower', 'abc');
%     % returns 1
%     strfun('is', 'boolean', 'yes');
%     % returns 1
%     strfun('is', 'double', 'abc');
%     % returns 0
%     strfun('is', 'xdigit', '12aadef');
%     % returns 1
%     strfun('is', 'integer', '123abc');
%     % returns 0
%
% Copyright Studsvik Scandpower 2010

% Parse command and execute sub-command
switch cmd
    case {'equal', 'compare'}
	%% Check options
	nocase = false;
	len = -1;
	nvars=length(varargin);
	while(nvars >= 3)
	    opt = varargin{3};
	    if(strcmp(opt, 'nocase'))
		nocase = true;
		varargin(3) = [];
		nvars = nvars - 1;
	    elseif(strcmp(opt, 'length'))
		if(nvars < 4 || ~isnumeric(varargin{4}))
		    error(['In sub-command ''%s'': ' ...
			'Option ''length'' requires a numeric value'], ...
			cmd);
		end
		len = varargin{4};
		varargin(3) = [];
		varargin(3) = [];
		nvars = nvars - 2;
	    else
		error(['In sub-command ''%s'': ' ...
		    'Unknown option ''%s'', must be one of ''nocase'' ' ...
		    'or ''length'''], ...
		    cmd, opt);
	    end
	end
		
	%% Call the appropriate sub-command
	if(strcmp(cmd, 'equal'))
	    answer = strfun_equal(varargin{1}, varargin{2}, nocase, len);
	else
	    answer = strfun_compare(varargin{1}, varargin{2}, nocase, len);
	end

    case 'match'
	%% Check options
	nocase = false;
	nvars=length(varargin);
	while(nvars >= 3)
	    opt = varargin{3};
	    if(strcmp(opt, 'nocase'))
		nocase = true;
		varargin(3) = [];
		nvars = nvars - 1;
	    else
		error(['In sub-command ''%s'': ' ...
		    'Unknown option ''%s'', must be ''nocase'''], ...
		    cmd, opt);
	    end
	end
	
	%% Call sub-command
	answer = strfun_match(varargin{1}, varargin{2}, nocase);
	
    case 'tolower'
	%% Use Matlab built-in function directly
	answer = lower(varargin{1});
	
    case 'toupper'
	%% Use Matlab built-in function directly
	answer = upper(varargin{1});
	
    case 'todouble'
	%% Use Matlab built-in function directly
	answer = str2double(varargin{1});
	if(~isfinite(answer))
	    error('''%s'' is not a valid double precision value', varargin{1});
	end
	
    case {'toint', 'tointeger'}
	%% Use sscanf to convert to integer
	[answer, count, errmsg, nidx] = sscanf(varargin{1}, '%i', 1);
	if(count ~= 1 || nidx <= length(varargin{1}) ...
		|| answer == intmax() || answer == intmin())
	    error('''%s'' is not a valid integer value', varargin{1});
	end

    case 'map'
	%% Check options
	nocase = false;
	nvars=length(varargin);
	while(nvars >= 3)
	    opt = varargin{3};
	    if(strcmp(opt, 'nocase'))
		nocase = true;
		varargin(3) = [];
		nvars = nvars - 1;
	    else
		error(['In sub-command ''%s'': ' ...
		    'Unknown option ''%s'', must be ''nocase'''], ...
		    cmd, opt);
	    end
	end
	
	%% Mapping must be a cell array with an even number of elements
	mapping = varargin{1};
	if(~iscellstr(mapping) || mod(length(mapping),2))
	    error(['In sub-command ''%s'': ' ...
		'Mapping must be a cell array with an even number of ' ...
		'elements'], cmd);
	end
	
	%% Call sub-command
	answer = strfun_map(mapping, varargin{2}, nocase);
	
    case 'reverse'
	% Call sub-command
	answer = strfun_reverse(varargin{1});
	
    case 'repeat'
	% Convert argument to numeric argument if needed
	n = varargin{2};
	if(~isnumeric(n))
	    n = str2num(n);
	end
	
	% Call sub-command
	answer = strfun_repeat(varargin{1}, n);
	
    case 'index'
	% Get index as a numeric value
	idx = strfun_get_index(varargin{1}, varargin{2});
	
	% Call sub-command
	answer = strfun_index(varargin{1}, idx);
	
    case 'range'
	% Get indexes as a numeric values
	idx1 = strfun_get_index(varargin{1}, varargin{2});
	idx2 = strfun_get_index(varargin{1}, varargin{3});
	
	% Call sub-command
	answer = strfun_range(varargin{1}, idx1, idx2);
	
    case 'replace'
	% Get indexes as a numeric values
	idx1 = strfun_get_index(varargin{1}, varargin{2});
	idx2 = strfun_get_index(varargin{1}, varargin{3});

	% Get replacement string, default is empty string
	newstr = '';
	if(length(varargin) >= 4)
	    newstr = varargin{4};
	end
	
	% Call sub-command
	answer = strfun_replace(varargin{1}, idx1, idx2, newstr);

    case 'first'
	% Get start index
	idx = 0;
	if(length(varargin) >= 3)
	    idx = strfun_get_index(varargin{2}, varargin{3});
	end
	
	% Call sub-command
	answer = strfun_first(varargin{1}, varargin{2}, idx);

    case 'last'
	% Get start index
	idx = length(varargin{2});
	if(length(varargin) >= 3)
	    idx = strfun_get_index(varargin{2}, varargin{3});
	end
	
	% Call sub-command
	answer = strfun_last(varargin{1}, varargin{2}, idx);
	
    case 'trim'
	tchars = '';
	if(length(varargin) > 1)
	    tchars = varargin{2};
	end

	% Call sub-command
	answer = strfun_trim(varargin{1}, tchars, 1, 1);
	
    case 'trimleft'
	tchars = '';
	if(length(varargin) > 1)
	    tchars = varargin{2};
	end

	% Call sub-command
	answer = strfun_trim(varargin{1}, tchars, 1, 0);

    case 'trimright'
	tchars = '';
	if(length(varargin) > 1)
	    tchars = varargin{2};
	end

	% Call sub-command
	answer = strfun_trim(varargin{1}, tchars, 0, 1);
	
    case 'wordstart'
	% Get index as a numeric value
	idx = strfun_get_index(varargin{1}, varargin{2});
	
	% Call sub-command
	answer = strfun_wordstart(varargin{1}, idx);

    case 'wordend'
	% Get index as a numeric value
	idx = strfun_get_index(varargin{1}, varargin{2});
	
	% Call sub-command
	answer = strfun_wordend(varargin{1}, idx);
	
    case 'is'
	% Call sub-command
	answer = strfun_is(varargin{1}, varargin{2});
	
    otherwise
	error(['Unknown command ''%s'', must be one of:\n' ...
	    '''equal'', ''compare'', ''match'', ''tolower'', ''toupper'', ' ...
	    '''reverse'', ''repeat'', ''index'', ''range'', ''replace'', ' ...
	    '''first'', ''last'', ''trim'', ''trimleft'', ''trimright'', ' ...
	    '''wordstart'', ''wordend'' or ''is'''], ...
	    cmd);
end
end

% Convert index expression to numerix index
% -----------------------------------------
function [num_idx] = strfun_get_index(str, idx)
% Get string length
slen = length(str);
	
% Get index as a numeric value, note that 'end-1' is a valid index
if(isnumeric(idx))
    num_idx = idx;
else
    % Replace end with string's length and evaluate expression
    num_idx = eval(regexprep(idx, 'end', num2str(slen)));
end
end

% Check if two strings are equal
% ------------------------------
function [eq] = strfun_equal(str1, str2, nocase, len)
%% Use appropriate Matlab built-in function
if(nocase)
    % Case insensitive comparison
    if(len > 0)
	% Compare only the first <len> characters
	eq = strncmpi(str1, str2, len);
    else
	eq = strcmpi(str1, str2);
    end
else
    % Case sensitive comparison
    if(len > 0)
	% Compare only the first <len> characters
	eq = strncmp(str1, str2, len);
    else
	eq = strcmp(str1, str2);
    end  
end
end

% Compare two strings
% -------------------
function [cmp] = strfun_compare(str1, str2, nocase, len)
%% If nocase is specified, convert both strings to lower cases
if(nocase)
    str1 = lower(str1);
    str2 = lower(str2);
end

%% If a length is specified, extract sub-strings
if(len > 0)
    slen = min(len, length(str1));
    str1 = str1(1:slen);
    slen = min(len, length(str2));
    str2 = str2(1:slen);
end

%% Compare the strings
slen1 = length(str1);
slen2 = length(str2);
cmp = 0;
for i=1:min(slen1,slen2)
    if(gt(str1(i), str2(i)))
	cmp = 1;
	break;
    elseif(lt(str1(i), str2(i)))
	cmp = -1;
	break;
    end
end

%% If they have different lengths, they are not equal
if(cmp == 0 && slen1 ~= slen2)
    if(slen1 > slen2)
	cmp = 1;
    else
	cmp = -1;
    end
end
end

% Check if pattern matches string
% -------------------------------
function [match] = strfun_match(pattern, str, nocase)
%% Translate pattern into a regular expression
rx = '^';
plen = length(pattern);
in_set = 0;
escaped = 0;
for i=1:plen
    % Handle escaped characters
    if(escaped)
	rx = [rx, '\', pattern(i)];
	escaped = 0;
	continue;
    end

    % Parse character
    sub_rx = pattern(i);
    switch pattern(i)
	case '\\'
	    % Escaped character
	    escaped = 1;
	    continue;
	case {'^', '$', '.', '+', '{', '}'}
	    % Special for regular expressions, must be escaped
	    sub_rx = ['\', sub_rx];
	    
	case '*'
	    if(~in_set)
		% Any character, zero or more times
		sub_rx = '.*';
	    end
	case '?'
	    if(~in_set)
		% Any character, once
		sub_rx = '.';
	    end
	case '['
	    % Start of set of characters
	    if(~in_set)
		in_set = 1;
	    end
	case ']'
	    if(in_set)
		in_set = 0;
	    end
    end
    rx = [rx, sub_rx];
end

% If pattern ended with a backslash, add another backslash to rx
if(escaped)
    rx = [rx, '\\'];
end
rx = [rx, '$'];

%% Use appropriate Matlab built-in function
match = 0;
if(nocase)
    % Case insensitive comparison
    if(~isempty(regexpi(str, rx)))
	match = 1;
    end
else
    % Case insensitive comparison
    if(~isempty(regexp(str, rx)))
	match = 1;
    end
end
end

% Replace sub-strings in string
% -----------------------------
function [rstr] = strfun_map(mapping, str, nocase)
%% Check string
rstr = '';
slen = length(str);
if(slen == 0)
    return;
end

%% Check mapping
mlen = length(mapping);
if(mlen == 0)
    rstr = str;
    return;
end

%% Loop over all characters of string and find matching sub-strings
i = 1;
while(i <= slen)
    % Loop over all strings in map
    matched = false;
    for j=1:2:mlen
	mslen = length(mapping{j});
	
	% Use case-insensitive match if specified
	if(nocase)
	    if(strncmpi(mapping{j}, str(i:slen), mslen))
		matched = true;
	    end
	else
	    if(strncmp(mapping{j}, str(i:slen), mslen))
		matched = true;
	    end
	end
	
	% Check if a match was found
	if(matched)
	    rstr = [rstr mapping{j+1}];
	    i = i + mslen;
	    break;
	end
    end
    
    % Add character from string if no match was found
    if(~matched)
	rstr = [rstr str(i)];
	i = i + 1;
    end
end
end

% Reverse string
% --------------
function [rstr] = strfun_reverse(str)
%% Reverse string
slen=length(str);
rstr = '';
for i=1:slen
    rstr = [rstr, str(slen-i+1)];
end
end

% Repeat string a specified number of times
% -----------------------------------------
function [rstr] = strfun_repeat(str, n)
%% Repeat string the <n> times
rstr = '';
for i=1:n
    rstr = [rstr, str];
end
end

% Get character at specified index
% --------------------------------
function [rstr] = strfun_index(str, idx)
%% Get character at specified index
slen = length(str);
rstr = '';
if(idx >= 1 && idx <= slen)
    rstr = str(idx);
end
end

% Get range of character between specified indexes
% ------------------------------------------------
function [rstr] = strfun_range(str, idx1, idx2)
%% Check indexes
slen = length(str);
rstr = '';
if(idx1 > slen || idx2 < 1 || idx1 > idx2)
    return;
end

%% Make sure indexes are within boundaries
if(idx1 < 1)
    idx1 = 1;
end
if(idx2 > slen)
    idx2 = slen;
end

%% Create the resulting string
rstr = str(idx1:idx2);
end

% Replace range of character with a new string
% --------------------------------------------
function [rstr] = strfun_replace(str, idx1, idx2, newstr)
%% Check indexes
slen = length(str);
rstr = str;
if(idx1 > slen || idx2 < 1 || idx1 > idx2)
    return;
end

%% Get the first part of the resulting string
p1 = '';
if(idx1 > 1)
    p1 = str(1:idx1-1);
end

%% Get the last part of the string
p2 = '';
if(idx2 < slen)
    p2 = str(idx2+1:slen);
end

%% Create the resulting string
rstr = [p1, newstr, p2];
end

% Find first occurence of a string in another
% -------------------------------------------
function [ridx] = strfun_first(find_str, str, idx)
ridx = -1;
%% Check index
slen = length(str);
if(idx > slen)
    return;
end
if(idx < 1)
    idx = 1;
end

%% Get sub-string if an index was specified
if(idx > 1)
    str = str(idx:slen);
end

%% Call Matlab build-in strfind
k = strfind(str, find_str);
if(length(k) > 0)
    ridx = k(1) + idx - 1;
end
end

% Find last occurence of a string in another
% ------------------------------------------
function [ridx] = strfun_last(find_str, str, idx)
ridx = -1;
%% Check index
if(idx < 1)
    return;
end

%% Get sub-string if an index was specified
slen = length(str);
if(idx < slen)
    str = str(1:idx);
end

%% Call Matlab build-in strfind
k = strfind(str, find_str);
klen = length(k);
if(klen > 0)
    ridx = k(klen);
end
end

% Trim characters from a string
% -----------------------------
function [tstr] = strfun_trim(str, tchars, trim_left, trim_right)
tstr = '';
slen = length(str);

%% Use characters from tchars when trimming? Default is to trim white-space.
use_tchars = 1;
if(length(tchars) == 0)
    use_tchars = 0;
end

%% Trim characters off end of string
idx2 = slen;
if(trim_right)
    for i=slen:-1:1
	if(use_tchars)
	    if(isempty(strfind(tchars, str(i))))
		break;
	    end
	else
	    if(~isspace(str(i)))
		break;
	    end
	end
	idx2 = i-1;
    end
end

%% Trim characters off start of string
idx1 = 1;
if(trim_left)
    for i=1:idx2
	if(use_tchars)
	    if(isempty(strfind(tchars,str(i))))
		break;
	    end
	else
	    if(~isspace(str(i)))
		break;
	    end
	end
	idx1 = i+1;
    end
end

%% Create resulting string
if(idx1 <= idx2)
    tstr = str(idx1:idx2);
end
end

% Get index of end of word at specified index
% -------------------------------------------
function [ridx] = strfun_wordend(str, idx)
%% Check index
slen = length(str);
ridx = slen+1;
if(idx >= slen)
    return;
end

%% Find end of word
if(idx < 1)
    idx = 1;
end
for i=idx:slen
    if(str(i) == '_' || isstrprop(str(i), 'alphanum'))
	% Still in the word
	continue;
    end
    
    % Word has ended
    ridx = i;
    break;
end
end

% Get start of word at specified index
% ------------------------------------
function [ridx] = strfun_wordstart(str, idx)
%% Check index
ridx = 1;
if(idx <= 1)
    return;
end

%% Find start of word
slen = length(str);
if(idx > slen)
    idx = slen;
end
offs = 0;
for i=idx:-1:1
    if(str(i) == '_' || isstrprop(str(i), 'alphanum'))
	% Still in the word
	offs = 1;
	continue;
    end
    
    % Word has ended
    ridx = i+offs;
    break;
end
end

% Check if string belongs to a character class
% --------------------------------------------
function [r_is] = strfun_is(class, str)
%% Valid booleans
true_str = {'true', '1', 'yes', 'on' };
false_str = {'false', '0', 'no', 'off' };
bool_str = [true_str false_str];

r_is = false;
% Check class
switch lower(class)
    case {'alphanum', 'alnum'}
	% Any alphanumeric character
	if(length(str) > 0)
	    r_is = all(isstrprop(str, 'alphanum'));
	end
	
    case 'alpha'
	% Any alphabetic character
	if(length(str) > 0)
	    r_is = all(isstrprop(str, 'alpha'));
	end
	
    case {'bool', 'boolean'}
	% Any of the boolean forms
	if(any(cell2mat(strfind(bool_str, str))))
	    r_is = true;
	end
	
    case 'control'
	% Any control character
	if(length(str) > 0)
	    r_is = all(isstrprop(str, 'cntrl'));
	end
	
    case 'digit'
	% Any numeric digit character
	if(length(str) > 0)
	    r_is = all(isstrprop(str, 'digit'));
	end
	
    case 'double'
	% Any of the valid forms for a double
	dval = str2double(str);
	if(isfinite(dval))
	    r_is = true;
	end
	
    case 'false'
	% Any of the false boolean forms
	if(any(cell2mat(strfind(false_str, str))))
	    r_is = true;
	end
	
    case {'graphic', 'graph'}
	% Any graphic character (no white-space)
	if(length(str) > 0)
	    r_is = all(isstrprop(str, 'graphic'));
	end
	
    case {'integer', 'int'}
	% Any of the valid forms for an integer
	[ival, count, errmsg, nidx] = sscanf(str, '%i', 1);
	if(count == 1 && nidx > length(str) ...
		&& ival < intmax() && ival > intmin())
	    r_is = true;
	end
	
    case 'lower'
	% Any lower case alphabet character
	if(length(str) > 0)
	    r_is = all(isstrprop(str, 'lower'));
	end

    case 'print'
	% Any printing character, including white-space
	if(length(str) > 0)
	    r_is = all(isstrprop(str, 'print'));
	end

    case 'punct'
	% Any punctuation character
	if(length(str) > 0)
	    r_is = all(isstrprop(str, 'punct'));
	end
	
    case {'wspace', 'space'}
	% Any white-space character
	if(length(str) > 0)
	    r_is = all(isstrprop(str, 'wspace'));
	end

    case 'true'
	% Any of the true boolean forms
	if(any(cell2mat(strfind(true_str, str))))
	    r_is = true;
	end
	
    case 'upper'
	% Any upper case alphabet character
	if(length(str) > 0)
	    r_is = all(isstrprop(str, 'upper'));
	end

    case 'xdigit'
	% Any hexadecimal digit character ([0-9A-Fa-f])
	if(length(str) > 0)
	    r_is = all(isstrprop(str, 'xdigit'));
	end
	
    otherwise
	error(['In strfun(''is'', ...), ' ...
	    'unknown class ''%s'', must be one of:\n' ...
	    '''alphanum'', ''alnum'', ''alpha'', ''bool'', ''boolean'', ' ...
	    '''control'', ''digit'', ''double'', ''false'', ''graphic'', ' ...
	    '''graph'', ''integer'', ''int'', ''lower'', ''print'', ' ...
	    '''punct'', ''wspace'', ''space'', ''true'', ''upper'', ' ...
	    ' or ''xdigit'''], ...
	    class);
end
end
