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
    x_entry = np.array ( [ -x , -y , -1 ,  0 ,  0 ,  0 , x*xp , y*xp , xp ] )
    y_entry = np.array ( [  0 ,  0 ,  0 , -x , -y , -1 , x*yp , y*yp , yp ] )
    # Ai is 2xNH , first row is x_entry, second row y_entry
    A = np.vstack ( [ A , x_entry ] )
    A = np.vstack ( [ A , y_entry ] )
  u , s , v =  np.linalg.svd ( A )
  H2to1 = v [ -1 ].reshape ( ( 3 , 3 ) )
  H2to1 = H2to1 / H2to1[ 2 , 2 ]
  
  return H2to1    

def normPoints ( points ):
  # expects column entries
  points [ 0 , : ] = points [ 0 , : ] / points [ 2 , : ]
  points [ 1 , : ] = points [ 1 , : ] / points [ 2 , : ]
  points [ 2 , : ] = points [ 2 , : ] / points [ 2 , : ]
  return points

################################################################################
## Compute matrix to normalize points ##########################################
################################################################################
def getNorm ( points_in ):
  points = np.copy ( points_in )
   
  ## Expect points to be nx3 homogenous fyi ####################################
  trans           =   np.eye  ( 3                )
  trans [ 0 , 2 ] = - np.mean ( points [ : , 0 ] )
  trans [ 1 , 2 ] = - np.mean ( points [ : , 1 ] )
  ## transpose to apply transform. untranspose to get distance per point. ######
  ## slice to remove homogenous '1' ############################################
  points_trans = np.dot         ( trans        , points.T ).T
  dists        = np.linalg.norm ( points_trans , axis = 1 )
  max_dist     = np.max     ( dists )

  scale           =   np.eye  ( 3 )
  scale [ 0 , 0 ] =   np.sqrt ( 2 )  / max_dist
  scale [ 1 , 1 ] =   np.sqrt ( 2 )  / max_dist
  H               =   np.dot ( scale , trans )
  H = H / H [ 2 , 2 ]

  return H , normPoints ( np.dot ( H , points.T ) )

# Q 3.2
def computeHnorm(l1, l2):
  # Have a Hart...ley et. al.
  # YOUR CODE HERE
  #import pdb;pdb.set_trace ( )
  l1c = np.copy ( l1 )
  l2c = np.copy ( l2 )

  H1 , l1norm = getNorm ( l1c )
  H2 , l2norm = getNorm ( l2c )

  Hbar = computeH ( l1norm.T , l2norm.T )

  H2to1 = np.dot ( np.linalg.inv ( H1 ) , Hbar )
  H2to1 = np.dot ( H2to1                , H2   )

  H2to1 = H2to1 / H2to1 [ 2 , 2 ] 

 
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

    H = computeHnorm  ( l1 , l2 )
    
    n_inliers_temp = 0
    for i in range ( ND ):
      l1p = np.dot         ( H   , locs2 [ i ] )
      xp  = l1p [ 0 ] / l1p [ 2 ]
      yp  = l1p [ 1 ] / l1p [ 2 ]
      x   = locs1 [ i , 0 ] / locs1 [ i , 2 ] 
      y   = locs1 [ i , 1 ] / locs1 [ i , 2 ] 
      
      error    = np.sqrt ( ( x - xp ) ** 2 + ( y - yp ) ** 2 )
      if error < THRESHOLD:
        n_inliers_temp = n_inliers_temp + 1
        
    if n_inliers_temp > inliers:
      inliers = n_inliers_temp
      bestH2to1 = H
  
  return bestH2to1, inliers

# Q3.4
def compositeH( H2to1, template, img ):
  
  ##############################################################################
  ## composite img #############################################################
  compositeimg = img

  ##############################################################################
  ## Warp Harry Potter and adjust values #######################################
  ##############################################################################
  warped       = warp ( template , H2to1  , output_shape = img.shape , 
                        mode = 'constant' , cval = 0 )
  warped = 255 * warped / np.max ( warped )

  ##############################################################################
  ## Extract indices of non-zero Harry pixels , set them in composite ##########
  ##############################################################################
  indices      = warped       [ : , : , 0   ] != 0
  compositeimg = compositeimg [ : , : , 0:3 ] # what is this 4th thing?
  compositeimg [ indices] = warped [ indices ]
  
  return compositeimg


