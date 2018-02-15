function [Im Io Ix Iy] = myEdgeFilter(img, sigma)

  %%Convert image format for processing and plotting%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
  img = im2double( img );

  %%Create filters%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
  filter_size     = 2 * ceil( 3*sigma ) + 1;
  gaussian_filter = fspecial( 'gaussian' , filter_size , sigma );
  sobel_filter_y  = fspecial( 'sobel' );
  sobel_filter_x  = sobel_filter_y';

  %%Apply filters%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
  img_blurred = myImageFilter( img         , gaussian_filter );
  Ix          = myImageFilter( img_blurred , sobel_filter_x  );
  Iy          = myImageFilter( img_blurred , sobel_filter_y  );

  %%Generate image magnitude%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
  Im = sqrt( Ix.^2 +  Iy.^2 );
  Io = atan( Iy    ./ Ix    );
  %%Non maximal supression on Im%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
  Im = myNMS( Im , Io );
end
