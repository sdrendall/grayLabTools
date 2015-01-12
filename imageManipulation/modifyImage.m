function modifyImage(inputPath, outputPath)
    %% modifyImage(inputPath, outputPath)
    % 
    % Downsizes a vsi image and converts it from 16 bit to 8 bit.
    % Does not alter the distribution of pixel intensities
    %
    % If an output path name is not specified, the output image will be
    % saved in the same directory as the input image

    if ~exist('inputPath', 'var')
        inputPath = uigetfile()
    end

    % Default outputPath is in the same directory as the inputPath
    if ~exist('outputPath', 'var')
        [dirPath, filename] = fileparts(inputPath);
        % Strings in matlab are vectors (arrays/lists) of chars, and can be concatenated like so:
        %  ['str1', 'str2'] == 'str1str2'
        outputPath = fullfile(dirPath, [filename, '_modified.png']);  
    end 

    im = loadImage(inputPath);

    % The second argument to imresize can be a single value from 0 to 1.
    % or it can be a vector specifying the dimensions to resize the image to
    %  In this case, NaN tells imresize to scale to the size of the specified dimension
    %  matlab arrays are indexed by [row number, column number]
    im = imresize(im, [NaN, 2048]);
    % Vsis need to be rotated 180 degrees
    im = im';
    
    im = normalizeToUint8(im);

    imwrite(im, outputPath);


function im = loadImage(imagePath)
    % Loads an image using the bioformats toolbox if it is a vsi,
    %  or with imread if it isn't
    [root, name, suffix] = fileparts(imagePath);
    if strcmpi(suffix, '.vsi')
        im = loadVsi(imagePath);
    else
        im = imread(imagePath);
    end

function im = loadVsi(vsiPath)
    % Loads a vsi image
    % Create a vsi reader    
    r = bfGetReader(vsiPath);

    % Allocate memory for the image by creating a null matrix of the same size (assume rbg)
    nr = r.getSizeY();
    nc = r.getSizeX();
    im = zeros([nr, nc, 3]);

    % load planes from vsi into image
    % Vsi color chanels go in the order red, green, blue
    im(:,:,2) = bfGetPlane(r, 2); % Hoechst is plane 2
    %im(:,:,3) = bfGetPlane(r, 1); % FITC is plane 1

function im = uint16ToUint8(im)
    % Convert an image from 8-bit to 16-bit without changing the distribution
    im = double(im)./(2^16 - 1);
    im = uint8(im * 255);


function im = normalizeToUint8(im)
    % NORMALIZES and Converts an image to unsigned 8-bit integer format
    im = normalizeValues(im);
    im = uint8(im*255);
            
function A = normalizeValues(A)
    % Normalize the values of an array such that the lowest value is 0
    %  and the highest is 1.  Returns a double percision array
    A = double(A);
    A = A - min(A);
    A = A ./ max(A);

function im = flipflop(im)
    % Flips an image along both axis
    %  Matlab arrays can be sliced by passing them an array of values
    %  read (end:-1:1) as a vector starting at end (i.e. the last row/column index in a matrix)
    %  that increments by -1 at each subsequent position until it reaches 1
    im = im(end:-1:1, end:-1:1, :); % The : in the third index position means all values

function im = cropImage(im)
    % This function crops out the last (right) three fifths of an image, something that Jin commonly asks for
    [nr, nc, np] = size(im); % Get the number of rows, columns and planes in the image
    im = im(:, round(nc*2/5):end, :);  % RIGHT SIZE - repopulate im with the values from each row, and each plane, from the column
                                        % 2/5 through the number of columns through the last column
    % im = im(:, 1:round(nc*3/5), :) % - LEFT SIDE would crop the left 3/5ths of the image