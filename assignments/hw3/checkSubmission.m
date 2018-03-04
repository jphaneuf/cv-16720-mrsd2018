function checkSubmission(andrewid)
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
        'Backward.m',
        'Classify.m',
        'ComputeAccuracyAndLoss.m',
        'extractImageText.m', 
        'findLetters.m',
        'finetune36.m',
        'Forward.m',
        'InitializeNetwork.m',
        'Train.m',
        'testFindLetters.m',
        'testExtractImageText.m',
        'train26.m',
        'UpdateParameters.m',
        'define_autoencoder.m',
        'train_autoencoder.m',
        'eval_autoencoder.m'
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