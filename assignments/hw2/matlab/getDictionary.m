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

  for i = 1 : length(imgPaths)
    if i == 2
      break
    end
    file_path = strcat( '../data/' , imgPaths ( i ) );
    img = imread( char ( file_path ) );
    img = rgb2gray ( img );
    corners = getHarrisPoints( img , alpha, 0.04 );
    
  end
%  apply filterbank to img
  dictionary = 0
  
    

    % ------------------------------------------
    
end
