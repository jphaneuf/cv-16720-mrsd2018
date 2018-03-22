import numpy as np
import skimage.color
import skimage.io
from scipy import linalg



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
  l1 = l1 / float ( l1_max_dist )
  l2 = l2 / float ( l2_max_dist )

  H2to1 = computeH ( l1 , l2 )
  
  return H2to1   

# Q 3.3
def computeHransac(locs1, locs2):
  bestH2to1, inliers = None, None
  # YOUR CODE HERE
  
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
  
  return 


if __name__ == "__main__":
  l1 = np.array ( [ [ 1 , 2 , 1 ] , 
                    [ 3 , 4 , 1 ] ,
                    [ 5 , 6 , 1 ] ,
                    [ 7 , 8 , 1 ] ] )
  l1 = np.array ( [ [ i , 2*i , 1 ] for i in range ( 20 ) ] )
  l2 = l1
  l2 [ : , 0:1 ] = 2 * l2 [ : , 0:1 ]
  l2 = l2 + np.random.random ( l1.shape )/10
  #H = computeH ( l1 , l2 )
  H = computeHnorm ( l1 , l2 )
  print l1 [ 1 ]
  print np.dot ( H , l2 [ 1 ] )
