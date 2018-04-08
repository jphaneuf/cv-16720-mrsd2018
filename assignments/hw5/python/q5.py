import numpy as np
from q2 import eightpoint, sevenpoint , getNorm
from q3 import triangulate
from scipy.optimize import minimize



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
## Q.5.1 #######################################################################
## Compute Fundamental Matrix using RANSAC #####################################
################################################################################
# we're going to also return inliers

def ransacF(pts1, pts2, M):
  NSP       = 8    #number of points to sample
  NI        = 3000 # n iterations
  THRESHOLD = 0.01  #threshold , pixels?
  assert pts1.shape == pts2.shape , "point input sizes differ dummy"
  ND = pts1.shape [ 0 ]
  Tf  = getNorm ( np.vstack ( ( pts1 , pts2 ) ) )
  pts1_h = np.dot ( Tf , to_homogeneous ( pts1 ).T ).T
  pts2_h = np.dot ( Tf , to_homogeneous ( pts2 ).T ).T
  F = None

  inliers   = 0 
  n_inliers = 0
  for i in range ( NI ):
    inliers_temp = []
    pinds = np.random.choice ( range ( ND ) , NSP , replace = False )
    pts1_sample = pts1_h [ pinds , : ]
    pts2_sample = pts2_h [ pinds , : ]
    F_est = eightpoint ( pts1_sample [ : , 0:2 ] , pts2_sample [ : , 0:2 ] , M )

    n_inliers_temp = 0
    for pi in range ( ND ):
      error = np.dot (         pts2_h [ pi , : ].T , 
              np.dot ( F_est , pts1_h [ pi , : ].T ) )
      error = np.abs ( error )

      if error < THRESHOLD:
        n_inliers_temp = n_inliers_temp + 1
        inliers_temp.append ( pi )
        
    if n_inliers_temp > n_inliers:
      #print 'most inliers {} at iteration {}'.format ( n_inliers_temp , i )
      n_inliers = n_inliers_temp
      inliers = inliers_temp
      F = F_est

  F = np.dot ( F    , Tf )
  F = np.dot ( Tf.T , F  )

  return F, inliers

# Q 5.2
# r is a unit vector scaled by a rotation around that axis
# 3x3 rotatation matrix is R
# https://en.wikipedia.org/wiki/Rodrigues%27_rotation_formula
# http://www.cs.rpi.edu/~trink/Courses/RobotManipulation/lectures/lecture6.pdf
def skew_sym ( v ):
  assert v.shape [ 0 ] == 3 , "expect vector to be 3x1"
  x = v [ 0 ]
  y = v [ 1 ]
  z = v [ 2 ]
  Vskew = np.zeros ( ( 3 , 3 ) )
  Vskew [ 1 , 0 ] =  z
  Vskew [ 2 , 0 ] = -y
  Vskew [ 2 , 1 ] =  x
  Vskew [ 0 , 1 ] = -z
  Vskew [ 0 , 2 ] =  y
  Vskew [ 1 , 2 ] = -x
  return Vskew

def rodrigues(r):
  theta = np.linalg.norm ( r ) # angle of rotation
  if theta == 0:
    R = np.eye ( 3 )
  else:
    k = r / float ( theta )      # unit vector
    K = skew_sym ( k ) 
    R = np.eye ( 3 ) +  \
              np.sin ( theta )   * K + \
        ( 1 - np.cos ( theta ) ) * K.dot ( K )

  return R


# Q 5.2
# rotations about x,y,z is r
# 3x3 rotatation matrix is R
# https://en.wikipedia.org/wiki/Rodrigues%27_rotation_formula
# https://en.wikipedia.org/wiki/Axis%E2%80%93angle_representation
def S12 ( r ):
  
  if np.linalg.norm ( r ) == np.pi and \
    ( 
      ( r [ 0 ] == 0 and r [ 1 ] == 0  and r [ 2 ] < 0 ) or \
      ( r [ 0 ] == 0 and r [ 1 ]  < 0                  ) or \
      ( r [ 0 ]  < 0                                   )
    ):
    r = -r
  else:
    r = r
  return r

def invRodrigues(R):
  A = ( R - R.T ) / float ( 2 )
  rho = np.array ( [ A [ 2 , 1 ] , A [ 0 , 2 ] , A [ 1 ,  0 ] ] )
  s = np.linalg.norm ( rho )
  c = np.array ( R [ 0 , 0 ] + R [ 1 , 1 ] + R [ 2 , 2 ] -1 ) / float ( 2 )
  if s == 0 and c == 1:    # " sin theta = 0 " , weird condition
    r = np.array ( [ 0 , 0 , 0 ] ).T
  elif s == 0 and c == -1: # " sin theta = pi " , also weird condition
    RpI = R + np.eye ( 3 )
    for i in range (3 ):
      if np.all ( RpI [ : , i ] == 0 ):
        continue
      else:
        v = RpI [ : , i ]
        break
    r = S12 ( u * np.pi )
  else:
    theta = np.arctan2 ( s , c )
    u = rho / s
    r = u * theta
  return r
  """
  theta = np.arccos ( ( np.trace ( R ) - 1 ) / float ( 2 ) )
  u =  R [ [ 2 , 0 , 1 ] , [ 1 , 2 , 0 ] ] - \
       R [ [ 1 , 2 , 0 ] , [ 2 , 0 , 1 ] ]
  u = u / float ( 2 * np.sin ( theta ) )  # unit axis vector
  r = u * theta
  """
  return r 

