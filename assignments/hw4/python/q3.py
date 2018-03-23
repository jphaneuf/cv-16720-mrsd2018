import numpy as np
import skimage.color
from skimage.io        import imread
from skimage.color     import rgb2gray
from skimage.transform import warp
from scipy             import linalg
import matplotlib.pyplot as plt
from q2 import  makeTestPattern, \
                computeBrief   , \
                briefLite      , \
                briefMatch     , \
                plotMatches    , \
                testMatch


################################################################################
################################################################################
################################################################################
# Q 3.1
def computeH(l1, l2):
  # l1 = H l2
  H2to1 = np.eye(3)
  # YOUR CODE HERE
  NH = np.prod ( H2to1.shape ) #N elements in H
  r1 , c1 = l1.shape
  r2 , c2 = l2.shape
  assert r1 == r2 , 'number of rows in l1 does not match l2'
  assert c1 == c2 , 'number of columns in l1 does not match l2'
  ## Formulate Ai for point i ( see writeup section 1.3.3 ) ####################
  ## H matrix in vector form : 
  #### h = transpose ([ h11 h12 h13 h21 h22 h23 h31 h32 h33 ])
  ## Ai = -x -y -1  0  0  0 x*x' y*x' x'
  #        0  0  0 -x -y -1 x*y' y*y' y'
  # Where l1 contains x' , y' and l2 contains x , y
  A = np.empty ( [ 0 , NH ] )
  for i in range ( r1 ):
    xp = l1 [ i , 0 ]
    yp = l1 [ i , 1 ]
    x  = l2 [ i , 0 ]
    y  = l2 [ i , 1 ]
    x_entry = np.hstack ( [ -x , -y , -1 ,  0 ,  0 ,  0 , x*xp , y*xp , xp ] )
    y_entry = np.hstack ( [  0 ,  0 ,  0 , -x , -y , -1 , x*yp , y*yp , yp ] )
    # Ai is 2xNH , first row is x_entry, second row y_entry
    A = np.vstack ( [ A , x_entry ] )
    A = np.vstack ( [ A , y_entry ] )
  #A = np.array ( np.hstack ( [ l1 [ 0 ] , l2 [ 0 ] ] ) )
  u , s , v =  np.linalg.svd ( A )
  H2to1 = v [ -1 ].reshape ( ( 3 , 3 ) )
  H2to1 = H2to1 / H2to1[ 2 , 2 ]
  
  return H2to1    

# Q 3.2
def computeHnorm(l1, l2):
  H2to1 = np.eye(3)
  # YOUR CODE HERE
  l1 = np.copy ( l1 )
  l2 = np.copy ( l2 )
  
  l1 [ : , 0 ] = l1 [ : , 0 ] - np.mean ( l1 [ : , 0 ] )
  l1 [ : , 1 ] = l1 [ : , 1 ] - np.mean ( l1 [ : , 1 ] )
  l2 [ : , 0 ] = l2 [ : , 0 ] - np.mean ( l2 [ : , 0 ] )
  l2 [ : , 1 ] = l2 [ : , 1 ] - np.mean ( l2 [ : , 1 ] )

  l1_max_dist = max ( np.linalg.norm ( l1 [ 0:1 , : ] , axis = 1 ) )
  l2_max_dist = max ( np.linalg.norm ( l2 [ 0:1 , : ] , axis = 1 ) )
  l1 = np.sqrt ( 2 ) * l1 / float ( l1_max_dist )
  l2 = np.sqrt ( 2 ) * l2 / float ( l2_max_dist )

  H2to1 = computeH ( l1 , l2 )
  
  return H2to1   

