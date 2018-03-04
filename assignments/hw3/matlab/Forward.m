function [out, act_h, act_a] = Forward(W, b, X)
  % [OUT, act_h, act_a] = Forward(W, b, X) performs forward propogation on the
  % input data 'X' uisng the network defined by weights and biases 'W' and 'b'
  % (as generated by InitializeNetwork(..)).
  %
  % This function should return the final softmax output layer activations in OUT,
  % as well as the hidden layer post activations in 'act_h', and the hidden layer
  % pre activations in 'act_a'.

  [ x nlayers ] = size ( W );
  nhidden = nlayers - 1 ;
  act_a = cell ( nhidden , 1 );
  act_h = cell ( nhidden , 1 );

  act_h{1} = X; % Use X for first input
  for i = 1 : nhidden
    act_a{i} = W{i} * act_h{max ( i - 1 , 1 )} + b{i};
    act_h{i} = sigmoid ( act_a{i} );
  end
  out = softmax ( W{nlayers} * act_h{nlayers -1} + b{nlayers} );
end

function [ x ] = sigmoid ( x )
  x =  1 ./ ( 1 + exp ( - x ) );
end

function [ x ] = softmax ( x )
  x = exp ( x ) / sum ( exp ( x ) ) ;
end
