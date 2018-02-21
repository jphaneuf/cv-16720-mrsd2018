%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Build visual word dictionary%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

parpool('local',18)
load('../data/traintest');
imgPaths = train_imagenames;
alpha    = 400;
K        = 200;

dictionary = getDictionary(imgPaths, alpha, K, 'harris');
save( './dictionaryHarris' , 'dictionary' )

dictionary = getDictionary(imgPaths, alpha, K, 'random');
save( './dictionaryRandom' , 'dictionary' )
