function  [ ] = testUltraSoundSequence( )
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  DEBUG = true;
  load ( '../data/usseq.mat' )   ;
  n_frames = size ( frames , 3 )  ;
  rect = [ 255 ; 105 ; 310 ; 170 ]; % Init bounding box
  rect_init = rect;
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
    if DEBUG
      imshow ( frames ( : , : , i + 1 ) );
      rectangle ( 'Position' , [ x , y , w , h ] , 'EdgeColor' , 'r' );
      xinit = rect_init ( 1 );
      yinit = rect_init ( 2 );
      winit = rect_init ( 3 ) - rect_init ( 1 );
      hinit = rect_init ( 4 ) - rect_init ( 2 );
      rectangle ( 'Position' , [ xinit , yinit , winit , hinit ] , 'EdgeColor' , 'y' );
      pause ( 10 );
    else
      if ismember ( i + 1 , test_frames )
        plot_i = find ( test_frames == i + 1 );
        subplot ( 1 , n_test_frames , plot_i );
        imshow ( frames ( : , : , i + 1 ) );
        rectangle ( 'Position' , [ x , y , w , h ] , 'EdgeColor' , 'r' );
      end
    end
  end
  save ( '../data/usrects.mat' , 'rects' );
end
