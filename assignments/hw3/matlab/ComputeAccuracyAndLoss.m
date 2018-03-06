function [accuracy, loss] = ComputeAccuracyAndLoss(W, b, data, labels)
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  % [accuracy, loss] = ComputeAccuracyAndLoss(W, b, X, Y) computes the networks
  % classification accuracy and cross entropy loss with respect to the data samples
  % and ground truth labels provided in 'data' and labels'. The function should return
  % the overall accuracy and the average cross-entropy loss.
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

  [ n_points input_size ] = size ( data );

  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %% compute predictions , extract predictions as maximum probability %%%%%%%%%%
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  [ classifications ] = Classify ( W , b , data );
  
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %% Label vectors are one hot, so zeros cancel except for actual label %%%%%%%%
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  loss = mean ( - sum ( labels .* log ( classifications ) , 2 ));
  
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %% Get actual label at predicted ( 1 if success , 0 if not ) %%%%%%%%%%%%%%%%%
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %% Convert one hot and soft max outputs to numeric class %%%%%%%%%%%%%%%%%%%%%
  [ val y    ] = max ( labels          , [] , 2);
  [ val yhat ] = max ( classifications , [] , 2);
  accuracy     = sum ( y  == yhat ) / n_points;

end


function [ cross_entropy_loss_vector ] = cross_entropy_loss ( label_vector , prediction_vector )
  [ val prediction ] = max ( label_vector )
end
