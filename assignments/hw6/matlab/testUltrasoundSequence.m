function  [ ] = testUltraSoundSequence( )
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  load ( '../data/usseq.mat' )   ;
  n_frames = size ( frames , 3 )  ;
  rect = [ 255 ; 105 ; 310 ; 170 ]; % Init bounding box
  rects = [ rect' ] ;
  test_frames = [ 5 , 25 , 50 , 75 , 100 ];
  n_test_frames = numel ( test_frames );
  for i = 1 : n_frames - 1
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    x = rect ( 1 );
    y = rect ( 2 );
    w = rect ( 3 ) - rect ( 1 );
    h = rect ( 4 ) - rect ( 2 );
    [ u, v ] = LucasKanadeInverseCompositional( frames ( : , : , i     ) ,  ...
                                                frames ( : , : , i + 1 ) ,  ...
                                                rect                       );
    rect = rect + [ u ; v ; u ; v ];
    rects = [ rects ; rect' ] ;
    pause ( 0.01 );
    if ismember ( i , test_frames )
      plot_i = find ( test_frames == i );
      subplot ( 1 , n_test_frames , plot_i );
      imshow ( frames ( : , : , i ) );
      rectangle ( 'Position' , [ x , y , w , h ] , 'EdgeColor' , 'r' );
    end
  end
   
  save ( '../data/usrects.mat' , 'rects' );
end
