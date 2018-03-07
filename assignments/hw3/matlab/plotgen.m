
% train_acc train_loss valid_acc valid_loss
load('statsq311')
[ n_epochs , nentries ] = size ( stats )

subplot ( 1 , 2 , 1 );

plot ( 1:n_epochs , stats ( : , 1 ) )
hold on;
xlabel('n epochs');
ylabel('accuracy');
plot ( 1:n_epochs , stats ( : , 3 ) )
legend ( 'training accuracy','validation accuracy' )
title('training accuracy and loss');


subplot ( 1 , 2 , 2 );

plot ( 1:n_epochs , stats ( : , 2 ) )
hold on;
xlabel('n epochs');
ylabel('cross entropy loss');
plot ( 1:n_epochs , stats ( : , 4 ) )
legend ( 'training loss','validation loss' )

