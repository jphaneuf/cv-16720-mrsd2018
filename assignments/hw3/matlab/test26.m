num_epoch = 30;
classes = 26;
layers = [32*32, 400, classes];

load('../data/nist26_test.mat', 'test_data', 'test_labels')

load('./nist26_model.mat')
stats = zeros ( 0 , 2 ) % train_acc train_loss test_acc test_loss
for j = 1:num_epoch
    [test_acc, test_loss] = ComputeAccuracyAndLoss(W, b, test_data, test_labels);

    stats ( j , : ) = [ test_acc, test_loss];


    fprintf('Epoch %d - accuracy: %.5f, \t loss: %.5f \n', j, test_acc, test_loss)
end

save('statsq313','stats')
