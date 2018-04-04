%% Check the dimensions of function arguments
%%  This is *not* a correctness check
function checkA4Format()
    addpath('matlab');
    load('data/some_corresp.mat', 'pts1', 'pts2');
    load('data/intrinsics.mat', 'K1', 'K2');
    im1 = imread('data/im1.png');
    im2 = imread('data/im2.png');
    
    N = size(pts1, 1);
    M = 100; % place holder
    
    % 2.1
    F8 = eightpoint(pts1, pts2, M);
    assert(isequal(size(F8), [3, 3]), 'eightpoint returns 3x3 matrix');
    
    % 2.2
    F7 = sevenpoint(pts1(1:7, :), pts2(1:7, :), M);
    assert(numel(F7) == 1 || numel(F7) == 3, ...
           'sevenpoint returns length-1/3 cell');
    
    for i = 1 : numel(F7)
        assert(isequal(size(F7{i}), [3, 3]), ...
               'seven returns cell of 3x3 matrix');
    end
    
    % 3.1
    C1 = [eye(3), zeros(3, 1)];
    C2 = [eye(3), ones(3, 1)];
    
    [P, err] = triangulate(C1, pts1, C2, pts2);
    assert(isequal(size(P), [N, 3]), 'triangulate returns Nx3 matrix P');
    assert(numel(err) == 1, 'triangulate returns scalar err');
        
    % 4.1
    [x2, y2] = epipolarCorrespondence(im1, im2, F8, pts1(1, 1), pts1(1, 2));
    assert(numel(x2) == 1 && numel(y2) == 1, ...
           'epipolarCoorespondence returns x & y coordinates');
    
    % 5.1
    F = ransacF(pts1, pts2, M);
    assert(isequal(size(F), [3, 3]), 'ransacF returns 3x3 matrix');
    
    % 5.2
    r = ones(3, 1);
    R = rodrigues(r);
    assert(isequal(size(R), [3, 3]), 'rodrigues returns 3x3 matrix');
    
    R = eye(3);
    r = invRodrigues(R);
    assert(isequal(size(r), [3, 1]), 'invRodrigues returns 3x1 vector)');
    
    % 5.3
    M1 = [eye(3), zeros(3, 1)];
    M2 = [eye(3), ones(3, 1)];
    r2 = ones(3, 1);
    t2 = zeros(3, 1);
    x = [P(:); r2; t2];
    residuals = rodriguesResidual(K1, M1, pts1, K2, pts2, x); 
    assert(isequal(size(residuals), [4 * N, 1]), ...
           'rodriguesResidual returns vector of size 4Nx1');
   
    [M2, P] = bundleAdjustment(K1, M1, pts1, K2, M2, pts2, P);
    assert(isequal(size(M2), [3, 4]), ...
           'bundleAdjustment returns 3x4 matrix M');
    assert(isequal(size(P), [N, 3]), ...
           'bundleAdjustment returns Nx3 matrix P');

    fprintf('Format check passed.\n');
end
