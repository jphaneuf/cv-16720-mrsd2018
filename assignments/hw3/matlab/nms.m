function [img_nms] = nms( img ,window_size)

  %WINDOW_SIZE = 3;
  DI = floor ( window_size / 2 ); % DI index

  [img_height img_width] = size( img );
  img_nms                = zeros( img_height , img_width );

  for x = 1 + DI : img_width - DI
    for y = 1 + DI : img_height - DI 
      center_pixel = img ( y , x );
      neighbors    = img ( (y-DI):(y+DI) , (x-DI):(x+DI) );
      neighbors ( ceil ( ( window_size^2) / 2 ) ) = 0 ;
      if all( all ( center_pixel >= neighbors ));
        img_nms ( y , x ) = img ( y , x );
      end
    end
  end

end
