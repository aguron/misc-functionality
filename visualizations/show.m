function varargout = show(varargin)
%SHOW does one of the following:
%   i. opens a figure window (if there is no input argument)
%   ii. makes sure there is a enough memory for a specified number
%      (integer as input argument) of figure windows
%   iii. opens a figure window and displays an image

    global refuse_new_figures
    switch nargin
        case 0
            % open a figure window
            if refuse_new_figures
                figs2close = findall(0,'type','figure');
                disp(['TOO MANY FIGURE WINDOWS OPEN. ',...
                      'See figs2close for list of figures. ',...
                      'Type return and press enter']);
                keyboard;
                close(figs2close)
                pause(2);
                refuse_new_figures = [];
                varargout{1} = figurememorymanagement;
            else
                varargout{1} = figurememorymanagement;
                if refuse_new_figures
                  varargout{1} = show;
                end
            end
        case 1         
            % memory reset
            if refuse_new_figures
                figs2close = findall(0,'type','figure');
                disp(['TOO MANY FIGURE WINDOWS OPEN. ',...
                      'See figs2close for list of figures. ',...
                      'Type return and press enter']);
                keyboard
                close(figs2close)
                refuse_new_figures = [];
                % display image
                if (max(size(varargin{1})) == 1)
                    return
                else
                    varargout{1} = figurememorymanagement;
                    imshow(varargin{1});
                end
            else
                % make sure there is enough memory for the
                % specified number of figure windows
                if (max(size(varargin{1})) == 1)
                    if (varargin{1} > 0)
                        figurememorymanagement;
                        show(varargin{1} - 1);
                        close;
                    else
                        return
                    end
                else
                    varargout{1} = figurememorymanagement;
                    imshow(varargin{1});
                end
            end
        otherwise
            disp('Error: more than one argument')
    end
    
    if isempty(varargout{1}) && (nargout == 1)
      error('Unable to create figure window');
    end
end