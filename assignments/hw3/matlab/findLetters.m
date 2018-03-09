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
  DF_char = strel('rectangle',[ 20 , 20 ]);

  img = rgb2gray ( img );
  img = imcomplement ( img );
  T = adaptthresh(img, 0.5);
  img = imbinarize(img,T);
  img = double ( img );
  bw  = double ( imcomplement ( img ) );
  bw ( bw < 0.5 ) = 0.05;
  bw ( bw > 0.95 ) = 0.95;

  img = imgaussfilt(img,2);
  img = bwareaopen(img,1400);
  

  %bw       = imcomplement ( im2bw ( img  ) );
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %% Extract character position %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

  %for i = 1:3
  %  img = imerode  ( img , DF_char );
  %  img = imdilate ( img , DF_char );
  %end
  CC = bwconncomp(img);
  S = regionprops(CC,'Centroid');
  Z = regionprops ( CC , 'BoundingBox' ) ;
  bounding_boxes = reshape ( [Z.BoundingBox] , 4 , [] )';
  cleval = evalclusters(bounding_boxes ( : , 2 ) ,'kmeans','Silhouette','KList',[1:10]) ;
  %cleval = evalclusters(bounding_boxes ( : , 2 ) ,'gmdistribution','CalinskiHarabasz','KList',[1:15]) ;
  [ ks ys ] = kmeans ( bounding_boxes ( : , 2 ) , cleval.OptimalK );
  lines = cell ( cleval.OptimalK , 1);
  [ ~ , kindices ] = sort ( ys );
  for i = kindices'
    lines{i} = zeros(0,4);
    line_boxes = bounding_boxes(ks==i,:);
    %for b = 1 : size ( line_boxes )
    %  scatter ( line_boxes ( b , 1 ) , line_boxes ( b , 2 ) , 'rx' );
    %end
    lines{i} = convert_to_ullr ( line_boxes );
  end
end

function [boxes] = convert_to_ullr ( boxes )
  for b = 1 : size ( boxes , 1 );
    box = boxes ( b , : );
    box = bbox2points ( box );
    % convert to upper left lower right
    box = box ( [ 1 5 3 7 ] ); 
    boxes ( b , : ) = box;
  end
end
