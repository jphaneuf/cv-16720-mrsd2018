function checkA1Submission(andrewid)
% checkA1Submission verifies that your submission zip has the correct structure
% and contains all the needed files.
%
%   checkA1Submission(ANDREWID) checks 'ANDREWID.zip' for the correct structure

    errors = 0;
    TMPDIR = '.tmpunzip';
    mkdir(TMPDIR)

    ZIPFILE = strcat(andrewid, '.zip');
    ROOT = strcat(TMPDIR, '/');
    MATLAB = strcat(andrewid, '/matlab');
    CUSTOM = strcat(andrewid, '/custom');

    if exist(ZIPFILE, 'file') == 2
        disp('found');
        unzip(ZIPFILE, TMPDIR)
    else
        fprintf('Could not find handin zip. Please make sure your zipfile is named %s.\n', ZIPFILE)
        errors = errors+1;
        fprintf('Found %d problems.\n', errors)
        return
    end


    matlabfiles = {
        'RGB2Lab.m',
        'batchToVisualWords.m',
        'buildRecognitionSystem.m',
        'createFilterBank.m', 
        'dictionaryHarris.mat', 
        'dictionaryRandom.mat', 
        'evaluateRecognitionSystem.m', 
        'extractFilterResponses.m', 
        'getDictionary.m', 
        'getHarrisPoints.m', 
        'getImageDistance.m', 
        'getImageFeatures.m', 
        'getRandomPoints.m', 
        'getVisualWords.m', 
        'visionHarris.mat', 
        'visionRandom.mat',
        }';

    for i = matlabfiles
        mfile = strcat(ROOT, '/', MATLAB, '/', i{1});
        if exist(mfile, 'file') ~= 2
            fprintf('%s not found.\n', mfile)
            errors = errors+1;
        end
    end

    if errors == 0
        fprintf('Zip file structure looks good.\n')
    else
        fprintf('Found %d problems.\n', errors)
    end

    rmdir(TMPDIR, 's')
end
