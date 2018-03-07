function [lines, bw] = findLetters( img )
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  % [lines, BW] = findLetters(im) processes the input RGB image and returns a cell
  % array 'lines' of located characters in the image, as well as a binary
  % representation of the input image. The cell array 'lines' should contain one
  % matrix entry for each line of text that appears in the image. Each matrix entry
  % should have size Lx4, where L represents the number of letters in that line.
  % Each row of the matrix should contain 4 numbers [x1, y1, x2, y2] representing
  % the top-left and bottom-right position of each box. The boxes in one line should
  % be sorted by x1 value.
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  [ rows cols ] = size ( img ) ;
  DF_char = strel('rectangle',[ 30 , 20 ]);
  DF_line = strel('rectangle',[ 40 , 300 ]);

  bw       = im2bw ( img  );
  img      = im2bw ( imcomplement ( img ) );
  img_char = img;

  
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %% Extract character position %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

  for i = 1:5
    img_char = imdilate ( img_char , DF_char );
    img_char = imerode  ( img_char , DF_char );
  end

  imshow ( img_char ) ; hold on;
  CC = bwconncomp(img_char);
  S  = regionprops(CC,'Centroid');
  Z = regionprops ( CC , 'BoundingBox' ) ;
  bounding_boxes = reshape ( [Z.BoundingBox] , 4 , [] )';
  centroids = reshape ( [S.Centroid] , 2 , [] )';
  scatter ( centroids ( : , 1 ) , centroids ( : , 2 ) , 'rx' );
  cleval = evalclusters(bounding_boxes ( : , 2 ) ,'gmdistribution','CalinskiHarabasz','KList',[1:30]) ;
  [ ks ys ] = kmeans ( bounding_boxes ( : , 2 ) , cleval.OptimalK );
  for i = 1 : cleval.OptimalK
    x = [ 1 , cols ];
    plot ( x , ones ( 1 , 2 ) * ys ( i ) );
  end
  lines = cell ( cleval.OptimalK , 1)
  for i = 1 : cleval.OptimalK
    li = 1
    for l = find ( ks == i ) %real indices
      letters{li} = bounding_boxes ( l , : );
      li = li+1
    end
    lines{i} = letters
  end
end
