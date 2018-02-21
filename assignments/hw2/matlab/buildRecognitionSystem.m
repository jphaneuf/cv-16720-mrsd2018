%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% buildRecognitionSystem.m
% This script loads the visual word dictionary (in dictionaryRandom.mat or dictionaryHarris.mat) and processes
% the training images so as to build the recognition system. The result is
% stored in visionRandom.mat and visionHarris.mat.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

parpool ('local', 18 )

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

poolobj = gcp('nocreate');
delete(poolobj);


function [x]  = build_labeled_models ( image_paths , trainLabels , ...
                                       dictionary  , filterBank  , ...
                                       point_selection_method )

  %trainFeatures = zeros ( 0 , 0 );
  dictionary_size = size ( dictionary , 1 ) ;
  n_images        = length ( image_paths ) ;

  trainFeatures = zeros ( n_images , dictionary_size );

  parfor i = 1 : length ( image_paths )

    img_path = char ( strcat ( '../data/' , image_paths ( i ) ) )
    img      = imread ( img_path );
    wordMap  = getVisualWords   ( img , dictionary, filterBank );
    h        = getImageFeatures ( wordMap , dictionary_size );
    trainFeatures ( i , : ) = h;

  end
  save ( strcat ( 'vision' , point_selection_method ) , 'dictionary' , 'filterBank' , 'trainFeatures' , 'trainLabels' )
end