# Q 3.3
def computeHransac(locs1, locs2):
  bestH2to1, inliers = None, None
  # YOUR CODE HERE
  NSP       = 4    #number of points to sample
  NI        = 3000 # n iterations
  H_TH      = 10   # threshold to accept elements 7/8 in H
  THRESHOLD = 10  #threshold
  assert locs1.shape == locs2.shape , "location inputs sizes differs"
  ND = locs1.shape [ 0 ]
  
  inliers = 0 

  for i in range ( NI ):
    li = np.random.choice ( range ( ND ) , NSP , replace = False )
    l1 = locs1 [ li , : ]
    l2 = locs2 [ li , : ]

    #testi        = np.ones ( ND , dtype = bool )
    #testi [ li ] = False 
    #testi        = np.arange ( ND ) [ testi ]

    #H = computeHnorm  ( l1 , l2 )
    H = computeH  ( l1 , l2 )
    ## debug############
    l1p = np.dot ( H , l2.T ).T
    l1p = l1p / l1p [ : , 2 ] [ : , None ]
    #print l1 
    #print l1p
    ###################


    
    n_inliers_temp = 0
    for i in range ( ND ):
      l1p = np.dot         ( H   , locs2 [ i ] )
      xp  = l1p [ 0 ] / l1p [ 2 ]
      yp  = l1p [ 1 ] / l1p [ 2 ]
      x   = locs1 [ i , 0 ] / locs1 [ i , 2 ] 
      y   = locs1 [ i , 1 ] / locs1 [ i , 2 ] 
      
      #error = np.linalg.norm ( l1p - locs1 [ i ] )
      error = np.sqrt ( ( x - xp ) ** 2 + ( y - yp ) ** 2 )
      #print 'error {}'.format ( error )
      #import pdb;pdb.set_trace ( )
      #print '###'
      #print 'xp {} yp {}'.format(xp , yp)
      #print 'x {} y {}'.format(x , y)
      #print error
      #import pdb; pdb.set_trace ( )
      if error < THRESHOLD:
        n_inliers_temp = n_inliers_temp + 1
        
    if n_inliers_temp > inliers:
      inliers = n_inliers_temp
      bestH2to1 = H
  
  return bestH2to1, inliers

# Q3.4
def compositeH( H2to1, template, img ):
  compositeimg = img
  # YOUR CODE HERE
  
  return compositeimg


def HarryPotterize():
  # we use ORB descriptors but you can use something else
  from skimage.feature import ORB,match_descriptors
  # YOUR CODE HERE
  patchWidth = 9
  nbits      = 256
  makeTestPattern ( patchWidth , nbits )

  cvcov         = rgb2gray ( imread ( '../data/cv_cover.jpg' ) )
  cvdesk        = rgb2gray ( imread ( '../data/cv_desk.png'  ) )
  urawizardarry = rgb2gray ( imread ( '../data/hp_cover.jpg' ) )

  ##############################################################################
  ## q2 version with BRIEF #####################################################
  ##############################################################################
  """
  locs1 , desc1 = briefLite ( cvdesk )
  locs2 , desc2 = briefLite ( cvcov  )
  #import pdb;pdb.set_trace ( )
  matches       = briefMatch     ( desc1 , desc2 , ratio = 0.8 )
  l1 = locs1 [ matches [ : , 0 ] ]
  l2 = locs2 [ matches [ : , 1 ] ]
  l1 = np.hstack ( [ l1 , np.ones ( ( len ( l1 ) , 1 ) ) ] )
  l2 = np.hstack ( [ l2 , np.ones ( ( len ( l2 ) , 1 ) ) ] )
  """


  ##############################################################################
  ## ORB version ###############################################################
  ##############################################################################
  ## Debug note : orb returns row / column

  orb = ORB ( n_keypoints = 200 )

  orb.detect_and_extract ( cvdesk )
  locs1 = orb.keypoints
  desc1 = orb.descriptors
  orb.detect_and_extract ( cvcov )
  locs2 = orb.keypoints
  desc2 = orb.descriptors

  matches = match_descriptors ( desc1 , desc2 , cross_check = True )
  l1 = locs1 [ matches [ : , 0 ] ]
  l2 = locs2 [ matches [ : , 1 ] ]
  l1 = np.hstack ( [ l1 , np.ones ( ( len ( l1 ) , 1 ) ) ] )
  l2 = np.hstack ( [ l2 , np.ones ( ( len ( l2 ) , 1 ) ) ] )

  H , n = computeHransac( l1 , l2 )
  #locsp = [ np.dot ( H , l2point ) for l2point in l2 ]
  #import pdb;pdb.set_trace ( )
  #plotMatches   ( cvdesk , cvcov , matches , locsp , locs2 )
  print H
  warped = warp ( urawizardarry , H )
  
  plt.imshow ( warped )
  plt.show () 
  return

  return 


if __name__ == "__main__":
  l1 = np.array ( [ [ 1 , 2 , 1 ] , 
                    [ 3 , 4 , 1 ] ,
                    [ 5 , 6 , 1 ] ,
                    [ 7 , 8 , 1 ] ] )
  l1 = np.array ( [ [ i , 2*i , 1 ] for i in range ( 200 ) ] )
  l2 = l1
  l2 [ : , 0:1 ] = 2 * l2 [ : , 0:1 ]
  l2 = l2 + np.random.random ( l1.shape )/10
  #H = computeH ( l1 , l2 )
  #H = computeHnorm ( l1 , l2 )
  #H , ni = computeHransac( l1 , l2 )
  #print H
  #print ni
  #print l1 [ 3 ]
  #print np.dot ( H , l2 [ 3 ] )
  HarryPotterize ( )
