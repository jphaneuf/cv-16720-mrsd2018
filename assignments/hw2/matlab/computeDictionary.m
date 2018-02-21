%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Build visual word dictionary%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

delete(gcp('nocreate'))
parpool('local',18)
load('../data/traintest');
imgPaths = train_imagenames;
alpha    = 300;
K        = 100;

dictionary = getDictionary(imgPaths, alpha, K, 'harris');
save( './dictionaryHarris' , 'dictionary' )

dictionary = getDictionary(imgPaths, alpha, K, 'random');
save( './dictionaryRandom' , 'dictionary' )
