%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% accuracy and loss plots %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% train_acc train_loss valid_acc valid_loss
load('statsq321')
[ n_epochs , nentries ] = size ( stats )

subplot ( 1 , 2 , 1 );

plot ( 1:n_epochs , stats ( : , 1 ) )
hold on;
xlabel('n epochs');
ylabel('accuracy');
plot ( 1:n_epochs , stats ( : , 3 ) )
legend ( 'training accuracy','validation accuracy' )
title('training accuracy and loss learning 0.01');


subplot ( 1 , 2 , 2 );

plot ( 1:n_epochs , stats ( : , 2 ) )
hold on;
xlabel('n epochs');
ylabel('cross entropy loss');
plot ( 1:n_epochs , stats ( : , 4 ) )
legend ( 'training loss','validation loss' )

return

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% You gotta have a montage %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%{
%load('nist26_model');
[ nW INPUT ]  = size ( W{1} );

%Want [ 32 32 3 400 ]
W1 = double ( W{1} );
W1m = zeros ( [ 32 32 3 400] );
for i = 1 : nW
  img = W1 ( i , : );
  img = img / max ( img ) ;
  img = reshape ( img , [ 32 32 ] );
  img = cat ( 3 , img , img , img );
  W1m ( : , : , : , i ) = img ;
end

montage ( W1m )
%}


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%  montage for nist 36%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%load ('../data/nist26_model_60iters');
load ('./nist36_model');
%classes = 36;
%layers = [32*32, 800, classes];
%[Wi, bi] = InitializeNetwork(layers);
%load('../data/nist26_model_60iters', 'W', 'b')
%L =  length(layers)-1;
%W{L}(27:36,:) = Wi{L}(27:36,:);
%b{L}(27:36,:) = bi{L}(27:36,:);

[ nW INPUT ]  = size ( W{1} );

W1 = double ( W{1} );
W1m = zeros ( [ 32 32 3 800] );
for i = 1 : nW
  img = W1 ( i , : );
  img = img / max ( img ) ;
  img = reshape ( img , [ 32 32 ] );
  img = cat ( 3 , img , img , img );
  W1m ( : , : , : , i ) = img ;
end

montage ( W1m )



