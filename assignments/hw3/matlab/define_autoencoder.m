function layers = define_autoencoder()

layers = [
    imageInputLayer([32,32,1])
    % intermediate layers go between here ...
    conv2D(4,1,8,1,2)
    conv2D(4,8,16,1,2)
    conv2D(8,16,64,0,1)
    transpConv2D(8,64,16,0,1)
    transpConv2D(4,16,8,1,2)
    transpConv2D(4,8,1,1,2)
    % ... and here
    regressionLayer
];

