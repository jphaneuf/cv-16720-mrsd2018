function mask = SubtractDominantMotion(image1, image2)
% input - image1 and image2 form the input image pair
% output - mask is a binary image of the same size
  image1 = double ( image1 );
  image2 = double ( image2 );
  [ h , w ] = size ( image1 );
  M = LucasKanadeAffine(image1, image2); %M warps a pixel in image 2 to image 1. represents motion from image1 to image 2.
  indices = 1 : h*w;
  [ y x ] = ind2sub ( [ h w ] , indices ); %row vectors
  %y = y';
  %x = x';
  indices = [ x ; y ];
  indices ( 3 , : ) = 1;
  %It_homog = It;
  %It_homog ( : , 3 ) = 1;
  %It_homog = It_homog';
  indices_warped = M * indices;
  I_W = interp2 ( double ( image1 ) , indices_warped ( 1 , : ) , indices_warped ( 2 , : )  )';
  err_image   = I_W - reshape ( image2 , [ ] , 1  ) ;
  %valid_i = ~ isnan ( err_image );
  err_image ( isnan ( err_image ) ) = 0;
  err_image = reshape ( err_image , h , w );
  se = offsetstrel('ball',5,5);
  output_image = err_image;
  for i = 1:10
    output_image = imdilate ( output_image , se );
    output_image = imerode ( output_image , se );
  end
  output_image = im2bw ( output_image , 0.1 );
  %pause ( 1 );
  imshow ( output_image , [ ] );
  %pause ( 10 );
  %X =  double ( steepest ( valid_i , : )') * double ( err_image ( valid_i ) ) ;
  %X = steepest ( valid_i , : )' * err_image ( valid_i );

    
  mask = 0
end


%{
  %Precompute
  THRESHOLD = 0.00001;
  It  = double ( It );
  It1 = double ( It1 );
  max_iters = 1000; 
  %T  = interp2 ( It , (  x1 : x2 )' , y1 : y2 );
  %eval gradient of template image 
  [ Ix , Iy ] = imgradientxy( It );
  Ix = reshape ( Ix , [ ] , 1 ) ;
  Iy = reshape ( Iy , [ ] , 1 );
  It = reshape ( It , [ ] , 1 );
  %grad_T = [ Ix ,  Iy ];
  % eval jacobian dw / dp at x;0
  %dw_dp = [ x 0 y 0 1 0 ; 0 x 0 y 0 1 ];
  % compute steepest descent images gradient ( T ) dw / dp
  %steepest = grad_T * dw_dp ;
  %zipped = combvec ( 1 : w , 1 : h );
  %x = zipped ( 1 , : )';
  %y = zipped ( 2 , : )';
  indices = 1 : h*w;
  [ y x ] = ind2sub ( [ h w ] , indices );
  y = y';
  x = x';
  steepest = [ Ix .* x , Iy .* x , Ix .* y , Iy .* y , Ix , Iy ];
  H = steepest' * steepest;  % Hessian
  M = [ 1 0 0 ; 0 1 0 ];
  %Iterate
  for i = 1 : max_iters
    indices = [ x , y ];
    indices ( : , 3 ) = 1;
    %It_homog = It;
    %It_homog ( : , 3 ) = 1;
    %It_homog = It_homog';
    %warp it
    indices = indices';
    indices_warped = M * indices;
    I_W = interp2 ( double ( It1 ) , indices_warped ( 1 , : ) , indices_warped ( 2 , : )  )';
    err_image   = reshape ( I_W - It , [ ] , 1 ) ;
    valid_i = ~ isnan ( err_image );
    %X =  double ( steepest ( valid_i , : )') * double ( err_image ( valid_i ) ) ;
    X = steepest ( valid_i , : )' * err_image ( valid_i );
    dp = inv ( H ) * X; % p1 p2 p3 p4 p5 p6
    dM = reshape ( dp , 2 , 3 );
    %dp  = [ 1 + dp_(1) , dp_(3) , dp_(5) ; dp_( 2 ) , 1 + dp_( 4 ) , dp_(6)];
    dM ( 3 , : ) = [ 0 , 0 , 1 ];
    dM ( 1 ,1 ) = dM ( 1 , 1 ) + 1;
    dM ( 2 ,2 ) = dM ( 2 , 2 ) + 1;
    M  ( 3 , : ) = [ 0 , 0 , 1 ];
    M  ( 1, 1 ) = M ( 1 , 1 ) + 1;
    M  ( 2, 2 ) = M ( 2 , 2 ) + 1;
    M = M * inv ( dM );
    M  ( 1 , 1 ) = M ( 1 , 1 ) - 1;
    M  ( 2 , 2 ) = M ( 2 , 2 ) - 1;
    M = M ( 1:2 , : );
    %p = p ( 1:2 , : )
    if norm ( dp ) ^2 < THRESHOLD
      fprintf ( 'exiting iteration %d' , i );
      break;
    end
  end
  %u = p ( 1 );
  %v = p ( 2 );
  %M = p;
end
%}
   

  % input - image at time t, image at t+1, rectangle (top left, bot right coordinates)
  % output - movement vector, [u, v] in the x- and y-directions.
