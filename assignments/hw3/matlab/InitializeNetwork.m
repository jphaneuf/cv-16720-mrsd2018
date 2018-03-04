function [W, b] = InitializeNetwork(layers)
  % InitializeNetwork([INPUT, HIDDEN, OUTPUT]) initializes the weights and biases
  % for a fully connected neural network with input data size INPUT, output data
  % size OUTPUT, and HIDDEN number of hidden units.
  % It should return the cell arrays 'W' and 'b' which contain the randomly
  % initialized weights and biases for this neural network.
  n_entries = length ( layers );
  W         = cell(n_entries,1);
  b         = cell(n_entries,1);
  INPUT     = layers ( 1 ) ;
  HIDDEN    = layers ( 2 : length ( layers ) - 1 );
  OUTPUT    = layers  ( length ( layers ) ) ;

  W { 1 }         = rand ( INPUT  , 1 )
  W { n_entries } = rand ( OUTPUT , 1 )
  b { 1 }         = rand 
  b { n_entries } = rand

  index = 2
  for  n = HIDDEN
    W { index } = rand ( n  , 1 )
    b { index } = rand 
    index       = index + 1
  end

end
