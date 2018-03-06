function [ labeled_data ] = Apply(W, b, train_data, train_label)
  % [W, b] = Train(W, b, train_data, train_label, learning_rate) trains the network
  % for one epoch on the input training data 'train_data' and 'train_label'. This
  % function should returned the updated network parameters 'W' and 'b' after
  % performing backprop on every data sample.


  % This loop template simply prints the loop status in a non-verbose way.
  % Feel free to use it or discard it


  % We overwrite W and b , yes? or is there some batch trickery?
  labeled_data = zeros ( size ( train_label ) );
  for i = 1:size(train_data,1)
    X = train_data  ( i , : )';
    Y = train_label ( i , : )' ;
    [ out, act_h, act_a ] = Forward  ( W, b, X );
    labeled_data ( i , : ) = out;
  end
end
