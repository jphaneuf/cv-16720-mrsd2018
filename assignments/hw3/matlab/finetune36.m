num_epoch = 5;
classes = 36;
%layers = [32*32, 800, classes];
learning_rate = 0.01;

load('../data/nist36_train.mat', 'train_data', 'train_labels')
load('../data/nist36_test.mat', 'test_data', 'test_labels')
load('../data/nist36_valid.mat', 'valid_data', 'valid_labels')

%[W, b] = InitializeNetwork(layers);
load('../data/nist26_model_60iters', 'W', 'b')

stats = zeros ( 0 , 4 ) % train_acc train_loss valid_acc valid_loss
for j = 1:num_epoch
    [W, b] = Train(W, b, train_data, train_labels, learning_rate);

    [train_acc, train_loss] = ComputeAccuracyAndLoss(W, b, train_data, train_labels);
    [valid_acc, valid_loss] = ComputeAccuracyAndLoss(W, b, valid_data, valid_labels);

    stats ( j , : ) = [ train_acc, train_loss , valid_acc, valid_loss];


    fprintf('Epoch %d - accuracy: %.5f, %.5f \t loss: %.5f, %.5f \n', j, train_acc, valid_acc, train_loss, valid_loss)
end

save('statsq321','stats')
save('nist36_model.mat', 'W', 'b')
