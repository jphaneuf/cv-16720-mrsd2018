import numpy as np
import matplotlib.pyplot as plt
from mpl_toolkits.mplot3d import axes3d, Axes3D

from q2 import eightpoint
from q3 import essentialMatrix, triangulate
from util import camera2
# Q 4.1
# np.pad may be helpful
################################################################################
def epipolarCorrespondence(im1, im2, F, x1, y1):
    lp = np.dot ( F , np.array ( [ x1 , y1 , 1 ] ) )
    lp = lp / lp [ 2 ]
    yp   = lambda x: - ( lp [ 0 ] * x + lp [ 2 ] ) / lp [ 1 ]
    xind = np.arange ( 0 , im2.shape [ 1 ] ) [ : , None ]

    window_centers = np.round ( np.hstack ( ( xind , yp ( xind ) ) ) )
    ylim_ok = np.logical_and ( window_centers [ : , 1 ] > 0 , 
                               window_centers [ : , 1 ] < im2.shape [ 0 ] )
    window_centers = window_centers [ ylim_ok ]
       
    
    ############################################################################
    ## Plotting for debugging###################################################
    ############################################################################
    #plt.subplot ( 2 , 1 , 1 )
    #plt.imshow ( im1 )
    #plt.plot ( x1 , y1 , 'r+' )
    #plt.subplot ( 2 , 1 , 2 )
    #plt.imshow ( im2 )

    #plt.xlim ( [ 0 , im2.shape [ 1 ] ] )
    #plt.ylim ( [ 0 , im2.shape [ 0 ] ] )
    #plt.plot ( xind , yp ( xind ) )
    ##############################################################################

    #############################################################################
    ## Initialized best distance metric and located point p2 ####################
    #############################################################################
    min_distance = 1e8
    p2 = None

    #############################################################################
    ## Set up window offsets , compute euclidean descriptor for point on im1 ####
    #############################################################################
    W = 7 #block size
    offsets = np.unravel_index ( range ( W**2 ) , ( W, W ) )
    offsets = np.array ( offsets ).T
    offsets = offsets - np.floor ( W / 2)

    im1xi = (x1 + offsets).astype('int')
    im1yi = (y1 + offsets).astype('int')
    im1i = ( np.array ( [ x1 , y1 ] ) + offsets ).astype('int')
    im1_window = im1 [ im1i [ : , 1 ] , im1i [ : , 0 ] , : ]
    im1_features = np.ravel ( im1_window )


    #############################################################################
    ## Sweep over line described by E x1 , check for best match #################
    #############################################################################
    for wc in window_centers:
      try:
        wi = wc + offsets
        wi = wi.astype ( 'int' )
        window = im2 [ wi[ : , 1 ] , wi [ : , 0 ] , : ]
        window = np.ravel ( window )
        distance = np.linalg.norm ( window - im1_features )
        if distance < min_distance:
          min_distance = distance
          p2 = np.array ( [ wc [ 0 ] , wc [ 1 ] ] )
          
      except IndexError:
        pass #out of bounds

    ## More debug###############################################################
    #plt.plot ( p2 [ 0 ] , p2 [ 1 ] , 'r+' )
    #plt.show()
    ############################################################################
    
    return p2 [ 0 ] , p2 [ 1 ] 
    #return x2, y2

# Q 4.2
# this is the "all in one" function that combines everything
def visualize(IM1_PATH,IM2_PATH,TEMPLE_CORRS,F,K1,K2):
    fig = plt.figure()
    ax = Axes3D(fig)
    # ax.set_xlim/set_ylim/set_zlim/
    # ax.set_aspect('equal')
    # may be useful
    # you'll want a roughly cubic meter
    # around the center of mass
    

# Extra credit
def visualizeDense(IM1_PATH,IM2_PATH,TEMPLE_CORRS,F,K1,K2):
    return
