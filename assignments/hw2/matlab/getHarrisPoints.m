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
  h = size  ( I , 1 );
  w = size  ( I , 2 );

  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %% Compute X / Y Gradients %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %% and subtract mean%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  gaussian_filter = fspecial( 'gaussian' , 3 , 3 );
  sobel_filter_y  = fspecial( 'sobel' );
  sobel_filter_x  = sobel_filter_y';
  Ix              = imfilter  ( I , sobel_filter_x );
  Iy              = imfilter  ( I , sobel_filter_y );
  Ix              = Ix - mean ( reshape ( Ix , 1 , [] ) );
  Iy              = Iy - mean ( reshape ( Iy , 1 , [] ) );

  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %% Create covariance images %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %% Stores covariance values for each pixel in I %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  Sxx             = imfilter ( Ix .* Ix , gaussian_filter );
  Syy             = imfilter ( Iy .* Iy , gaussian_filter );
  Sxy             = imfilter ( Ix .* Iy , gaussian_filter );

  
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %% Apply eigen value threshold approximation function for each pixel %%%%%%%%%
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  points = zeros ( 0 , 3 );
  for i = 1 : w;
    for j = 1 : h;
      COVij  = double ( [ Sxx( j , i ) Sxy( j , i );Sxy( j , i ) Syy( j , i )]);
      R      = det    ( COVij ) - k * ( trace ( COVij ) ^2 );
      points = [ points ; i j R ];
    end
  end

  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %% Sort points by R value , return top alpha points%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  points = sortrows ( points , 3 , 'descend' );
  points = points   ( 1 : alpha , 1:2 );

end
