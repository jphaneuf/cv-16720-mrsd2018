%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% buildRecognitionSystem.m
% This script loads the visual word dictionary (in dictionaryRandom.mat or dictionaryHarris.mat) and processes
% the training images so as to build the recognition system. The result is
% stored in visionRandom.mat and visionHarris.mat.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Load training images and dictionaries %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
load ( '../data/traintest.mat');
filterBank = createFilterBank();

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Process model for harris corners %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
load ( 'dictionaryHarris' );
build_labeled_models ( train_imagenames , train_labels , ...
                       dictionary ,       filterBank   , 'Harris' )

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Process model for random points %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
load ( 'dictionaryRandom' );
build_labeled_models ( train_imagenames , train_labels , ...
                       dictionary       , filterBank   , 'Random' )




function [x]  = build_labeled_models ( image_paths , trainLabels , ...
                                       dictionary  , filterBank  , ...
                                       point_selection_method )

  trainFeatures = zeros ( 0 , 0 );

  for i = 1 : length ( image_paths )

    img_path = char ( strcat ( '../data/' , image_paths ( i ) ) )
    img      = imread ( img_path );
    wordMap  = getVisualWords   ( img , dictionary, filterBank );
    h        = getImageFeatures ( wordMap , size ( dictionary , 1 ) )
    trainFeatures = [ trainFeatures ; h' ];

  end
  save ( strcat ( 'vision' , point_selection_method ) , 'dictionary' , 'filterBank' , 'trainFeatures' , 'trainLabels' )
end

