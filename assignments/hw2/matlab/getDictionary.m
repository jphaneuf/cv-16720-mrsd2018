function [dictionary] = getDictionary(imgPaths, alpha, K, method)
% Generate the filter bank and the dictionary of visual words
% Inputs:
%   imgPaths:        array of strings that repesent paths to the images
%   alpha:          num of points
%   K:              K means parameters
%   method:         string 'random' or 'harris'
% Outputs:
%   dictionary:         a length(imgPaths) * K matrix where each column
%                       represents a single visual word
    % -----fill in your implementation here --------

   
  filterBank = createFilterBank();
  depth = length(filterBank) * 3; 
  pixelResponses = zeros( 0 , depth );

  parfor i = 1 : length(imgPaths)
    file_path = strcat( '../data/' , imgPaths ( i ) );
    img = imread( char ( file_path ) );
    if length ( size ( img ) ) == 3
      img = rgb2gray ( img );
    end
    if method == 'harris'
      corners = getHarrisPoints( img , alpha, 0.04 );
    elseif method == 'random'
      corners = getRandomPoints( img , alpha, 0.04 );
    end

    img_filtered = extractFilterResponses(img, filterBank);
    for c = 1 : length( corners )
      x = corners(c,1);
      y = corners(c,2);
      row = reshape(img_filtered(y,x,:) , 1 , [] )
      pixelResponses = [ pixelResponses ; row ]
    end
  end
  [ ~ , dictionary ] = kmeans ( pixelResponses , K , 'EmptyAction' , 'drop')
  save( './dictionary' , 'dictionary' )
    
end

