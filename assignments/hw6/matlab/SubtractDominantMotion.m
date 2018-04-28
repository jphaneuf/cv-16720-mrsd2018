function mask = SubtractDominantMotion(image1, image2)
% input - image1 and image2 form the input image pair
% output - mask is a binary image of the same size
  image1 = double ( image1 );
  image2 = double ( image2 );
  [ h , w ] = size ( image1 );
  M = LucasKanadeAffine(image1, image2); %M warps a pixel in image 2 to image 1. represents motion from image1 to image 2.
  indices = 1 : h*w;
  [ y x ] = ind2sub ( [ h w ] , indices ); %row vectors
  indices = [ x ; y ];
  indices ( 3 , : ) = 1;
  indices_warped = M * indices;
  I_W = interp2 ( double ( image2 ) , indices_warped ( 1 , : ) , indices_warped ( 2 , : )  )';
  err_image   = I_W - reshape ( image1 , [ ] , 1  ) ;
  err_image ( isnan ( err_image ) ) = 0;
  err_image = reshape ( err_image , h , w );

  output_image = err_image;
  buffer = 20;
  output_image = imgaussfilt(output_image , 2 );
  output_image ( 1:buffer , : ) = 0;
  output_image ( ( h-buffer) : h , : ) = 0;
  output_image ( :  , 1:buffer ) = 0;
  output_image ( :  , (w-buffer):w ) = 0;
  m = mean ( mean ( output_image ) );
  %h = fspecial('prewitt' );
  output_image = ( output_image - m ).^2;
  
  output_image = output_image / max ( max ( output_image ) );
  output_image ( isnan ( output_image ) ) = 0;
  for i = 1:1
    output_image = imdilate ( output_image , strel('disk', 6 ) );
    output_image = imerode ( output_image , strel('disk', 3 ) );
  end
  output_image = im2bw  (output_image , 0.1);
  %output_image = bwareaopen(output_image, 50);
  output_image = bwareaopen(output_image, 20);
  mask = output_image;
  %imshow ( output_image , [ ] );
  %pause ( 0.1 );
end
