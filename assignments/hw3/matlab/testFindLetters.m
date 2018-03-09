
images = {}
images{1} = '../images/01_list.jpg'
images{2} = '../images/02_letters.jpg'
images{3} = '../images/03_haiku.jpg'
images{4} = '../images/04_deep.jpg'


for i = 1:4
  subplot(2,2,i);
  img_path = images{i}
  img = imread ( img_path );
  %imshow ( img );
  [lines, bw] = findLetters( img );
  imshow ( bw )
  bounding_boxes( lines );

end
set(gcf,'units','normalized','outerposition',[0 0 1 1])



function [ ] = bounding_boxes ( lines )
  for line = 1: length ( lines ) %horizontal line
    for b = 1:size(lines{line} ,1 )
      box = floor ( lines{line}(b,:) );
      if all ( box > 0 )
        %%% rectangle form for plotting bounding boxes : [x y w h]:
        boxx = [box(1) , box(2) , (box(3)-box(1)) , (box(4) - box(2)) ];
        rectangle('pos' , boxx , 'EdgeColor', 'r');
      end
    end
  end
end

%{
function [ imgout ] = resize_and_pad ( img )
  [ rows cols ] = size ( img );
  OUTSIZE = 32;
  imgout = ones ( OUTSIZE , OUTSIZE );% * 255;
  if rows > cols
    scale = OUTSIZE / rows;
    img = imresize ( img , scale );
    [ rows cols ] = size ( img );
    col_index = (OUTSIZE/2) - floor(cols / 2);
    imgout ( : , col_index + 1: col_index + cols ) = img;
  else
    scale = OUTSIZE / cols;
    img = imresize ( img , scale );
    [ rows cols ] = size ( img );
    row_index = (OUTSIZE/2) - floor(rows / 2);
    imgout ( row_index + 1: row_index + rows , : ) = img;
  end
  
end
%}
