%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Build visual word dictionary%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

load('../data/traintest');
imgPaths = train_imagenames;
alpha    = 200;
K        = 75;

dictionary = getDictionary(imgPaths, alpha, K, 'harris');
save( './dictionaryHarris' , 'dictionary' )

dictionary = getDictionary(imgPaths, alpha, K, 'random');
save( './dictionaryRandom' , 'dictionary' )
