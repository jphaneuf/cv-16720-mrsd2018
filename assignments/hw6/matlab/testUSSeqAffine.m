% your code here
function  [ ] = testUSSequenceAffine( )
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  load ( '../data/aerialseq.mat' )   ;
  n_frames = size ( frames , 3 )  ;
  rect = [ 60 ; 117 ; 146 ; 152 ]; % Init bounding box
  for i = 1 : n_frames - 1
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    imshow ( frames ( : , : , i ) );
    %x = rect ( 1 );
    %y = rect ( 2 );
    %w = rect ( 3 ) - rect ( 1 );
    %h = rect ( 4 ) - rect ( 2 );
    %rectangle ( 'Position' , rect' );
    %fuck_rect = [ x , y , w , h ];
    %rectangle ( 'Position' , [ x , y , w , h ]  );
    [ M ] = LucasKanadeAffine( frames ( : , : , i     ) ,  ...
                                  frames ( : , : , i + 1 ) )
    pause ( 0.01 )
  end
  %[u,v] = LucasKanadeInverseCompositional(It, It1, rect)
end
