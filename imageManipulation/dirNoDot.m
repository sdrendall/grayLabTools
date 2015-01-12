function output = dirNoDot(path, infoType)
% output = dirNoDot(path, infoType)
%
% Returns values of the 'dir' function with entries begining with '.'
% removed
%
% infoType is a string denoting the type of information that 
% will be returned
%
% Made some success w/ recursion!!

if ~exist('infoType', 'var')
    infoType = 'all';
end

% Check for cells
if iscell(path)
    % If it's a cell, pull out the string and send it back through
    for i = 1:length(path)
        if ~exist('output', 'var')
            output = dirNoDot(path{i}, infoType);
        else
            output = [output; dirNoDot(path{i}, infoType)];
        end
    end
    
elseif ischar(path)
    output = dir(path);
    output(strncmp({output.name}, '.', 1)) = [];
    
    % Filters out unwanted info
    switch lower(infoType)
        case {'d', 'dir', 'dirs', 'directory', 'directories'}
            output = output([output.isdir]);
        case {'f', 'file', 'files'}
            output = output(~[output.isdir]);
        case 'all'
            return
        otherwise
            warning(['dirNoDot: Unrecognized infoType: ', infoType,' specified.  Returning all data'])
            return
    end
else
    error('dirNoDot: Unsupported object class, please send string or cell array')
end