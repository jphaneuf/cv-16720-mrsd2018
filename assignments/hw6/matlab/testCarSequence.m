function  [ ] = testCarSequence( )
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  load ( '../data/carseq.mat' )   ;
  n_frames = size ( frames , 3 )  ;
  rect = [ 60 ; 117 ; 146 ; 152 ]; % Init bounding box
  test_frames = [ 1 , 100 , 200 , 300 , 400 ];
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
    pause ( 0.01 );
    if ismember ( i , test_frames )
      plot_i = find ( test_frames == i );
      subplot ( 1 , n_test_frames , plot_i );
      imshow ( frames ( : , : , i ) );
      rectangle ( 'Position' , [ x , y , w , h ]  );
    end
  end
  %[u,v] = LucasKanadeInverseCompositional(It, It1, rect)
end
