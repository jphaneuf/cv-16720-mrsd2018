%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%myImageFilter convolves/filters h with img0%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%img0: input image%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%h: filter%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [img1] = myImageFilter(img0, h)
  %Builtin padding ok?

  %%Determine image and filter sizes %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  [img_height img_width] = size(img0);
  [filter_height filter_width] = size(h);
  assert(filter_height == filter_width , "That filter is not symmetric bruh");
  pad_by = floor(filter_height/2);

  %%Init output image, pad input image %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  img_out = zeros(img_height,img_width)
  img0 = padarray(img0,[pad_by pad_by],'symmetric','both');

  %%Vectorize filter %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  h_vector = reshape(h,1,[]);

  %%Iterate on all pixels %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  vector_length = img_height * img_width;
  for i=0:vector_length-1;
    x = mod   (i , img_width  ) + 1;
    y = floor (i / img_height ) + 1;
    img_slice_vector = reshape(img0(x:x+2*pad_by,y:y+2*pad_by),1,[]);
    img_out(y,x) = dot(img_slice_vector,h_vector)
  end
  img_out
end
