filter_size_offset = 5;
n_filter_sizes     = 5;
fitlers            = createFilterBank();
val_scale          = 1000;

figure;

%img = imread('coins.png')
%img = ones ( 100 , 100 )
%img(20,20:80) = 0
img = imread ( '../img/test.png' );
img = im2double ( img );


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Plot image filters%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for i = 1:4
  subplot  ( 1 , 4 , i ) ;
  filter = filters  ( n_filter_sizes * ( i - 1 ) + filter_size_offset );
  filter = cell2mat ( filter ) * val_scale;
  filter = mat2gray ( filter );
  imshow  ( filter );
end

saveas( gcf , strcat ( '../img/q1_filters.png' ) );

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Apply filters to img%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for i = 1:4
  subplot  ( 1 , 4 , i );
  filter = filters  ( n_filter_sizes * ( i - 1 ) + filter_size_offset );
  filter = cell2mat ( filter );
  filter = mat2gray ( filter );
  imgf   = imfilter ( img , filter ) ;
  imgf   = imgf / unique ( max ( max ( imgf ) ) ) ;
  imshow ( imgf );
end

saveas( gcf , strcat ( '../img/q1_responses.png' ) );
