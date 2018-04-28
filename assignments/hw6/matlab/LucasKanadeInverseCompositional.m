function [u,v] = LucasKanadeInverseCompositional(It, It1, rect)
  %Precompute
  THRESHOLD = 0.00001;
  It = double ( It );
  It1 = double ( It1 );
  [ h , w ] = size ( It );
  max_iters = 1000; 
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
  H = steepest' * steepest;  % Hessian
  u = 10;
  v = 10;
  p = [ 0 ; 0 ];
  %Iterate
  for i = 1 : max_iters
    I_W = interp2 ( double ( It1 ) , ((  x1 : x2 ) + p(1) )' , ( y1 : y2 ) + p ( 2 ) );
    err_image   = reshape ( I_W - T , [ ] , 1 ) ;
    X =  double ( steepest )' * double ( err_image ) ;
    dp = inv ( H ) * X;
    p = p - dp;
    if norm ( dp ) ^2 < THRESHOLD
      %fprintf ( 'exiting iteration %d' , i );
      break;
    end
  end
  u = p ( 1 );
  v = p ( 2 );
end
   

  % input - image at time t, image at t+1, rectangle (top left, bot right coordinates)
  % output - movement vector, [u, v] in the x- and y-directions.
