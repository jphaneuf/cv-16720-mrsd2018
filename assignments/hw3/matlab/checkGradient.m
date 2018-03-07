% Your code here.
function [ ] = checkGradient(W, b , data , labels )
  [ x nlayers ] = size ( W );
  
  delta = 0.1;
  for l = 1 : nlayers
    [ rows , cols ] = size ( W{l} );
    rand_wi = randi ( rows * cols ); % – randomly select a dimension in W (b is held constant)

    X = data ( 1 , : );
    y = labels ( 1 , : );

    W{l}(rand_wi) = W{l}(rand_wi) - delta;
    [accuracy, lossn] = ComputeAccuracyAndLoss(W, b, X, y);
    W{l}(rand_wi) = W{l}(rand_wi) + 2*delta;
    [accuracy, lossp] = ComputeAccuracyAndLoss(W, b, data, labels);
    % dC / dw
    loss_check = (lossp - lossn) / delta
    W{l}(rand_wi) = W{l}(rand_wi) - delta; % revert
    [out, act_h, act_a] = Forward(W, b, X');
    [grad_W, grad_b] = Backward(W, b, X', y', act_h, act_a);
    %Should also be dC / dw
    grad_W{l}(rand_wi)
    %[accuracy, lossg] = ComputeAccuracyAndLoss(W, b, data, labels);
    %lossg
    
  end
  %{
  or each layer,
  – add delta to that dimension, compute the loss. Now subtract delta and again
  compute the loss.
  – Use finite differences to estimate the gradient numerically. Compare this with
  gradient value of that dimension using your implementation of Backward( ).
  – repeat using a randomly selected dimension of b (W is held constant)
  – Add the W error and b error, this is your error for that layer
  • Average out the error across layers and print it.
  %}
end

