function [text] = extractImageText(fname)
  % [text] = extractImageText(fname) loads the image specified by the path 'fname'
  % and returns the next contained in the image as a string.
  img = imread ( fname );
  [lines, bw] = findLetters( img );
  %hold off;
  %imshow ( bw );
  %hold on;
   
  load('nist26_model');
  characters = {};
  text = '';
  for line = 1: length ( lines ) %horizontal line
    %for letter = 1 : length ( line )
    letter_boxes = lines{line}{1};
    [ n_letters x ] = size (letter_boxes);
    for bi = 1 : n_letters
      % How did we get non-ints here???
      box = floor (lines {line}{1}(bi,:) );
      if all ( box > 0 )
        ch = bw ( box(2):box(4) , box(1):box(3) );
        ch = resize_and_pad ( ch );
        characters{end+1} = ch;
        X = reshape ( ch , [] , 1 );
        [out, act_h, act_a] = Forward(W, b, X);
        [val label] = max ( out );
        %fprintf('detected character %s', char ( 64 + label ) );
        text = strcat ( text , char ( 64 + label ) );
        text = strcat ( text , " "  );
        
        %imshow ( ch , []);
        %pause ( 2 )
        %%% rectangle form for plotting bounding boxes : [x y w h]:
        %boxx = [box(1) , box(2) , (box(3)-box(1)) , (box(4) - box(2)) ];
        %rectangle('pos' , boxx );
      end
    end
    text = strcat ( text, ' \n');
  end
end


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
