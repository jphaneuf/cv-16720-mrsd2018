classes = 36;

load('../data/nist36_test.mat', 'test_data', 'test_labels');

load('./nist36_model.mat')
stats = zeros ( 0 , 2 ) % train_acc train_loss test_acc test_loss
[ outputs ] = Classify (W,b,test_data);
[ test_acc, test_loss ] = ComputeAccuracyAndLoss(W, b, test_data, test_labels);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Confusion matrix %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[ val y    ] = max ( test_labels          , [] , 2);               
[ val yhat ] = max ( outputs , [] , 2);  
confusion = zeros ( classes , classes );
plot ( [] , [] ) ; hold on;
set(gca,'Ydir','reverse')
for i = 1 : length(outputs)
  li = y(i); % label
  oi = yhat ( i ); %prediction
  %confusion ( li , oi ) = confusion ( li , oi ) +1;
  if li == oi
    scatter ( oi , li , 'MarkerFaceColor','b', 'MarkerFaceAlpha',.01, ...
        'MarkerEdgeColor' , 'b' , 'MarkerFaceAlpha' , 0.01 )
  else
    scatter ( oi , li , 'MarkerFaceColor','r', 'MarkerFaceAlpha', 1 , ...
        'MarkerEdgeColor' , 'r' , 'MarkerFaceAlpha' , 0.1 )
  end
end
%imshow ( confusion , extent=[ -5 , 5 , -5 , 5 ])
ylabel ('true      label')
xlabel ('predicted label')
title('confusion matrix on nist36 test data')


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
stats ( 1 , : ) = [ test_acc, test_loss];

fprintf('accuracy: %.5f, \t loss: %.5f \n', test_acc, test_loss)
