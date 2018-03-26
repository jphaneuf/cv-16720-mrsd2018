import numpy as np
from q2 import *
from q3 import *
import skimage.color
import skimage.transform
from scipy import misc

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
  out_shape = [ 315 , 310 , 3 ]
  panoImg   = np.zeros ( out_shape )

  img2_warped       = warp ( img2 , H2to1  , output_shape = out_shape , 
                        mode = 'constant' , cval = 0 )
  img1_warped       = warp ( img1 , np.eye ( 3 ) , output_shape = out_shape ,  
                        mode = 'constant' , cval = 0 )

  ##############################################################################
  ## Extract indices of non-zero Harry pixels , set them in composite ##########
  ##############################################################################
  img1_warped = img1_warped [ : , : , 0:3 ]
  img2_warped = img2_warped [ : , : , 0:3 ]
  indices1      = img1_warped       [ : , : , 0   ] != 0
  indices2      = img2_warped       [ : , : , 0   ] != 0
  #panoImg = panoImg [ : , : , 0:3 ] # what is this 4th thing?
  panoImg [ indices2 ] = img2_warped [ indices2 ]
  panoImg [ indices1 ] = img1_warped [ indices1 ]
  #panoImg =  misc.imfilter ( panoImg , ftype = 'blur' )
  
  return panoImg



# Q 4.2
# you should make the whole image fit in that width
# python may be inv(T) compared to MATLAB
def imageStitching_noClip(img1, img2, H2to1, panoWidth=1280):
  M = np.eye ( 3 )
  # Assume img2 to the right, otherwise need some extra processing
  ##############################################################################
  ## Will predict total image size now for use in warp #########################
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

  img2_corners_warped = np.dot ( np.linalg.inv ( H2to1 ) , img2_corners )
  img2_corners_warped = normPoints ( img2_corners_warped )

  corners = np.hstack ( ( img1_corners , img2_corners_warped ) )
  xmin = min ( corners [ 0 , : ] )
  xmax = max ( corners [ 0 , : ] )
  ymin = min ( corners [ 1 , : ] )
  ymax = max ( corners [ 1 , : ] )

  out_shape = np.array ( [ ymax - ymin , xmax - xmin , 3 ] )
  out_shape = out_shape.astype ( 'int' )


  T = np.eye ( 3 )
  T [ 0 , 2 ] = xmin 
  T [ 1 , 2 ] = ymin
  S = np.eye ( 3 )
  ### Scaling this way is janky , resize so everything fits in frame 1
  ### with translations, then resize so width = panoWidth
  #scale_factor = out_shape [ 1 ] / float ( panoWidth )
  #scale_factor = float ( panoWidth ) / out_shape [ 1 ]
  #out_shape [ 0 : 2 ] = scale_factor * out_shape [ 0 : 2 ] 
  #out_shape [ 0 : 2 ] = panoWidth * out_shape [ 0 : 2 ] / out_shape [ 1 ]
  #S [ 0 , 0 ] = 1 / float ( scale_factor )
  #S [ 1 , 1 ] = 1 / float ( scale_factor )
  #S [ 0 , 0 ] = scale_factor
  #S [ 1 , 1 ] = scale_factor
  M = np.dot ( S , T )

  panoImg   = np.zeros ( out_shape )

  img2_warped       = warp ( img2 , np.dot ( M , H2to1 ) , output_shape = out_shape , 
                        mode = 'constant' , cval = 0 )
  img1_warped       = warp ( img1 , M , output_shape = out_shape ,  
                        mode = 'constant' , cval = 0 )

  ##############################################################################
  ## Extract indices of non-zero Harry pixels , set them in composite ##########
  ##############################################################################
  img1_warped = img1_warped [ : , : , 0:3 ]
  img2_warped = img2_warped [ : , : , 0:3 ]
  indices1      = img1_warped        [ : , : , 0   ] != 0
  indices2      = img2_warped        [ : , : , 0   ] != 0
  panoImg [ indices2 ] = img2_warped [ indices2 ]
  panoImg [ indices1 ] = img1_warped [ indices1 ]
  #panoImg =  misc.imfilter ( panoImg , ftype = 'blur' )
  
  out_shape [ 0 : 2 ] = panoWidth * out_shape [ 0 : 2 ] / out_shape [ 1 ]
  panoImg = skimage.transform.resize ( 
             panoImg , out_shape )
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


