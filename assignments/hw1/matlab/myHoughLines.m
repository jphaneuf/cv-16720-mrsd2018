function [rhos, thetas] = myHoughLines(H, nLines)
  %Your implemention here
  %1 cut a hole in the box
  %2 non maximal suprress
  %3get row cols of h not zero, sort, pull nLines
  %[rhos thetas] = find(H >0)

  %%Initialize
  pad_by                 = 1;
  [img_height img_width] = size(H);
  Hnms                   = zeros(img_height,img_width);
  vector_length          = img_height * img_width;

  H = padarray(H , [pad_by pad_by] , 'symmetric' , 'both');

  %%Suppress
  for i=0:vector_length-1;
    %vector-> x,y, track padded x,y
    x  = mod   (i , img_width ) + 1;
    y  = floor (i / img_width ) + 1;
    xp = x + pad_by;
    yp = y + pad_by;

    %Compare center to neighbors and supress if non-maximal
    center_pixel = H( yp , xp );
    neighbors    = H( (yp-1):(yp+1) , (xp-1):(xp+1) );
    neighbors(5) = 0;

    if all( all ( center_pixel > neighbors ));
      Hnms( y , x ) = H( yp , xp );
    end
  end

  %%Find nLines highest votes and sort
  try
    nonzero_indices = find    ( Hnms > 0 );
    votes           = Hnms    ( nonzero_indices );
    [rhos,thetas]   = ind2sub ( size( Hnms ), nonzero_indices );
    [x,order]       = sort    ( votes , 'descend');
    order           = order   ( 1 : nLines );
    votes           = votes   ( order );
    rhos            = rhos    ( order );
    thetas          = thetas  ( order );
  catch
    fprintf('No lines detected, please check parameters');
  end

end
