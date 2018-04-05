import numpy as np
from   scipy.optimize import fsolve
from   scipy          import linalg
import sympy
import mpmath


def to_homogeneous ( points_in ):
  points = np.copy ( points_in )
  points = np.array ( points )
  points = np.hstack ( ( points , np.ones ( ( points.shape [0] , 1  ) ) ) )
  return points

def from_homogeneous ( points_in ):
  points = np.copy ( points_in )
  points = np.array ( points )
  points = points [ : , 0 : 2 ]
  return points


################################################################################
## Compute matrix to normalize points ##########################################
################################################################################
def getNorm ( points_in ):
  points = np.copy ( points_in )
  points = np.array ( points )
   
  points = np.hstack ( ( points , np.ones ( ( points.shape [0] , 1  ) ) ) )
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

  return H

################################################################################
## Q 2.1 #######################################################################
################################################################################
def eightpoint(pts1_in, pts2_in, M=1):
  # forsyth / ponce say to normalize to origin and to distance from origin
  # fo sqrt (2 ), so not going to use M. sry.

  ## Do I make your heart beat like an eightpoint eight drum ? #################
  assert len ( pts1_in ) == len ( pts2_in )
  pts1 = np.copy ( pts1_in )
  pts2 = np.copy ( pts2_in )
  r , c = pts1_in.shape 
  NF = 9


  ##############################################################################
  ## Normalize points ##########################################################
  ##############################################################################
  Tf  = getNorm ( np.vstack ( ( pts1 , pts2 ) ) )
  #Tf  = np.eye ( 3 )
  #Tf [ 0  , 0 ] = 1 / float ( M )
  #Tf [ 1  , 1 ] = 1 / float ( M )
  pts1 = np.dot ( Tf , to_homogeneous ( pts1 ).T ).T
  pts2 = np.dot ( Tf , to_homogeneous ( pts2 ).T ).T
  #import pdb; pdb.set_trace()


  ##############################################################################
  ## Solve for optimal F #######################################################
  ##############################################################################

  A = np.empty ( [ 0 , NF ] )
  for i in range ( r ):
    xp = pts1 [ i , 0 ]
    yp = pts1 [ i , 1 ]
    x  = pts2 [ i , 0 ]
    y  = pts2 [ i , 1 ]

    entry = np.array ( [ x*xp , x*yp , x ,  y*xp , y*yp , y , xp , yp , 1 ] )
    A = np.vstack ( [ A , entry ] )

  U , S , Vt =  np.linalg.svd ( A )
  F_full_rank = Vt [ -1 , : ].reshape ( ( 3 , 3 ) )
  
  ##############################################################################
  ## Validation: all x' F x close to zero fall points ##########################
  ##############################################################################
  """
  for i in range ( r ):
    x1p = pts1 [ i ]
    x1  = pts2 [ i ]
    print np.dot ( x1p , np.dot ( F_full_rank , x1 ) )
  import pdb;pdb.set_trace ()
  """

  ##############################################################################
  ## Reduce rank by zero-ing minimum singular value ############################
  ##############################################################################
  U , S , Vt = np.linalg.svd ( F_full_rank )
  assert len ( S ) == 3 , 'expected Singular value vector to be length three'
  S [ 2     ] = 0
  S [ 0 : 2 ] = np.sum  ( S ) / float ( 2 )
  S =           np.diag ( S )
  F = np.dot ( U , np.dot ( S , Vt ) )
  F = F.reshape ( ( 3 , 3 ) )

  ##############################################################################
  ## Validation: all x' F x still close to zero and rank of F is now 2 #########
  ##############################################################################
  """
  for i in range ( r ):
    x1p = pts1 [ i ]
    x1  = pts2 [ i ]
    print np.dot ( x1p , np.dot ( F_full_rank , x1 ) )
  print 'state your rank : {}'.format ( np.linalg.matrix_rank ( F ) )
  import pdb;pdb.set_trace ()
  """

  ##############################################################################
  ## Map F to original non-normalized space#####################################
  ##############################################################################
  F = np.dot ( F    , Tf )
  F = np.dot ( Tf.T , F  )

  ##############################################################################
  ## Validation:  F still works in non-normalized space ########################
  ##############################################################################
  """
  pts1 = np.copy ( pts1_in )
  pts2 = np.copy ( pts2_in )
  pts1 = to_homogeneous ( pts1 )
  pts2 = to_homogeneous ( pts2 )
  for i in range ( r ):
    x1p = pts1 [ i ]
    x1  = pts2 [ i ]
    print np.dot ( x1p, np.dot ( F , x1 ) )
  import pdb;pdb.set_trace()
  """
  return F

# Q 2.2
# you'll probably want fsolve
def sevenpoint( pts1_in , pts2_in , M=1):
  assert(pts1_in.shape[0] == 7)
  assert(pts2_in.shape[0] == 7)
  N = 7
  pts1 = np.copy ( pts1_in )
  pts2 = np.copy ( pts2_in )
  NF = 9

  ##############################################################################
  ## Normalize points ##########################################################
  ##############################################################################
  Tf  = getNorm ( np.vstack ( ( pts1 , pts2 ) ) )
  Tf  = np.eye ( 3 )
  Tf [ 0  , 0 ] = 1 / float ( M )
  Tf [ 1  , 1 ] = 1 / float ( M )

  pts1 = np.dot ( Tf , to_homogeneous ( pts1 ).T ).T
  pts2 = np.dot ( Tf , to_homogeneous ( pts2 ).T ).T


  ##############################################################################
  ## Apply SVD and extract right null space vectorz, then reshape ##############
  ##############################################################################

  A = np.empty ( [ 0 , NF ] )
  for i in range ( N ):
    xp = pts1 [ i , 0 ]
    yp = pts1 [ i , 1 ]
    x  = pts2 [ i , 0 ]
    y  = pts2 [ i , 1 ]
    entry = np.array ( [ x*xp , x*yp , x ,  y*xp , y*yp , y , xp , yp , 1 ] )
    A = np.vstack ( [ A , entry ] )

  U , S , Vt =  np.linalg.svd ( A )
  F1 = Vt [ -2 ].reshape ( ( 3 , 3 ) )
  F2 = Vt [ -1 ].reshape ( ( 3 , 3 ) )

  ##############################################################################
  ## Find the one true F. Or three true Fs as the case may be. #################
  ##############################################################################
  f = lambda alpha : np.linalg.det ( alpha * F1 + ( 1 - alpha ) * F2 )
  root = fsolve ( f ,  1 )
  ###can this return a bunch of numbers? meh

  pts1 = np.copy ( pts1_in )
  pts2 = np.copy ( pts2_in )
  pts1 = np.dot ( Tf , to_homogeneous ( pts1_in ).T ).T
  pts2 = np.dot ( Tf , to_homogeneous ( pts2_in ).T ).T

  F = root * F1 + ( 1 - root ) * F2
  F = np.dot ( F    , Tf )
  F = np.dot ( Tf.T , F  )
  return F

  ##############################################################################
  ## Validation:  F still works in non-normalized space ########################
  ##############################################################################
  """
  print F
  for i in range ( N ):
    x1p = pts1 [ i ]
    x1  = pts2 [ i ]
    print np.dot ( x1p, np.dot ( F , x1 ) )
  import pdb;pdb.set_trace()
  """
