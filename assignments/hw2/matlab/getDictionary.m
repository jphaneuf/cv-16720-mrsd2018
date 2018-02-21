function [dictionary] = getDictionary(imgPaths, alpha, K, method)
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  % Generate the filter bank and the dictionary of visual words
  % Inputs: 
  %   imgPaths:        array of strings that repesent paths to the images
  %   alpha   :        num of points
  %   K       :        K means parameters
  %   method  :        string 'random' or 'harris'
  % Outputs:
  %   dictionary:      a length(imgPaths) * K matrix where each column
  %                       represents a single visual word
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %% Initialize filter bank and pixel responses %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  filterBank     = createFilterBank ();
  depth          = length ( filterBank ) * 3; 
  pixelResponses = zeros  ( 0 , depth  );

  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %% Extract feature vectors from each image %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  parfor i = 1 : length(imgPaths)
    file_path = strcat ( '../data/' , imgPaths ( i ) );
    img       = imread ( char ( file_path ) );

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% Check if image is RGB , convert to gray scale if so %%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %if length ( size ( img ) ) == 3
    %  img = rgb2gray ( img );
    %end

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% Find points of interest on each image in imgPaths %%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    if     strcmp (method , 'harris' )
      corners = getHarrisPoints( img , alpha, 0.04 );
    elseif strcmp (method , 'random' )
      corners = getRandomPoints( img , alpha );
    end

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% Apply filter bank on each point of interest %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    img_filtered = extractFilterResponses(img, filterBank);
    for c = 1 : length(  corners )
      x              =   corners ( c , 1 );
      y              =   corners ( c , 2 );
      row            =   reshape ( img_filtered( y , x , : ) , 1 , [] );
      %pixelResponses = [ pixelResponses ; row ];
      pixelResponses ( i , : ) = row;
    end
  end

  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %% Cluster pixel feature vectors %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  save ('pixelResponses' , 'pixelResponses' )
  [ ~ , dictionary ] = kmeans ( pixelResponses , K , 'EmptyAction' , 'drop');
    
end

