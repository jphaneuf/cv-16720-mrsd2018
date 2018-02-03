clear;

datadir     = '../data';    %the directory containing the images
resultsdir = strcat('../results_',datestr(now,'ddmmmmyyyy_HH_MM_SS'))
param_file = strcat(resultsdir,'/params.txt')
mkdir(resultsdir)

%parameters
sigma     = 0.5;
threshold = 0.75;
rhoRes    = 0.5;
thetaRes  = 0.5;
nLines    = 100;
%end of parameters

fd = fopen(param_file,'w');
fprintf(fd, 'sigma: %f\n', sigma);
fprintf(fd, 'threshold: %f\n', threshold);
fprintf(fd, 'rhoRes: %f\n', rhoRes);
fprintf(fd, 'thetaRes: %f\n', thetaRes);
fprintf(fd, 'nLines: %f\n', nLines);


imglist = dir(sprintf('%s/*.jpg', datadir));

for i = 1:numel(imglist)
    
    %read in images%
    [path, imgname, dummy] = fileparts(imglist(i).name);
    img = imread(sprintf('%s/%s', datadir, imglist(i).name));
    
    if (ndims(img) == 3)
        img = rgb2gray(img);
    end
    
    img = double(img) / 255;
   
    %actual Hough line code function calls%  
    [Im Io Ix Iy] = myEdgeFilter(img, sigma);   
    [H,rhoScale,thetaScale] = myHoughTransform(Im, threshold, rhoRes, thetaRes);
    [rhos, thetas] = myHoughLines(H, nLines);
    lines = houghlines(Im>threshold, 180*(thetaScale/pi), rhoScale, [rhos,thetas],'FillGap',5,'MinLength',10);
    
    %everything below here just saves the outputs to files%
    fname = sprintf('%s/%s_01edge.png', resultsdir, imgname);
    imwrite(Im/max(Im(:)), fname);
    fname = sprintf('%s/%s_02threshold.png', resultsdir, imgname);
    imwrite(Im > threshold, fname);
    fname = sprintf('%s/%s_03hough.png', resultsdir, imgname);
    imwrite(H/max(H(:)), fname);
    fname = sprintf('%s/%s_04lines.png', resultsdir, imgname);
    
    img2 = img;
    for j=1:numel(lines)
       img2 = drawLine(img2, lines(j).point1, lines(j).point2); 
    end     
    imwrite(img2, fname);
end
    
