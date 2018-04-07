import numpy as np
import matplotlib.pyplot as plt
from mpl_toolkits.mplot3d import axes3d, Axes3D

from q2 import eightpoint
from q3 import essentialMatrix, triangulate
from util import camera2 , plot_matched_points2
import skimage
from skimage.feature import ORB , BRIEF
from skimage.color import rgb2gray
from scipy.spatial.distance import hamming
import scipy
import scipy.ndimage.filters as fi
# Q 4.1
# np.pad may be helpful
################################################################################
def epipolarCorrespondence(im1, im2, F, x1, y1):
    DEBUG = False
    PS = 45
    DS = 256
    MODE = 'normal'
    SIG = 2
    ## Construct epipolarbear line #############################################
    ############################################################################
    lp = np.dot ( F , np.array ( [ x1 , y1 , 1 ] ) )
    lp = lp / lp [ 2 ]
    ############################################################################
    ## Find x intercept , and y ( x ), and find unit vector along epipolar line#
    ############################################################################
    x0 = - 1 / float ( lp [ 0 ] )
    xind = np.arange ( 0 , im2.shape [ 1 ] ) [ : , None ]
    yp = lambda x: - ( lp [ 0 ] * x + lp [ 2 ] ) / lp [ 1 ]

    uv = np.array ( ( 1 , - lp [ 0 ] / lp [ 1 ] ) )
    uv = np.sign ( uv [ 1 ] / uv [ 0 ] ) * uv
    uv = uv / np.linalg.norm ( uv )
      
    
    ############################################################################
    ## Plotting for debugging###################################################
    ############################################################################
    if DEBUG == True:
      plt.subplot ( 2 , 1 , 1 )
      plt.imshow ( im1 )
      plt.plot ( x1 , y1 , 'r+' )

      plt.subplot ( 2 , 1 , 2 )
      plt.imshow ( im2 )
      plt.xlim ( [ 0 , im2.shape [ 1 ] ] )
      plt.ylim ( [ 0 , im2.shape [ 0 ] ] )
      plt.plot ( xind , yp ( xind ) )
    ###############################################################################

    #############################################################################
    ## Initialized best distance metric and located point p2 ####################
    #############################################################################
    min_distance = 1e8
    #p2 = np.zeros (  2 )
    p2 = None

    #############################################################################
    ## Init brief descriptor for point in image 1 ###############################
    #############################################################################
    brief = BRIEF ( patch_size =  PS , descriptor_size = DS , mode = MODE , sigma = SIG)
    brief.extract ( rgb2gray ( im1 ) , np.array ( [  [ y1 , x1 ] ] ) )
    desc1 = brief.descriptors [ 0 ]

    ##############################################################################
    ## Sweep along epipolar and check for matches until out of range ############
    #############################################################################
    wc = np.array ( ( x0 , yp ( x0 ) ) )  #window center
    wc = wc + 100 * uv # initial offset so patch size clears
    while 1:
      wc = wc + 10*uv
      wcr =  wc.astype(int)
      try:
        brief = BRIEF ( patch_size =  PS , descriptor_size = DS , 
                        mode = MODE , sigma = SIG)
        xcr = wcr [ 0 ]
        ycr = wcr [ 1 ]
        brief.extract ( rgb2gray ( im2 ) , np.array ( [ [ ycr , xcr ] ] )  ) 
        desc2 = brief.descriptors [ 0 ]
        distance = hamming ( desc1 , desc2 )

        if distance < min_distance:
          print distance
          min_distance = distance
          p2 = np.array ( [ wc [ 0 ] , wc [ 1 ] ] )
          #plt.plot ( p2 [ 0 ] , p2 [ 1 ] , 'r+' )

      except IndexError:
        break

    if DEBUG == True:
      plt.plot ( p2 [ 0 ] , p2 [ 1 ] , 'r+' )
      plt.show()
    return p2 

# Q 4.2
# this is the "all in one" function that combines everything
def visualize(IM1_PATH,IM2_PATH,TEMPLE_CORRS,F,K1,K2):
    ############################################################################
    fig = plt.figure()
    ax = Axes3D(fig)
    # ax.set_xlim/set_ylim/set_zlim/
    # ax.set_aspect('equal')
    # may be useful
    # you'll want a roughly cubic meter
    # around the center of mass
    camera_data = scipy.io.loadmat ( 'q3_3.mat' )
    M2 = camera_data [ 'M2' ]
    M1 = np.hstack([np.eye(3),np.zeros((3,1))])

    im1 = skimage.io.imread(IM1_PATH)
    im2 = skimage.io.imread(IM2_PATH)
    pts_dict = scipy.io.loadmat(TEMPLE_CORRS)
    pts1  = np.hstack ( ( pts_dict [ 'x1' ] , pts_dict [ 'y1' ] ) )
    pts2  = np.zeros ( pts1.shape )
    for i in range ( len ( pts1 ) ):
      x1 = pts1 [ i , 0 ]
      y1 = pts1 [ i , 1 ]
      p2e = epipolarCorrespondence ( im1 , im2 , F , x1 , y1 )
      if p2e is not None:
        pts2 [ i , 0 ] = p2e [ 0 ]
        pts2 [ i , 1 ] = p2e [ 1 ]

    """
    for i in range ( len ( pts1 ) - 5 ):
      plot_matched_points2(im1,im2,F,
                         pts1[ i:i+5 ,:], 
                          np.zeros ( ( 5  , 2 ) ) , 
                        pts2 [ i:i+5 , : ] )
    """

    P , err = triangulate( K1.dot(M1) , pts1 , K2.dot(M2) , pts2 )
    scipy.io.savemat ( 'temple3d.mat', { 'P':P}  )
    scipy.io.savemat ( 'q4_debug.mat' , { 'C2' : K2.dot ( M2 ) , 'M2' : M2 ,
                        'p1' : pts1 , 'p2' : pts2 , 'P' : P [ : , 0 :3 ] } )


    ax.scatter ( P [ : , 0 ] , P [ : , 1 ] , P [ : , 2 ] )      
    lim = np.max ( np.abs ( P ) )
    ax.set_xlim ( ( - 1 , 1 ) )
    ax.set_ylim ( ( - 1 , 1 ) )
    ax.set_zlim ( ( - 1 , 2 ) )
    ax.set_aspect ( 'equal' )
    plt.show ( )

# Extra credit
def visualizeDense(IM1_PATH,IM2_PATH,TEMPLE_CORRS,F,K1,K2):
    return

if __name__ == "__main__":
  data = scipy.io.loadmat ( 'temple3d.mat' )
  P = data [ 'P' ]
  fig = plt.figure()
  ax = Axes3D(fig)
  ax.scatter ( P [ : , 0 ] , P [ : , 1 ] , P [ : , 2 ] , s = 1 )      
  #lim = np.max ( np.abs ( P ( ) )
  ax.set_xlim ( ( - 0.2 , 0.2 ) )
  ax.set_ylim ( ( - 0.2 , 0.2 ) )
  ax.set_zlim ( (  0 , 6 ) )
  ax.set_aspect ( 'equal' )
  plt.show ( )
