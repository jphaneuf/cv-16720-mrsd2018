import numpy as np
from q2 import eightpoint, sevenpoint
from q3 import triangulate

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
  THRESHOLD = 1  #threshold , pixels?
  assert pts1.shape == pts2.shape , "point input sizes differ dummy"
  ND = pts1.shape [ 0 ]
  pts1_h = to_homogeneous ( pts1 )
  pts2_h = to_homogeneous ( pts2 )

  F = None

  inliers   = 0 
  n_inliers = 0
  for i in range ( NI ):
    inliers_temp = []
    pinds = np.random.choice ( range ( ND ) , NSP , replace = False )
    pts1_sample = pts1 [ pinds , : ]
    pts2_sample = pts2 [ pinds , : ]
    F_est = eightpoint ( pts1_sample , pts2_sample , M )

    n_inliers_temp = 0
    for pi in range ( ND ):
      error = np.dot (         pts1_h [ pi , : ].T , 
              np.dot ( F_est , pts2_h [ pi , : ].T ) )
      error = np.abs ( error )

      if error < THRESHOLD:
        n_inliers_temp = n_inliers_temp + 1
        inliers_temp.append ( pi )
        
    if n_inliers_temp > n_inliers:
      #print 'most inliers {} at iteration {}'.format ( n_inliers_temp , i )
      n_inliers = n_inliers_temp
      inliers = inliers_temp
      F = F_est
  
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
def invRodrigues(R):
    #r = None
    """
    A = ( R - R.T ) / float ( 2 )
    rho = np.array ( [ A [ 2 , 1 ] , A [ 0 , 2 ] , A [ 1 ,  0 ] ] )
    s = np.linalg.norm ( rho )
    c = np.array ( R [ 0 , 0 ] + R [ 1 , 1 ] + R [ 2 , 2 ] -1 ) / float ( 2 )
    if s == 0 and c == 1:
      r = np.array ( [ 0 , 0 , 0 ] ).T
    elif s == 0 and c == -1:
      r = 0
    
    return r
    """
    theta = np.arccos ( ( np.trace ( R ) - 1 ) / float ( 2 ) )
    u =  R [ [ 2 , 0 , 1 ] , [ 1 , 2 , 0 ] ] - \
         R [ [ 1 , 2 , 0 ] , [ 2 , 0 , 1 ] ]
    u = u / float ( 2 * np.sin ( theta ) )  # unit axis vector
    r = u * theta
    return r 

# Q5.3
# we're using numerical gradients here
# but one of the great things about the above formulation
# is it has a nice form of analytical gradient
def rodriguesResidual(K1, M1, p1, K2, p2, x):
    residuals = None
    
    return residuals

# we should use scipy.optimize.minimize
# L-BFGS-B is good, feel free to use others and report results
# https://docs.scipy.org/doc/scipy/reference/generated/scipy.optimize.minimize.html
def bundleAdjustment(K1, M1, p1, K2, M2init, p2,Pinit):
    M2, P = None, None
    
    return M2,P 

def test_rodriguez():
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
  test_rodriguez()

