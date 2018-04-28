% your code here
function  [ ] = testUSSequenceAffine( )
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  load ( '../data/aerialseq.mat' )   ;
  n_frames = size ( frames , 3 )  ;
  for i = 1 : n_frames - 1
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    image_i   = frames ( : , : , i     );
    image_ip1 = frames ( : , : , i + 1 );
    [ mask ] = SubtractDominantMotion( image_i , image_ip1 );
    fused_image = imfuse ( image_i , mask );
    imshow ( fused_image );
    pause ( 0.01 )
  end
end
