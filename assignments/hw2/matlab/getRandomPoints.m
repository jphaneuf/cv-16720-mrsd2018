function [points] = getRandomPoints(I, alpha)
% Generates random points in the image
% Input:
%   I:                      grayscale image
%   alpha:                  random points
% Output:
%   points:                    point locations ( x , y )
%
	% -----fill in your implementation here --------
  h              = size  ( I , 1 );
  w              = size  ( I , 2 );
  points         = rand  ( alpha , 2 );
  points( : , 1) = round ( w * points ( : , 1 ) );
  points( : , 2) = round ( h * points ( : , 2 ) );

end
