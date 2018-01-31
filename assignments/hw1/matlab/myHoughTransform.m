function [H, rhoScale, thetaScale] = myHoughTransform(Im, threshold, rhoRes, thetaRes)
  %Your implementation here
  %Im - grayscale image - 
  %threshold - prevents low gradient magnitude points from being included
  %rhoRes - resolution of rhos - scalar
  %thetaRes - resolution of theta - scalar
  % Quantize Parameter Space

  [img_height img_width] = size(Im);
  %thetaScale = deg2rad(0:thetaRes:180);
  %Compared against matlab hough, which appears to use -90 to 90 degree sweep
  thetaScale = deg2rad(-90:thetaRes:90);
  rhoMax = sqrt(img_height^2 + img_width^2);
  rhoScale = 0:rhoRes:sqrt(img_height^2 + img_width^2);
  rhoScale = -rhoMax:rhoRes:rhoMax;
  % Create Accumulator Array H = 0
  H = zeros(length(rhoScale),length(thetaScale));
  % for each edge xi,yi:
  [edge_row edge_col] = find(Im>threshold);
  edges = [edge_row edge_col];
  for e=1:length(edges);
    yi = edges(e,1);
    xi = edges(e,2);
    for ti=1:length(thetaScale);
      theta = thetaScale(ti);
      rho = xi*cos(theta) + yi*sin(theta);
      [val ri] = min(abs(rhoScale-rho));
      H(ri,ti) =H(ri,ti) +1;
    end
  end
end

