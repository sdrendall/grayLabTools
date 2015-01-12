function images = searchForImages(startPath, filetype)
% images = searchForImages(startPath)
%
% Recursively searches for images, starting at startPath
% Returns a structure 'images' that contains the image's filename (name), path,
% and its containing directory's path
%
% returns a structure images that includes the output of the dir function
% plus:
%   path: path pointint to the image file
%   originalDir: the path of the directory containing the image file
%   originalDirName: the name of the directory containing the image file

% test inputs
% make filetype tif by default
if ~exist('filetype', 'var')
    filetype = '.tif';
else
    % check for dot
    if ~strcmp(filetype(1), '.')
        filetype = ['.', filetype];
    end
end

if ~exist('startPath', 'var')
    startPath = uigetdir('~', 'Specify start path for search');
    % Recursively handle cells
elseif iscell(startPath)
    images = [];
    for iPath = 1:length(startPath)
        incomingImages = searchForImages(startPath{iPath});
        images = [images, incomingImages];
    end
    return
elseif ~ischar(startPath)
    error('searchForImages:InvalidInput',['Input "', startPath, 'is of invalid class: ', class(startPath)])
end


%----------------Function Main----------------%
startPath = fullfile(startPath);

% Search current directory
cdContents = dirNoDot(startPath);
if length(cdContents) == 0
    images = [];
    return
end

% Unpack cdContents
% Get suffixes -- because MATLAB is so lame that it won't let me do this in
% one line...
for iEntry = 1:length(cdContents)
    if length(cdContents(iEntry).name) >= length(filetype)
        entrySuffixes{iEntry} = cdContents(iEntry).name(end-length(filetype)+1:end);
    else
        entrySuffixes{iEntry} = cdContents(iEntry).name;
    end
end

% Seperate images -- search the end of each name in cdContents for the
% desired filetype.  Don't include directories
images = cdContents(strcmp(entrySuffixes, filetype));

% Add path and originalDir to each image struct
for iIm = 1:length(images)
    images(iIm).path = fullfile(startPath, images(iIm).name);
    images(iIm).originalDir = startPath;
    images(iIm).originalDirName = getDirectoryName(startPath);
end

% Get directories
directories = cdContents([cdContents(:).isdir]);

% Recursively search directories
for iDir = 1:length(directories)
    if isempty(images)
        images = searchForImages([startPath, directories(iDir).name], filetype);
    else
        incomingImages = searchForImages([startPath, directories(iDir).name], filetype);
        if ~isempty(incomingImages)
            [images, incomingImages] = reconcileStructureFields(images, incomingImages);
            images = [images; incomingImages];
        end
    end
end