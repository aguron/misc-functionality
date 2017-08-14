function varargout=figurememorymanagement(varargin)
%FIGUREMEMORYMANAGEMENT prevents Matlab from crashing when opening many figures
% (http://stackoverflow.com/questions/6201272/how-to-avoid-matlab-
%  crash-when-opening-too-many-figures)
%
% Modified by Akinyinka Omigbodun 06/30/2013
%   -Renamed from FIGURE to FIGUREMEMORYMANAGEMENT to avoid naming conflict
%   -Changed "garbace" to "garbage" on line 19
% Modified by Akinyinka Omigbodun 05/01/2015
%   -Ensure that varargout{1} is assigned

    varargout{1} = [];

    % keep at least this amount of bytes free
    memcutoff = 10E6;
    % if memory drops below this, interrupt execution and go to 
    % keyboard mode
    memkeyboard = 3E6;
    global refuse_new_figures
    if refuse_new_figures
        warning('jb:fig:lowjavamem2',...
                ['Java WAS memory low -> refusing to create a new figure. ',...
                 'To reset, type "global refuse_new_figures ;',...
                 'refuse_new_figures = [];"']);
        return
    end
    freemem=java.lang.Runtime.getRuntime.freeMemory;
    if freemem < memcutoff
        fprintf(['Free memory is low (%1.0f Bytes) ->',...
                ' running garbage collector...\n'],freemem);
        java.lang.Runtime.getRuntime.gc
    end
    freemem=java.lang.Runtime.getRuntime.freeMemory;
    % fprintf('Free memory is %1.0f Bytes.\n',freemem);
    if freemem < memkeyboard
        warning('jb:fig:lowjavamem',...
                ['Java memory very low ->',...
                'going into interactive mode. Good luck!']);
        keyboard;
    end
    if freemem < memcutoff
        warning('jb:fig:lowjavamem',...
                'Java memory low -> refusing to create a new figure!');
        refuse_new_figures=true;
    else
        if nargin > 0
            if nargout > 0
                varargout{1}=builtin('figure',varargin{:});
            else
                builtin('figure',varargin{:});
            end
        else
            if nargout > 0
                varargout{1}=builtin('figure');
            else
                builtin('figure');
            end
        end
    end

end

