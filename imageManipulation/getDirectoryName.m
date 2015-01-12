function name = getDirectoryName(path)
% name = getDirectoryName(path)
%
% extracts the directory name from the path to a directory

% clip trailing slash
if strcmp(path(end), '/') || strcmp(path(end), '\')
    path(end) = [];
end

% find slash Inds 
slashInds = [strfind(path, '\'), strfind(path, '/')];

name = path(max(slashInds)+1:end);