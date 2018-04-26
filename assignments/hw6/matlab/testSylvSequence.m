% your code here
function  [ ] = testSylvSequence( )
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  load ( '../data/sylvseq.mat' )   ;
  load ( '../data/sylvbases.mat' )   ;
  n_frames = size ( frames , 3 )  ;
  rect_b = [ 102 ; 62 ; 156 ; 108 ]; % Init bounding box basis
  rect_i = [ 102 ; 62 ; 156 ; 108 ]; % Init bounding inverse compositional
  for i = 1 : n_frames - 1
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    imshow ( frames ( : , : , i ) );
    xb = rect_b ( 1 );
    yb = rect_b ( 2 );
    wb = rect_b ( 3 ) - rect_b ( 1 );
    hb = rect_b ( 4 ) - rect_b ( 2 );

    xi = rect_i ( 1 );
    yi = rect_i ( 2 );
    wi = rect_i ( 3 ) - rect_i ( 1 );
    hi = rect_i ( 4 ) - rect_i ( 2 );

    %rectangle ( 'Position' , rect' );
    rectangle ( 'Position' , [ xb , yb , wb , hb ] , 'EdgeColor' , 'b' , 'LineWidth' , 2 );
    rectangle ( 'Position' , [ xi , yi , wi , hi ] ,'EdgeColor', 'r' );
    [ ub, vb ] = LucasKanadeBasis( frames ( : , : , i     ) ,  ...
                                                frames ( : , : , i + 1 ) ,  ...
                                                rect_b                   ,  ...
                                                bases )
    [ ui, vi ] = LucasKanadeInverseCompositional( frames ( : , : , i     ) ,  ...
                                                frames ( : , : , i + 1 ) ,  ...
                                                rect_i                     )

    rect_b = rect_b + [ ub ; vb ; ub ; vb ]
    rect_i = rect_i + [ ui ; vi ; ui ; vi ]
    pause ( 0.1 );
  end
end
