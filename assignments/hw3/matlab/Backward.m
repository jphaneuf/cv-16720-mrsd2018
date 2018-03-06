function [grad_W, grad_b] = Backward(W, b, X, Y, act_h, act_a)
  % [grad_W, grad_b] = Backward(W, b, X, Y, act_h, act_a) computes the gradient
  % updates to the deep network parameters and returns them in cell arrays
  % 'grad_W' and 'grad_b'. This function takes as input:
  %   - 'W' and 'b' the network parameters
  %   - 'X' and 'Y' the single input data sample and ground truth output vector,
  %     of sizes Nx1 and Cx1 respectively
  %   - 'act_h' and 'act_a' the network layer pre and post activations when forward
  %     forward propogating the input smaple 'X'
  [ n_layers garbage ] = size ( act_h );
  grad_W         = cell   ( 1 , n_layers );
  grad_b         = cell   ( 1 , n_layers );

  %% 1. cut a hole in a box. jk %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %% 1. Feed forward %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  % already done

  %% 2. Compute error at final layer %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %% d C ( theta ) / d theta = yhat - y  = grad C
  %% output layer error = grad c element wise multiplied by final layer activation 

  %Todo do this programatically for more layers:
  %grad_C =  out - Y;
  out = act_h{n_layers} ;
  grad_C =  out - Y;
  err  =  out .* grad_C ;
  grad_b{ n_layers } = err ;
  grad_W{ n_layers } = err * act_h{ n_layers - 1 }' ;
 
  %% 3. Back propogate errors for other layers %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  for i = fliplr ( 1 : n_layers -1 )
    err = ( W{i+1}' * err ) .* act_h{i};
    grad_b { i } = err;
    if i == 1
      z = X;
    else
      z = act_h { i - 1 };
    end
    grad_W { i } = err * z' ;
      
  end
  

end
