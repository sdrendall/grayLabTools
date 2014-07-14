function downsizeWithoutNormalizing(vsiPath, outputPath)
	%% downsizeWithoutNormalizing(vsiPath, outputPath)
	% 
	% Downsizes a vsi image and converts it from 16 bit to 8 bit.
	% Does not alter the distribution of pixel intensities

	if ~exist('outputPath', 'var')
		[dirPath, filename] = fileparts(vsiPath);
		outputPath = fullfile(dirPath, [filename, '.png']);
	end

	r = bfGetReader(vsiPath);

	nr = r.getSizeY();
	nc = r.getSizeX();

	im = zeros([nr, nc, 3]);

	im(:,:,2) = bfGetPlane(r, 2);
	im(:,:,3) = bfGetPlane(r, 1);

	im = imresize(im, [NaN, 720]);
    im = flipflop(im);
    
	im = uint16ToUint8(im);

	imwrite(im, outputPath);

function im = uint16ToUint8(im)
	im = double(im)./(2^16 - 1);
	im = uint8(im * 255);
    
function im = flipflop(im)
    im = im(end:-1:1, end:-1:1, :);