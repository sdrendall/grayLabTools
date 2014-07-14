function downsizeForPresentation(vsiPath)

    r = bfGetReader(vsiPath);

    nr = r.getSizeY();
    nc = r.getSizeX();

    im = zeros([nr, nc, 3], 'uint16');

    im(:,:,2) = bfGetPlane(r, 2);
    im(:,:,3) = bfGetPlane(r, 1);

    brain = findBrainSection(im(:,:,3));
    mask = zeros(size(im));
    for i = 1:3
        mask(:,:,i) = brain;
    end

    im(~mask) = 0;

    im = imresize(im, [NaN, 2048]);
    im = flipflop(im);
    
    im = convertToUint8(im);

    outputPath = generateOutputPath(vsiPath)

    imwrite(im, outputPath);

function im = convertToUint8(im)
    im = mat2gray(im);
    im = uint8(im*255);

function im = flipflop(im)
    im = im(end:-1:1, end:-1:1, :);

function outputPath = generateOutputPath(vsiPath)
    [root, name] = fileparts(vsiPath);
    outputPath = fullfile(root, [name, '_normalized.jpg']);