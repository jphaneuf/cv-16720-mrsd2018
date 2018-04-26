% your code here
function  [ ] = testSylvSequence( )
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  load ( '../data/sylvseq.mat' )   ;
  load ( '../data/sylvbases.mat' )   ;
  n_frames = size ( frames , 3 )  ;
  rect = [ 102 ; 62 ; 156 ; 108 ]; % Init bounding box
  for i = 1 : n_frames - 1
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    imshow ( frames ( : , : , i ) );
    x = rect ( 1 );
    y = rect ( 2 );
    w = rect ( 3 ) - rect ( 1 );
    h = rect ( 4 ) - rect ( 2 );
    %rectangle ( 'Position' , rect' );
    fuck_rect = [ x , y , w , h ];
    rectangle ( 'Position' , [ x , y , w , h ]  );
    [ u, v ] = LucasKanadeBasis( frames ( : , : , i     ) ,  ...
                                                frames ( : , : , i + 1 ) ,  ...
                                                rect                     ,  ...
                                                bases )
    rect
    rect = rect + [ u ; v ; u ; v ]
    pause ( 0.1 );
  end
  %[u,v] = LucasKanadeInverseCompositional(It, It1, rect)
end
