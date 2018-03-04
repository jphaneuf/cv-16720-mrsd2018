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
  classifications     = Classify ( W , b , data );
  [ val predictions ] = max ( classifications , [ ] ,2 );
  
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %% Label vectors are one hot, so zeros cancel except for actual label %%%%%%%%
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  % labels should be one hot. 
  loss =  - log ( classifications .* labels ) ;
  loss = mean ( loss ( ~isinf ( loss ) ) );
  
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %% Get actual label at predicted ( 1 if success , 0 if not ) %%%%%%%%%%%%%%%%%
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  [ x labels ] = ind2sub ( size ( labels ) , find ( labels ) );
  accuracy = sum ( labels == predictions ) / n_points;

end


function [ cross_entropy_loss_vector ] = cross_entropy_loss ( label_vector , prediction_vector )
  [ val prediction ] = max ( label_vector )
end
