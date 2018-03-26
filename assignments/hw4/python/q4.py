import numpy as np
from q2 import *
from q3 import *
import skimage.color

# you may find this useful in removing borders
# from pnc series images (which are RGBA)
# and have boundary regions
def clip_alpha(img):
    img[:,:,3][np.where(img[:,:,3] < 1.0)] = 0.0
    return img 

# Q 4.1
# this should be a less hacky version of
# composite image from Q3
# img1 and img2 are RGB-A
# warp order 0 might help
# try warping both images then combining
# feel free to hardcode output size
def imageStitching(img1, img2, H2to1):
  #warps img2 into img1 frame
  out_shape = [ 600 , 600 , 3 ]
  panoImg = np.zeros ( out_shape ) #img1
  ##############################################################################
  ## Will predict total image size now for use in warp, rather than ############
  #### mess with it later#######################################################
  ##############################################################################
  h1 , w1 , x = img1.shape
  h2 , w2 , x = img2.shape
  ##########################    x    y    1  ###################################
  img2_corners = np.array ( [ [ 0  , 0  , 1 ] , 
                              [ w2 , 0  , 1 ] , 
                              [ 0  , h2 , 1 ] ,
                              [ w2 , h2 , 1 ] ] ).T

  img1_corners = np.array ( [ [ 0  , 0  , 1 ] , 
                              [ w1 , 0  , 1 ] , 
                              [ 0  , h1 , 1 ] ,
                              [ w1 , h1 , 1 ] ] ).T

  img2_corners_warped = np.dot ( H2to1 , img2_corners )
  ## Normalize #################################################################
  #img2_corners_warped [ 0 , : ] = np.divide ( img2_corners_warped [ 0 , : ] , 
  #                                            img2_corners_warped [ 2 , : ] )
  #img2_corners_warped [ 1 , : ] = np.divide ( img2_corners_warped [ 0 , : ] , 
  #                                            img2_corners_warped [ 2 , : ] )

  #corners = np.hstack ( ( img1_corners , img2_corners_warped ) )
  

  ##############################################################################
  warped       = warp ( img2 , H2to1  , output_shape = [ 600 , 600 ] , 
                        mode = 'constant' , cval = 0 )

  ##############################################################################
  ## Extract indices of non-zero Harry pixels , set them in composite ##########
  ##############################################################################
  warped = warped [ : , : , 0:3 ]
  indices      = warped       [ : , : , 0   ] != 0
  panoImg = panoImg [ : , : , 0:3 ] # what is this 4th thing?
  img1 = img1 [ : , : , 0:3 ] #..?
  panoImg [ indices ] = warped [ indices ]
  
  return panoImg


# Q 4.2
# you should make the whole image fit in that width
# python may be inv(T) compared to MATLAB
def imageStitching_noClip(img1, img2, H2to1, panoWidth=1280):
    panoImg = None
    # YOUR CODE HERE
    
    return panoImg

# Q 4.3
# should return a stitched image
def generatePanorama(img1, img2):
    panoImage = None
    # YOUR CODE HERE
    
    return panoImage

# Q 4.5
# I found it easier to just write a new function
# pairwise stitching from right to left worked for me!
def generateMultiPanorama(imgs):
    panoImage = None
    # YOUR CODE HERE
    
    return panoImage


