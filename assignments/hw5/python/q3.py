import numpy as np
from numpy.linalg import norm
import os
import numpy as np
import scipy.io
import h5py
from   util import camera2

# Q3.1
def essentialMatrix(F,K1,K2):
    #Todo : are we 
    E = np.dot ( K1.T , np.dot ( F , K2 ) )
    ###wtf, this is done in util...
    ####pwnd
    """
    U , S , Vt = np.linalg.svd ( E )
    assert len ( S ) == 3 , 'expected Singular value vector to be length three'
    S [ 2     ] = 0
    S [ 0 : 2 ] = np.sum  ( S ) / float ( 2 )
    S =           np.diag ( S )
    E = np.dot ( U , np.dot ( S , Vt ) )
    E = E.reshape ( ( 3 , 3 ) )
    """
    E = E / E [ 2 , 2 ]
    return E

# Q3.2

def triangulate( P1, pts1_in , P2 , pts2_in ):
  assert len ( pts1_in ) == len ( pts2_in )
  pts1 = np.copy ( pts1_in )
  pts2 = np.copy ( pts2_in )
  r , c = pts1_in.shape 

  #P, err = None, None
  sq_errors = [ ]
  P      = [ ] 
  for i in range ( r ):
    A = np.empty ( [ 0 , 4 ] )
    p1 = pts1 [ i , : ]
    p2 = pts2 [ i , : ]
    x1 = p1 [ 0 ]
    x2 = p2 [ 0 ]
    y1 = p1 [ 1 ]
    y2 = p2 [ 1 ]

    eq1 = y1 * P1 [ 2 , : ] - P1      [ 1 , : ]
    eq2 =      P1 [ 0 , : ] - x1 * P1 [ 2 , : ]
    eq3 = y2 * P2 [ 2 , : ] - P2      [ 1 , : ]
    eq4 =      P2 [ 0 , : ] - x2 * P2 [ 2 , : ]

    A = np.vstack ( [ A , eq1 , eq2 , eq3 , eq4 ] )

    U , S , Vt =  np.linalg.svd ( A )
    Pest = Vt [ -1 , : ].reshape ( ( 4 , 1 ) )
    Pest = Pest / Pest [ 3 ]
    P.append ( Pest )

    p1hat = np.dot ( P1  , Pest ) 
    p1hat = p1hat  / p1hat [ 2  ]
    p2hat = np.dot ( P2  , Pest ) 
    p2hat = p2hat  / p2hat [ 2  ]
    sq_errors.append ( norm ( p1 - p1hat [ 0 : 2 ].T  ) ** 2 + 
                       norm ( p2 - p2hat [ 0 : 2 ].T  ) ** 2 ) 
  err = sum ( sq_errors ) 
  P = np.array   ( P )
  P = np.reshape ( P , ( P.shape [ 0 ] , P.shape [ 1 ] ) )
  P = P [ : , 0:3 ] #remove homogeneous 1
  return P , err

def findM2 ( ):

  HOMEWORK_DIR = ".."
  SOME_CORRS   = os.path.join(HOMEWORK_DIR,'data','some_corresp.mat')
  INTRINS      = os.path.join(HOMEWORK_DIR,'data','intrinsics.mat')

  corr = scipy.io.loadmat(SOME_CORRS)
  pts1 = corr[ 'pts1' ]
  pts2 = corr[ 'pts2' ]
  with h5py.File(INTRINS, 'r') as f:
      K1 = np.array(f['K1']).T
      K2 = np.array(f['K2']).T

  F = eightpoint( pts1 , pts2 )
  F = F / F[ 2 , 2 ]

  E = essentialMatrix( F , K1 , K2 )
  E = E / E[ 2, 2 ]
  M2s = camera2(E)

  M1 = np.hstack([np.eye(3),np.zeros((3,1))])
  for M2 in M2s:
    P, err = triangulate(K1.dot(M1),pts1,K2.dot(M2),pts2)
    P = np.reshape ( P , ( P.shape [ 0 ] , P.shape [ 1 ] ) )
    P = np.hstack ( ( P , np.ones ((  P.shape [ 0 ] ,1  ) ) ) )
    P_inC2 = np.dot ( M2 , P.T )
    if all ( P_inC2 [ 2 ] > 0 ):
      print 'Mine M2 is the one true M2'
      scipy.io.savemat ( 'q3_3.mat' , { 'C2' : K2.dot ( M2 ) , 'M2' : M2 ,
                         'p1' : pts1 , 'p2' : pts2 , 'P' : P [ : , 0 :3 ] } )
    else:
      print 'Thy M2 is false and wicked'

if __name__ == "__main__":
  from q2 import eightpoint
  findM2 ( )
