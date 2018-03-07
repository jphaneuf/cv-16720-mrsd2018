function [text] = extractImageText(fname)
  % [text] = extractImageText(fname) loads the image specified by the path 'fname'
  % and returns the next contained in the image as a string.
  img = imread ( fname );
  [lines, bw] = findLetters( img );
  hold off;
  imshow ( bw );
  hold on;
  for line = 1: length ( lines ) %horizontal line
    %for letter = 1 : length ( line )
    letter_boxes = lines{line}{1};
    [ n_letters x ] = size (letter_boxes);
    for b = 1 : n_letters
      box = lines {line}{1}(b,:);
      boxx = [box(1) , box(2) , (box(3)-box(1)) , (box(4) - box(2)) ];
      rectangle('pos' , boxx );
    end
  end
end
