INPUT_SIZE  = 5;
OUTPUT_SIZE = 10;

layer_spec = [ INPUT_SIZE 20 OUTPUT_SIZE ];
[W, b] = InitializeNetwork(layer_spec);


n_fake_entries = 30000;
data   = zeros ( n_fake_entries , INPUT_SIZE );
train_label = zeros ( n_fake_entries , OUTPUT_SIZE );
for i = 1 : n_fake_entries
  label = unidrnd ( min ( INPUT_SIZE , OUTPUT_SIZE ) );  %, n_fake_entries , 1 )
  data ( i , label ) = 1;
  %label = unidrnd ( min ( INPUT_SIZE , OUTPUT_SIZE ) );  %, n_fake_entries , 1 )
  train_label ( i , label ) = 1;
end



%{
  X = data ( 1 , : )';
  Y = labels ( 1 , : )';
  [ out, act_h, act_a ] = Forward  ( W, b, X );
  [ grad_W , grad_b ]    = Backward ( W, b, X, Y, act_h, act_a)
%}

learning_rate = 0.1;

[W, b] = Train(W, b, data, train_label, learning_rate);

[ labeled_data ] = Apply(W, b, data, train_label);

[ val ind_y ]    = max ( train_label , [] , 2);
[ val ind_yhat ] = max ( labeled_data , [] , 2);

accuracy = sum ( ind_y == ind_yhat ) / n_fake_entries
%[accuracy, loss] = ComputeAccuracyAndLoss(W, b, data, train_label )
