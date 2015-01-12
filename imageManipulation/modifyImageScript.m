clc
disp('Please Wait')

startPath = uigetdir();

imageStructs = searchForImages(startPath, '.vsi');

numImages = length(imageStructs);

for i = 1:numImages

    tic
    modifyImage(imageStructs(i).path);
    timeElapsed = toc;

    clc % Clear Display

    % Display % progress
    disp('Just Wait Dr. Jin H. Cho, PhD, MSX, 007 Mmk?')

    progress = 100*i/numImages;
    disp(['Progress: ', num2str(progress), '%'])
    % Display Time remaining
    %% Find the average time elapsed for each image
    if (i > 1)
        avgTimeElapsed = (avgTimeElapsed*(i - 1) + timeElapsed)/i;
    else
        avgTimeElapsed = timeElapsed;
    end

    %% Calculate the remaining hours, minutes and seconds remaining
    secondsRemaining = avgTimeElapsed * (numImages - i);
    minutesRemaining = secondsRemaining/60;
    hoursRemaining = minutesRemaining/60;

    % Convert to readable form
    h = round(hoursRemaining);
    m = floor(mod(minutesRemaining, 60)); % Calculate the remainder of remainingMinutes/60
    s = floor(mod(secondsRemaining, 60)); % Calculate the remainder of remainingSeconds/60
    disp(['Approximate time remaining: ', num2str(h), 'h ', num2str(m), 'm ', num2str(s), 's'])
end