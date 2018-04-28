function  [ ] = testUSSequenceAffine( )
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  DEBUG = false;
  load ( '../data/usseq.mat' )   ;
  load ( '../data/usrects.mat' )   ;
  rects = round ( rects );
  n_frames = size ( frames , 3 )  ;
  test_frames = [ 5 , 25 , 50 , 75 , 100 ];
  n_test_frames = numel ( test_frames );

  for i = 1 : n_frames - 1
    if DEBUG
      image_i   = frames ( : , : , i     );
      image_ip1 = frames ( : , : , i + 1 );
      [ mask_whole ] = SubtractDominantMotion( image_i , image_ip1 );
      mask = zeros ( size ( mask_whole ) ); 
      mask         ( rects ( i , 2 ) : rects ( i , 4 ) , rects ( i , 1 ) : rects ( i , 3 ) ) = ...
        mask_whole ( rects ( i , 2 ) : rects ( i , 4 ) , rects ( i , 1 ) : rects ( i , 3 ) );
      fused_image = imfuse ( image_i , mask );
      imshow ( fused_image );
      pause ( 0.001 )

    else
      if ismember ( i + 1  , test_frames )
        plot_i = find ( test_frames == i + 1 );
        subplot ( 1 , n_test_frames , plot_i );
        image_i   = frames ( : , : , i     );
        image_ip1 = frames ( : , : , i + 1 );
        [ mask_whole ] = SubtractDominantMotion( image_i , image_ip1 );
        mask = zeros ( size ( mask_whole ) ); 
        mask         ( rects ( i , 2 ) : rects ( i , 4 ) , rects ( i , 1 ) : rects ( i , 3 ) ) = ...
          mask_whole ( rects ( i , 2 ) : rects ( i , 4 ) , rects ( i , 1 ) : rects ( i , 3 ) );
        fused_image = imfuse ( image_i , mask );
        imshow ( fused_image );
      end
    end
  end
end
