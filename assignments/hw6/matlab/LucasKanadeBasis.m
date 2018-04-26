function [u,v] = LucasKanadeBasis(It, It1, rect, bases)

% input - image at time t, image at t+1, rectangle (top left, bot right
% coordinates), bases 
% output - movement vector, [u,v] in the x- and y-directions.
  %Precompute
  THRESHOLD = 0.00001;
  It = double ( It );
  It1 = double ( It1 );
  [ h , w ] = size ( It );
  max_iters = 1000; 
  rect = round ( rect , 6 ); %....really?
  x1 = rect ( 1 );
  y1 = rect ( 2 );
  x2 = rect ( 3 );
  y2 = rect ( 4 );

  T  = interp2 ( It , (  x1 : x2 )' , y1 : y2 );
  %eval gradient of template image 
  [ Ix , Iy ] = imgradientxy( T );
  Ix = reshape ( Ix , [ ] , 1 ) ;
  Iy = reshape ( Iy , [ ] , 1 );
  grad_T = [ Ix ,  Iy ];
  % eval jacobian dw / dp at x;0
  dw_dp = [ 1 0 ; 0 1 ];
  % compute steepest descent images gradient ( T ) dw / dp
  steepest = grad_T * dw_dp ;
  disp ( size ( grad_T ) ) 
  %%%%
  steepest_q = zeros (  size ( steepest , 1 ), 2 );
  A = reshape ( bases , [ ] , size ( bases , 3 ) ); % h*w X number of images
  for x = 1 : size ( bases , 1 ) * size ( bases , 2 )
    i_accum = [ 0 , 0 ];
    for i = 1 : size ( bases , 3 )  
      %Ai = reshape ( bases ( : , : , i ) )
      % reshape Ai : nx1 , steepest nx2 
      %y_accum = sum ( reshape ( Ai , [ ] , 1 ) .* steepest ); %1x2
      %y_accum = sum ( reshape ( bases ( : , : ,  i )  , [ ] , 1 ) .* steepest ); %1x2
      y_accum = sum ( A ( : , i )  .* steepest ); %1x2
      i_accum = i_accum + A( x , i ) * y_accum;
    end
    steepest_q ( x , : ) = i_accum;
  end
  %%%%
  H = steepest' * steepest;  % Hessian
  u = 10;
  v = 10;
  p = [ 0 ; 0 ];
  %Iterate
  for i = 1 : max_iters
    I_W = interp2 ( double ( It1 ) , ((  x1 : x2 ) + p(1) )' , ( y1 : y2 ) + p ( 2 ) );
    err_image   = reshape ( I_W - T , [ ] , 1 ) ;
    X =  double ( steepest )' * double ( err_image ) ;
    dp = inv ( H ) * X
    p = p - dp;
    if norm ( dp ) ^2 < THRESHOLD
      fprintf ( 'exiting iteration %d' , i );
      break;
    end
  end
  u = p ( 1 );
  v = p ( 2 );
end
   

  % input - image at time t, image at t+1, rectangle (top left, bot right coordinates)
  % output - movement vector, [u, v] in the x- and y-directions.
