%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%myImageFilter convolves/filters h with img0%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%img0: input image%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%h: filter%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [ img_out ] = myImageFilter( img0, h )
  %% flip horizontally and vertically for convolution
  %% TODO: switch filter/convolution from keyword argument
  h = flipud( h );
  h = fliplr( h );

  %%Determine image and filter sizes %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  [ img_height img_width ]       = size( img0 );
  [ filter_height filter_width ] = size( h );

  assert( filter_height == filter_width , "That filter is not symmetric bruh" );

  %%Init output image, pad input image %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  pad_by  = floor( filter_height/2 );
  img_out = zeros( img_height , img_width );
  img0    = padarray( img0 , [pad_by pad_by] , 'symmetric', 'both' );

  %%Vectorize filter %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  h_vector = reshape( h, 1 ,[] );

  %%Iterate on all pixels %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  vector_length = img_height * img_width;
  for i=0:vector_length-1;
    x                = mod    ( i , img_width ) + 1;
    y                = floor  ( i / img_width ) + 1;

    img_slice_matrix = img0( y : y + 2*pad_by , x : x + 2*pad_by );
    img_slice_vector = single ( reshape( img_slice_matrix,1,[]));
    img_out(y,x)     = dot    ( img_slice_vector,h_vector);
  end
end
