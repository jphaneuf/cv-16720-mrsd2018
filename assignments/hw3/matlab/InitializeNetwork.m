function [W, b] = InitializeNetwork(layers)
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  % InitializeNetwork([INPUT, HIDDEN, OUTPUT]) initializes the weights and biases
  % for a fully connected neural network with input data size INPUT, output data
  % size OUTPUT, and HIDDEN number of hidden units.
  % It should return the cell arrays 'W' and 'b' which contain the randomly
  % initialized weights and biases for this neural network.
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  n_entries = length ( layers );
  W         = cell   ( 1 , n_entries - 1);
  b         = cell   ( 1 , n_entries - 1 );

  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %% Populate layer weights and biases %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  for i = 1 : n_entries -1
    i
    W { i }         = 0.01 * ( 1 - 2 * rand ( layers ( i + 1 ) , layers ( i ) ) );
    b { i }         = 0.01 * ( 1 - 2 * rand ( layers ( i + 1 ) , 1 ) );

  end 
end
