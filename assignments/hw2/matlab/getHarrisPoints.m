function [points] = getHarrisPoints(I, alpha, k)
  % Finds the corner points in an image using the Harris Corner detection algorithm
  % Input:
  %   I:                      grayscale image
  %   alpha:                  number of points
  %   k:                      Harris parameter
  % Output:
  %   points:                    point locations
  %
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  if length ( size ( I ) ) == 3
    I = rgb2gray ( I );
  end
  h = size  ( I , 1 );
  w = size  ( I , 2 );


  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %% Compute X / Y Gradients %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %% and subtract mean%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

  mf_size     = 5; % Mean Filter %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  mf          = ones ( mf_size , mf_size ) / mf_size ^ 2;

  [ Ix , Iy ] = imgradientxy ( I );
  Ix          = imfilter ( Ix , mf );
  Iy          = imfilter ( Iy , mf );

  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %% Create covariance images %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %% Stores covariance values for each pixel in I %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  gaussian_filter = fspecial( 'gaussian' , 3 , 3 );
  Sxx             = imfilter ( Ix .* Ix , gaussian_filter );
  Syy             = imfilter ( Iy .* Iy , gaussian_filter );
  Sxy             = imfilter ( Ix .* Iy , gaussian_filter );

  
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %% Apply eigen value threshold approximation function for each pixel %%%%%%%%%
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  covsize = size ( Sxx );
  nmsimg  =  zeros ( h , w )

  parfor i = 1 : h * w;
    [ y , x ] = ind2sub( covsize , i );
    COVij  = double ( [ Sxx( y , x ) Sxy( y , x );Sxy( y , x ) Syy( y , x )]);
    R      = det    ( COVij ) - k * ( trace ( COVij ) ^2 );
    nmsimg ( i ) = R;
  end

  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %% Apply non maximal suppression to corner detect %%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  nmsimg = nms( nmsimg );
 
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %% Sort points by R value , return top alpha points%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  [ val  ind  ] = sort    ( reshape ( nmsimg , 1 , [] ) , 'descend' );
  [ rows cols ] = ind2sub ( size ( nmsimg ) , ind );
  points = vertcat ( cols , rows , val )'
  points = points ( 1 : alpha , 1:2 )

end