def HarryPotterize():
  # we use ORB descriptors but you can use something else
  from skimage.feature   import ORB , match_descriptors
  from skimage.transform import resize

  patchWidth = 9
  nbits      = 256
  makeTestPattern ( patchWidth , nbits )

  ##############################################################################
  ## Load images / resize ######################################################
  ##############################################################################
  cvcov         = imread ( '../data/cv_cover.jpg' )
  cvdesk        = imread ( '../data/cv_desk.png'  )
  urawizardarry = imread ( '../data/hp_cover.jpg' ) 
  urawizardarry = resize   ( urawizardarry, cvcov.shape )


  ##############################################################################
  ## Apply ORB descriptors and find correspondences ############################
  ##############################################################################

  orb = ORB ( n_keypoints = 1000 )

  orb.detect_and_extract ( rgb2gray ( cvdesk ) )
  locs1 = orb.keypoints
  desc1 = orb.descriptors
  orb.detect_and_extract ( rgb2gray ( cvcov ) )
  locs2 = orb.keypoints
  desc2 = orb.descriptors

  matches = match_descriptors ( desc1 , desc2 , cross_check = True )
  l1 = locs1 [ matches [ : , 0 ] ]
  l2 = locs2 [ matches [ : , 1 ] ]

  ##############################################################################
  ## Orb returns row / column , following functions expect x / y
  ##############################################################################
  l1 = locs1 [ matches [ : , 0 ] ] [ : , : : -1 ]
  l2 = locs2 [ matches [ : , 1 ] ] [ : , : : -1 ]

  ##############################################################################
  ## Append 1 => homogenous coordinates ########################################
  ##############################################################################
  l1 = np.hstack ( [ l1 , np.ones ( ( len ( l1 ) , 1 ) ) ] )
  l2 = np.hstack ( [ l2 , np.ones ( ( len ( l2 ) , 1 ) ) ] )

  ##############################################################################
  ## Compute transform #########################################################
  ##############################################################################
  H , n = computeHransac( l2 , l1 )

  ##############################################################################
  ## Apply transform ###########################################################
  ##############################################################################
  compositeimg = compositeH( H, urawizardarry , cvdesk)
  plt.imshow ( compositeimg )
  plt.show () 

if __name__ == "__main__":
  """
  l1 = np.array ( [ [ 1 , 2 , 1 ] , 
                    [ 3 , 4 , 1 ] ,
                    [ 5 , 6 , 1 ] ,
                    [ 7 , 8 , 1 ] ] )
  """
  #l1 = np.array ( [ [ i , 2*i , 1 ] for i in range ( 200 ) ] )
  #l2 = np.copy ( l1 )
  #l2 [ : , 0:1 ] = 2 * l2 [ : , 0:1 ]
  #l2 = l2 + np.random.random ( l1.shape )/10
  #H = computeH ( l1 , l2 )
  ##Sanity check 1
  """
  H = computeHnorm ( l1 , l2 )
  print l1
  print np.transpose ( normPoints ( np.dot ( H , l2.T )  ) )
  """
  #l1c = np.copy ( l1 ) 
  #print computeHnorm ( l1 , l1c )
  #print computeHnorm ( l2 , l2 )
  #l1 = np.array ( [ [ 4 , 6 , 1 ] , [ 6 , 6 , 1] , [ 3 , 3 , 1] , [ 7 , 3 , 1] ] )
  #l2 = np.array ( [ [ 1 , 5 , 1 ] , [ 3 , 5 , 1] , [ 1 , 1 , 1] , [ 3 , 1 , 1] ] )
  #print computeHnorm ( l1 , l2 )
  #print computeH ( l1 , l2 )
  HarryPotterize ( )
  
