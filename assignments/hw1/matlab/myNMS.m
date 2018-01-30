%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
%%References%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
%{
https://www.mathworks.com/matlabcentral/answers/9641-how-do-i-round-to-the-nearest-arbitrary-enumerated-value-in-matlab
%}

function [img_out] = myNMS(Im, Io)
  %filters = [
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
  %Io = im2double(Io);
  %%round Io to nearest 45 degrees%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
  pad_by = 1;
  Ior = wrapToPi(Io);
  Ior(find(Ior < 0)) = pi + Ior(find(Ior < 0));
  Ior = round(Ior*4/pi);
  Ior(find(Ior == 4)) = 0;
  Ior(isnan(Ior))=0;
  O = Ior +1 %+1 for indexing stupid
  %neighbor offsets relative to center pixel, based on gradient
  % orientation index  : 1   2   3   4
  % degrees            : 0  45  90  135
  gno_x1             = [-1  -1   0   1];
  gno_x2             = [ 1   1   0   1];
  gno_y1             = [ 0  -1  -1   1];
  gno_y2             = [ 0   1   1  -1];

  %%Determine image and filter sizes %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  [img_height img_width] = size(Im);
  img_out = zeros(img_height,img_width);
  Im = padarray(Im,[pad_by pad_by],'symmetric','both');
  O = padarray(O,[pad_by pad_by],'symmetric','both');

  %%Iterate on all pixels %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  vector_length = img_height * img_width;
  for i=0:vector_length-1;
    x = mod   (i , img_width  ) + 1;
    y = floor (i / img_width ) + 1;
    %%Track indices for padded images:
    xp = x+pad_by;
    yp = y+pad_by;
    center_pixel = Im(yp,xp);
    dx1 = gno_x1(O(yp,xp));
    dx2 = gno_x2(O(yp,xp));
    dy1 = gno_y1(O(yp,xp));
    dy2 = gno_y2(O(yp,xp));
    neighbor_1 = Im(yp+dy1,xp+dx1);
    neighbor_2 = Im(yp+dy2,xp+dx2);
    if center_pixel > neighbor_1 && center_pixel > neighbor_2
      img_out(y,x) = Im(yp,xp);
    end
  end
end


