% TODO: load test dataset
%load('../data/nist36_train.mat', 'train_data', 'train_labels')
load('../data/nist36_test.mat', 'test_data', 'test_labels')
%load('../data/nist36_valid.mat', 'valid_data', 'valid_labels')

% TODO: reshape and adjust the dimensions to be in the order of [height,width,1,sample_index]
%train_data = reshape ( train_data' , 32 , 32 , 1 , [] );
%valid_data = reshape ( valid_data' , 32 , 32 , 1 , [] );
test_data  = reshape ( test_data'  , 32 , 32 , 1 , [] );

load('sweet_autoencoder');


NCHARS = 5;
NSAMPLES = 2;
subplot ( 2*NSAMPLES , NCHARS , 1 );
mycharacters = 'LFRAC';
onehots      = [ 12 6 18 31 1 3 ];


for c = 1:NCHARS
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %% Get character we want to check %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %%% Also get onehot index of that label %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  ch = mycharacters ( c );
  label_index = onehots ( c );

  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %% Get rows / cols of ones in label set %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  [ label_rows cols ] = ind2sub ( size ( test_labels ) , find ( test_labels ) );
  ch_entries = label_rows ( cols == label_index );
  rand_entries = randsample ( ch_entries , NSAMPLES );
  
  for i = 1:NSAMPLES
    chi = rand_entries ( i );
    img = test_data ( : , : , 1 , chi );
    subi = 2*NCHARS * ( i - 1 ) + c
    subplot ( 2*NSAMPLES , NCHARS , subi );
    imshow ( img );
    subi = 2*NCHARS * ( i - 1 ) + c + NCHARS
    subplot ( 2*NSAMPLES , NCHARS , subi );
    imgp = predict ( net , img );
    imshow ( imgp );
  end
  subplot ( 2*NSAMPLES , NCHARS , 1 );
  ylabel ('original');
  subplot ( 2*NSAMPLES , NCHARS , 6 );
  ylabel ('autoenc');
  subplot ( 2*NSAMPLES , NCHARS , 11 );
  ylabel ('original');
  subplot ( 2*NSAMPLES , NCHARS , 16 );
  ylabel ('autoenc');
  subplot ( 2*NSAMPLES , NCHARS , 3 );
  title('original input images and autoencoder outputs');


  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
end
% TODO: run predict()
%test_recon = predict(..);
%{
for char in L F R 4 5
  for i = 1 : 2
  load two test images
  predict on both
  reshape prediction?
  plot both
end


get  2 images each 
 and for each selected class include in your report 2 test images and their reconstruction. You
may use test labels to help you find the corresponding classes. The function subplot will
14also be useful. Since dimensionality reduction with autoencoders belong to the class of lossy
compression, the exact original data will not be recovered. What differences do you observe
that exist in the reconstructed test images, compared to the original ones?
%}
