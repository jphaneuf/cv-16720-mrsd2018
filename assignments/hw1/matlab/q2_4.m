points = [ [10 10]; [15 15]; [20 20] ];
[nrows,ncols] = size(points);
theta = -pi/2:0.01:pi/2;
hold on;
for p=1:nrows
  x = points(p,1);
  y = points(p,2);
  rho= x*cos(theta) + y*sin(theta) 
  plot(theta,rho,'DisplayName',"x="+string(x)+" y="+string(y));
end  
xlabel('theta')
ylabel('rho')
title('Hough space representation');
legend
saveas(gcf,'../doc/img/q2_4.png')

