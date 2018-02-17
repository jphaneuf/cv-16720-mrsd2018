function [wordMap] = getVisualWords(I, dictionary, filterBank)
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  % Convert an RGB or grayscale image to a visual words representation, with each
  % pixel converted to a single integer label.   
  % Inputs:
  %   I:              RGB or grayscale image of size H * W * C
  %   filterBank:     cell array of matrix filters used to make the visual words.
  %                   generated from getFilterBankAndDictionary.m
  %   dictionary:     matrix of size 3*length(filterBank) * K representing the
  %                   visual words computed by getFilterBankAndDictionary.m
  % Outputs:
  %   wordMap:        a matrix of size H * W with integer entries between
  %                   1 and K
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %% Convert to grayscale , get image dimensions %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

  if length ( size ( I ) ) == 3
    I = rgb2gray ( I );
  end
  h = size  ( I , 1 );
  w = size  ( I , 2 );

  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %% Extract feature responses and reshape to vector %%%%%%%%%%%%%%%%%%%%%%%%%%%
  %% Compute distance from each pixel feature vector to dictionary %%%%%%%%%%%%%
  %%%% centroids %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %% Get dictionary index of nearest centroid %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

  I_features           = extractFilterResponses( I , filterBank )
  I_features           = reshape ( I_features , h * w , [] )
  distances            = pdist2  ( I_features , dictionary.dictionary )
  [ values , wordMap ] = min     ( distances  , [] , 2 )
  wordMap              = reshape ( wordMap , h , w )
    
end
