function [ dist ] = getImageDistance( hist1 , histSet , method )
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  % Computes the distance from the feature vector (returned by getImageFeatures
  % or getImageFeaturesSPM) histogram to all of the feature vectors for the
  % training images.
  % Inputs:
  %   hist1:           image1 histogram
  %   hist2:           image2 vector of histograms
  %   method:          string 'euclidean' or 'chi2'

  % Outputs:
  %   dist:          vector of distances between hist1 and histograms in histSet
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  if     method == 'euclidean'
    dist = pdist2 ( hist1 , histSet , 'euclidean' )
  elseif method == 'chi2'
    dist = pdist2 ( hist1 , histSet , 'chisq' )
  end

end
