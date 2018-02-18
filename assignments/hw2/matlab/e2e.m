

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
%img = imread('../data/airport/sun_aerinlrdodkqnypz.jpg');
npoints = 100;
val = 0.04;
img1 = imread('../data/football_stadium/sun_buiqpmohzvnttvfu.jpg');
points1 = getHarrisPoints(img1, npoints, val);
img2 = imread('../data/airport/sun_aifzfhyaxryjpgpf.jpg');
points2 = getHarrisPoints(img2, npoints, val);
img3 = imread('../data/bedroom/sun_abueimfnkuieazop.jpg');
%img3 = imread('../doc/img/cornrer.png');
points3 = getHarrisPoints(img3, npoints, val);

%imshow ( img3)
%hold on;
%scatter ( points3 ( : , 1 ) , points3 ( : , 2) , 'r+' )

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

%}

%Make random
%Make harris
%2*3 ,3 images, 2 classes

figure 

subplot(2 , 3 , 1 )
load ( '../doc/q21data/random/rainforest/sun_aacykkmwtykjfldf.mat' )
imshow( label2rgb ( wordMap ) )
ylabel('rainforest')
subplot(2 , 3 , 2 )
load ( '../doc/q21data/random/rainforest/sun_absitpbkzyrvmnem.mat' )
imshow( label2rgb ( wordMap ) )
subplot(2 , 3 , 3 )
load ( '../doc/q21data/random/rainforest/sun_abafooecdwxfwlob.mat' )
imshow( label2rgb ( wordMap ) )

subplot(2 , 3 , 4 )
load ( '../doc/q21data/random/airport/sun_aexxslabfmbsumkp.mat' )
imshow( label2rgb ( wordMap ) )
ylabel('airport')
subplot(2 , 3 , 5 )
load ( '../doc/q21data/random/airport/sun_aevitxnlfjzhdnti.mat' )
imshow( label2rgb ( wordMap ) )
subplot(2 , 3 , 6 )
load ( '../doc/q21data/random/airport/sun_aerinlrdodkqnypz.mat' )
imshow( label2rgb ( wordMap ) )
saveas ( gcf , '../doc/img/q21_wordmap_random.png' )


figure 

subplot(2 , 3 , 1 )
load ( '../doc/q21data/harris/rainforest/sun_aacykkmwtykjfldf.mat' )
imshow( label2rgb ( wordMap ) )
ylabel('rainforest')
subplot(2 , 3 , 2 )
load ( '../doc/q21data/harris/rainforest/sun_absitpbkzyrvmnem.mat' )
imshow( label2rgb ( wordMap ) )
subplot(2 , 3 , 3 )
load ( '../doc/q21data/harris/rainforest/sun_abafooecdwxfwlob.mat' )
imshow( label2rgb ( wordMap ) )

subplot(2 , 3 , 4 )
load ( '../doc/q21data/harris/airport/sun_aexxslabfmbsumkp.mat' )
imshow( label2rgb ( wordMap ) )
ylabel('airport')
subplot(2 , 3 , 5 )
load ( '../doc/q21data/harris/airport/sun_aetygbcukodnyxkl.mat' )
imshow( label2rgb ( wordMap ) )
subplot(2 , 3 , 6 )
load ( '../doc/q21data/harris/airport/sun_aerinlrdodkqnypz.mat' )
imshow( label2rgb ( wordMap ) )
saveas ( gcf , '../doc/img/q21_wordmap_harris.png' )
