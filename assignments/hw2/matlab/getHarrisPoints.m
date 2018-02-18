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
  [ Ix , Iy ] = imgradientxy ( I );
  Ix              = Ix - mean ( reshape ( Ix , 1 , [] ) );
  Iy              = Iy - mean ( reshape ( Iy , 1 , [] ) );

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
  points = ones ( w * h , 3 );
  covsize = size ( Sxx );

  parfor i = 1 : h * w;
    [ y , x ] = ind2sub( covsize , i );
    COVij  = double ( [ Sxx( y , x ) Sxy( y , x );Sxy( y , x ) Syy( y , x )]);
    R      = det    ( COVij ) - k * ( trace ( COVij ) ^2 );
    points ( i , : ) = [ x y R ];
  end

  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %% Sort points by R value , return top alpha points%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  points = sortrows ( points , 3 , 'descend' );
  points = points   ( 1 : alpha , 1:2 );

end
