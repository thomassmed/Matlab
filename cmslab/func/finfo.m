function varargout =  finfo(varargin);
%FINFO wrapper
%
%  Returns proper response to open comtest files as variables
%  for original FINFO type 
%  help general/finfo

% (C) Mattias Hermansson 2014

    
    p = pwd;
    varargout = cell(nargout,1);
    fil=file('normalize',varargin{1});
    
    try
        s = which('finfo','-all');
        [fpath,~,~] = fileparts(s{2});
        
        cd(fpath);
        [p1,p2,p3] = finfo(fil);
        if(iscomtest(fil))
            p2 = 'opencomtest';
            p3 = 'loadcomtest';
        end
        cd(p);
    catch ME
        cd(p);
        rethrow(ME);
    end
    
    if(nargout == 1)
        varargout{1} = p1;
    elseif(nargout == 2)
        varargout{1} = p1;
        varargout{2} = p2;
    elseif(nargout == 3)
        varargout{1} = p1;
        varargout{2} = p2;
        varargout{3} = p3;
    elseif(nargout == 4)
        varargout{1} = p1;
        varargout{2} = p2;
        varargout{3} = p3;
        varargout{4} = [];
    end
end