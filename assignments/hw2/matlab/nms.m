function [img_nms] = nms( img )

  [img_height img_width] = size( img );
  img_nms                = zeros( img_height , img_width );

  for x = 2 : img_width - 1 
    for y = 2 : img_height - 1
      %vector-> x,y, track padded x,y
      center_pixel = img ( y , x );
      neighbors    = img ( (y-1):(y+1) , (x-1):(x+1) );
      neighbors(5) = 0;
      if all( all ( center_pixel > neighbors ));
        img_nms ( y , x ) = img ( y , x );
      end
    end
  end

end
