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
  E = [0 0 0 ; 1 0 1; 0 0 0];
  N = E';
  NE =[0 0 1; 0 0 0; 1 0 0];
  NW = flip(NE);
  pad_by = 1;
  filters = [E ; NE ; N ; NW];
  Ior = wrapToPi(Io);
  Ior(find(Ior < 0)) = pi + Ior(find(Ior < 0));
  Ior = round(Ior*4/pi);
  Ior(find(Ior == 4)) = 0;
  Ior(isnan(Ior))=0;

  %%Determine image and filter sizes %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  [img_height img_width] = size(Im);
  img_out = zeros(img_height,img_width);
  Im = padarray(Im,[pad_by pad_by],'symmetric','both');

  %%Iterate on all pixels %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  vector_length = img_height * img_width;
  for i=0:vector_length-1;
    x = mod   (i , img_width  ) + 1;
    y = floor (i / img_width ) + 1;
    img_slice_vector = single(reshape(Im(y:y+2*pad_by,x:x+2*pad_by),1,[]));
    %{
      1
        get vector
        index

gradient_neighbor_indices = 

   x  y
0  +  0
0  -  0 
1  +  + 
1  -  -
2  0  +
2  0  -
3  +  - 
3  -  +
   [xa xb ya yb] = data(Ior(y,x),)     
    %}
    filter = filters(3*Ior(y,x)+(1:3),:);
    filter  = reshape(filter,1,[]) ;
    if pixelvalue > dotproduct:
      img_out(y,x) = dot(img_slice_vector,filter);
    else:
      clear pixelvalue
      img_out(y,x) = dot(img_slice_vector,filter);
  end
  img_out;
end


%archive
%{
[filter_height filter_width] = size(h);
assert(filter_height == filter_width , "That filter is not symmetric bruh");
img = Ior;
pad_by = floor(filter_height/2);
h_vector = reshape(h,1,[]);
%}