def flatten_to_x ( P , M ):
  # flatten P. extract rotation and translation from M ,rodriguesify,
  # and flatten
  P_flat = P.ravel() # O sharp?
  R = M [ : , range ( 3 ) ]#.ravel()
  r = invRodrigues ( R )
  t = M [ : , 3 ] 
  return np.hstack ( ( P_flat , r , t ) ).reshape ( ( -1 , 1 ) )

def unflatten_from_x ( x ):
  # flatten P. extract rotation and translation from M ,rodriguesify,
  # and flatten
  P_flat = x [ 0 : -6 ]
  r      = x [ -6 : -3 ]
  t      = x [ -3 : ].reshape ( 3 , 1 )
  R = rodrigues ( r )
  M = np.hstack ( ( R , t ) )
  P = P_flat.reshape ( -1 , 3 )
  return  P , M 

################################################################################
################################################################################
################################################################################
# Q5.3
# we're using numerical gradients here
# but one of the great things about the above formulation
# is it has a nice form of analytical gradient
################################################################################
def rodriguesResidual(K1, M1, p1, K2, p2, x):
  ##############################################################################
  ## Stack up our known points #################################################
  ##############################################################################
  #z    = np.hstack ( ( p1.ravel () , p2.ravel () ) )
  z    = np.vstack ( ( p1 , p2 ) )
  ##############################################################################
  ## Project triangulated points back to image plane ###########################
  ##############################################################################
  P_est , M2_est = unflatten_from_x ( x )
  C1 = K1.dot( M1     )
  C2 = K2.dot( M2_est )
  # k , P_est is row entries non homogeneous
  # => homogeneous, transpose for transform,then transpose back
  # to row entries , then remove homogeneous ones column
  p1_est = np.dot ( C1 , to_homogeneous ( P_est ).T ).T
  p2_est = np.dot ( C2 , to_homogeneous ( P_est ).T ).T
  p1_est = p1_est / p1_est [ : , 2 ] [ : , None ]
  p2_est = p2_est / p2_est [ : , 2 ] [ : , None ]
  p1_est = p1_est [ : , 0:2 ] # remove ones column
  p2_est = p2_est [ : , 0:2 ] # remove ones column

  ##############################################################################
  ## Stacks on stacks of point estimates #######################################
  ##############################################################################
  #z_hat  = np.hstack ( ( p1_est.ravel () , p2_est.ravel () ) )
  z_hat  = np.vstack ( ( p1_est , p2_est ) )
  errors = z - z_hat
  residuals = np.sum ( np.square ( np.linalg.norm ( errors , axis = 1 ) ) )
  residuals = residuals.reshape ( ( -1 , 1 ) ) #1d array so optimize isnt sad
  return residuals

# we should use scipy.optimize.minimize
# L-BFGS-B is good, feel free to use others and report results
# https://docs.scipy.org/doc/scipy/reference/generated/scipy.optimize.minimize.html
def bundleAdjustment(K1, M1, p1, K2, M2init, p2, Pinit):
  x0 = flatten_to_x ( Pinit , M2init )
  f = lambda x : rodriguesResidual( K1 , M1, p1 , K2 , p2 , x )
  minimizer = minimize ( f , x0 , method = 'L-BFGS-B' )
  xawesome = minimizer.x
  P , M2 = unflatten_from_x ( xawesome )
  return M2 , P 

def test_rodrigues():
  assert np.all ( rodrigues ( np.array ( [ 0 , 0 , 0 ] ) ) == np.eye ( 3 ) )
  r1 = np.array ( [ 0 , 0 , np.pi / float ( 3 ) ] )  # should look like rotation around z
  R1 = rodrigues ( r1 )
  r2 = np.array ( [ 0 , np.pi / float ( 3 ) , 0] )  # should look like rotation around y 
  R2 =  rodrigues ( r2 )
  r3 = np.array ( [ np.pi / float ( 3 ) , 0 , 0] )  # should look like rotation around x
  R3 = rodrigues ( r3 )

  r1x = invRodrigues ( R1 )
  r2x = invRodrigues ( R2 )
  r3x = invRodrigues ( R3 )

  print 'r1 : {}'.format ( r1 )
  print 'r2 : {}'.format ( r2 )
  print 'r3 : {}'.format ( r3 )
  print 'R1 : {}'.format ( R1 )
  print 'R2 : {}'.format ( R2 )
  print 'R3 : {}'.format ( R3 )
  print 'r1x : {}'.format ( r1x )
  print 'r2x : {}'.format ( r2x )
  print 'r3x : {}'.format ( r3x )

  #kewl

if __name__ == "__main__":
  test_rodrigues()

"""
grad[k] = (f(*((xk + d,) + args)) - f0) / d[k]
(Pdb) n
ValueError: 'setting an array element with a sequence.'
> /home/joe/anaconda2/lib/python2.7/site-packages/scipy/optimize/lbfgsb.py(274)func_and_grad()
-> g = _approx_fprime_helper(x, fun, epsilon, args=args, f0=f)

"""
