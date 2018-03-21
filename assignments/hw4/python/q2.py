import skimage.feature
import numpy              as     np
import scipy.io           as     sio
import matplotlib.pyplot  as     plt
from   skimage.io         import imread
from   skimage.color      import rgb2gray
from   skimage.feature    import corner_harris , corner_peaks

################################################################################
# Q2.1                                                            ##############
# create a 2 x nbits sampling of integers from to to patchWidth^2 ##############
# read BRIEF paper for different sampling methods                 ##############
################################################################################
def makeTestPattern(patchWidth, nbits):
  #res = None
  # YOUR CODE HERE
  compareX = np.random.randint ( patchWidth ** 2 , size = [ nbits , 1 ] )
  compareY = np.random.randint ( patchWidth ** 2 , size = [ nbits , 1 ] )
  return compareX , compareY 

################################################################################
# Q2.2                                               ###########################
# im is 1 channel image, locs are locations          ###########################
# compareX and compareY are idx in patchWidth^2      ###########################
# should return the new set of locs and their descs  ###########################
################################################################################
def computeBrief( im , locs , compareA , compareB ):
  patchWidth = 9 # pwned
  desc       = [ ]
  valid_locs = [ ]
  n_features = len ( compareA )
  #for x , y in locs:
  for loc in locs:
    x , y = loc
    try:
      feature_vector = np.zeros ( [ n_features , 1 ] )
      for i in range ( n_features ):
        ra , ca = np.unravel_index ( compareA [ i ]  ,
                                   [ patchWidth , patchWidth ] )
        rb , cb = np.unravel_index ( compareB [ i ]  ,
                                   [ patchWidth , patchWidth ] )
        pa      = im               [ y + ra     , x + ca     ]
        pb      = im               [ y + rb     , x + cb     ]
        feature_vector [ i ] = 1 if pa > pb else 0
      desc.append       ( feature_vector )  
      valid_locs.append ( loc            )
    except IndexError:
      pass # index out of range, no worries

  valid_locs = np.array           ( valid_locs )
  desc       = np.array           ( desc       )
  valid_locs = valid_locs.reshape ( [ len ( valid_locs ) , 2          ] )
  desc       = desc.reshape       ( [ len ( desc       ) , n_features ] )

  return valid_locs, desc

################################################################################
################################################################################
# Q2.3                                        ##################################
# im is a 1 channel image                     ##################################
# locs are locations                          ##################################
# descs are descriptors                       ##################################
# if using Harris corners, use a sigma of 1.5 ##################################
################################################################################
################################################################################

def briefLite( im ):
  # YOUR CODE HERE
  patchWidth = 9
  nbits      = 256
  nms_size   = 1 
  ca, cb     = makeTestPattern ( patchWidth , nbits       )
  corners    = corner_peaks    ( corner_harris ( im       ) , 
                                 min_distance =  nms_size )
  #ax.plot(coords[ : , 1], coords[:, 0], '.b', markersize=3)
  #return locs, desc
  locs , desc = computeBrief( im , corners , ca , cb )
  return locs , desc

################################################################################
# Q 2.4 ########################################################################
################################################################################
def briefMatch(desc1 , desc2 , ratio=0.8 ):
  # okay so we say we SAY we use the ratio test
  # which SIFT does
  # but come on, I (your humble TA), don't want to.
  # ensuring bijection is almost as good
  # maybe better
  # trust me
  matches = skimage.feature.match_descriptors(desc1,desc2,'hamming',cross_check=True)
  return matches

################################################################################
def plotMatches(im1,im2,matches,locs1,locs2):
  fig, ax = plt.subplots(nrows=1, ncols=1)
  skimage.feature.plot_matches(ax,im1,im2,locs1,locs2,matches,matches_color='r')
  plt.show()
  return

################################################################################
def testMatch():
  # YOUR CODE HERE
  im1 = rgb2gray ( imread ( '../data/chickenbroth_01.jpg'    ) )
  locs1 , desc1 = briefLite ( im1 )
  im2 = rgb2gray ( imread ( '../data/model_chickenbroth.jpg' ) )
  locs2 , desc2 = briefLite ( im2 )
  matches       = briefMatch     ( desc1 , desc2 , ratio = 0.8 )
  plotMatches   ( im1 , im2 , matches , locs1 , locs2 )
  return


# Q 2.5
# we're also going to use this to test our
# extra-credit rotational code
def briefRotTest(briefFunc=briefLite):
  # you'll want this
  import skimage.transform
  # YOUR CODE HERE
  
  return

# Q2.6
# YOUR CODE HERE


# put your rotationally invariant briefLite() function here
def briefRotLite(im):
  locs, desc = None, None
  # YOUR CODE HERE
  
  return locs, desc

if __name__ == "__main__":
  #img = skimage.io.imread('../data/chickenbroth_01.jpg')
  #im = skimage.color.rgb2gray(img)
  #locs , desc = briefLite(im)
  testMatch ( ) 

