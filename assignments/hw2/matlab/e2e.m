

filters = createFilterBank();




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Q1.2 img generation%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%{
img = imread('../data/airport/sun_aerinlrdodkqnypz.jpg');
somanyimgs = extractFilterResponses(img , filters);
figure;

subplot(2,2,1);
imshow ( img );
xlabel ('original')

filter_n = 2 

subplot(2,2,2);
imshow ( somanyimgs(:,:, filter_n ) );
xlabel ('L')

subplot(2,2,3);
imshow ( somanyimgs(:,:, 20 + filter_n ) );
xlabel ('A')

subplot(2,2,4);
imshow ( somanyimgs(:,:, 40 + filter_n ) );
xlabel ('B')

saveas ( gcf , '../doc/img/q12_extract_filters.png' )
%}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Q1.3 Harris corner detection %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%{
%}
%img = imread('../data/airport/sun_aerinlrdodkqnypz.jpg');
npoints = 100;
val = 0.04;
img1 = imread('../data/football_stadium/sun_buiqpmohzvnttvfu.jpg');
points1 = getHarrisPoints(img1, npoints, val);
img2 = imread('../data/airport/sun_aifzfhyaxryjpgpf.jpg');
points2 = getHarrisPoints(img1, npoints, val);
img3 = imread('../data/bedroom/sun_abueimfnkuieazop.jpg');
points3 = getHarrisPoints(img1, npoints, val);

figure;

subplot(1 , 3 , 1)
imshow ( img1)
hold on;
scatter ( points1 ( : , 1 ) , points1 ( : , 2) , 'r+' )

subplot(1 , 3 , 2)
imshow ( img2)
hold on;
scatter ( points2 ( : , 1 ) , points2 ( : , 2) , 'r+' )
xlabel ('Harris corners')

subplot(1 , 3 , 3)
imshow ( img3)
hold on;
scatter ( points3 ( : , 1 ) , points3 ( : , 2) , 'r+' )

saveas ( gcf , '../doc/img/q13_harris.png' )

