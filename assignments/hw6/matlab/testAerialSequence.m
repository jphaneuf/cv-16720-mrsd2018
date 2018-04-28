% your code here
function  [ ] = testAerialSequence( )
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  DEBUG = false;
  load ( '../data/aerialseq.mat' )   ;
  n_frames = size ( frames , 3 )  ;
  test_frames = [ 30 , 60 , 90 , 120 ];
  n_test_frames = numel ( test_frames );
  for i = 1 : n_frames - 1
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    if DEBUG
      image_i   = frames ( : , : , i     );
      image_ip1 = frames ( : , : , i + 1 );
      [ mask ] = SubtractDominantMotion( image_i , image_ip1 );
      fused_image = imfuse ( image_i , mask );
      imshow ( fused_image );
      pause ( 0.001 )

    else
      if ismember ( i  , test_frames )
        plot_i = find ( test_frames == i  );
        subplot ( 1 , n_test_frames , plot_i );
        image_i   = frames ( : , : , i     );
        image_ip1 = frames ( : , : , i + 1 );
        [ mask ] = SubtractDominantMotion( image_i , image_ip1 );
        fused_image = imfuse ( image_i , mask );
        imshow ( fused_image );
        pause ( 0.001 )
      end
    end


  end
end
