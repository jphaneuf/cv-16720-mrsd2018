load('../data/nist36_train.mat', 'train_data', 'train_labels')
load('../data/nist36_test.mat', 'test_data', 'test_labels')
load('../data/nist36_valid.mat', 'valid_data', 'valid_labels')
train_data = reshape ( train_data' , 32 , 32 , 1 , [] );
valid_data = reshape ( valid_data' , 32 , 32 , 1 , [] );
test_data  = reshape ( test_data'  , 32 , 32 , 1 , [] );

layers = define_autoencoder();

options = trainingOptions('sgdm',...
                          'InitialLearnRate',5e-4,...
                          'MaxEpochs',3,...
                          'MiniBatchSize', 10,...
                          'Shuffle','every-epoch',...
                          'Plot','training-progress',...
                          'L2Regularization', 1e-2,...
                          'VerboseFrequency',20);

[ net tr ]  = trainNetwork(train_data , train_data , layers , options )


%{
    Momentum: 0.9000
             InitialLearnRate: 0.0100
    LearnRateScheduleSettings: [1x1 struct]
             L2Regularization: 1.0000e-02
                    MaxEpochs: 20
                MiniBatchSize: 64
                      Verbose: 1
             VerboseFrequency: 50
               ValidationData: []
          ValidationFrequency: 50
           ValidationPatience: 5
                      Shuffle: 'once'
               CheckpointPath: ''
         ExecutionEnvironment: 'auto'
                   WorkerLoad: []
                    OutputFcn: []
                        Plots: 'training-progress'
               SequenceLength: 'longest'
         SequencePaddingValue: 0

%}
