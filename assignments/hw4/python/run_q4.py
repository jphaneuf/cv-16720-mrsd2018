from q4 import *
from q3 import *
from q2 import *
import numpy as np
import matplotlib.pyplot as plt
import skimage.color
import skimage.io

# Q 4.1
# load images into img1
# and img2
# compute H2to1
# please use any feature method you like that gives
# good results
#img1 = skimage.io.imread('../data/pnc1.png')
#img2 = skimage.io.imread('../data/pnc0.png')
img1 = skimage.io.imread('../data/incline_L.png')
img2 = skimage.io.imread('../data/incline_R.png')

patchWidth = 9
nbits      = 256
#makeTestPattern ( patchWidth , nbits )
locs1 , desc1 = briefLite ( rgb2gray ( img1 ) )
locs2 , desc2 = briefLite ( rgb2gray ( img2 ) )
matches       = briefMatch     ( desc1 , desc2 , ratio = 0.8 )
#plotMatches   ( img1 , img2 , matches , locs1 , locs2 )

l1 = locs1 [ matches [ : , 0 ] ]
l2 = locs2 [ matches [ : , 1 ] ]

## Did I do x / y or row column ? #############################################
l1 = locs1 [ matches [ : , 0 ] ] [ : , : : -1 ]
l2 = locs2 [ matches [ : , 1 ] ] [ : , : : -1 ]
##############################################################################
## Append 1 => homogenous coordinates ########################################
##############################################################################
l1 = np.hstack ( [ l1 , np.ones ( ( len ( l1 ) , 1 ) ) ] )
l2 = np.hstack ( [ l2 , np.ones ( ( len ( l2 ) , 1 ) ) ] )

#H2to1 , n = computeHransac( l2 , l1 )

#panoImg = imageStitching ( img1 , img2 , H2to1 )
#plt.imshow ( panoImg )
#plt.show () 
#np.set_printoptions ( precision = 2 )
#print H2to1

# YOUR CODE HERE

"""
panoImage = imageStitching(img1,img2,H2to1)
plt.subplot(1,2,1)
plt.imshow(img1)
plt.title('pnc0')
plt.subplot(1,2,2)
plt.title('pnc1')
plt.imshow(img2)
plt.figure()
plt.imshow(panoImage)
plt.show()
"""

# Q 4.2
#panoImage2= imageStitching_noClip(img1,img2,H2to1)
#plt.subplot(2,1,1)
#plt.imshow(panoImage)
#plt.subplot(2,1,2)
#plt.imshow(panoImage2)
#plt.show()

# Q 4.3
panoImage3 = generatePanorama(img1, img2)
plt.imshow(panoImage3)
plt.show()


# Q 4.4 (EC)
# Stitch your own photos with your code

# Q 4.5 (EC)
# Write code to stitch multiple photos
# see http://www.cs.jhu.edu/~misha/Code/DMG/PNC3/PNC3.zip
# for the full PNC dataset if you want to use that
if False:
    imgs = [skimage.io.imread('../PNC3/src_000{}.png'.format(i)) for i in range(7)]
    panoImage4 = generateMultiPanorama(imgs)
    plt.imshow(panoImage4)
    plt.show()
"""
def makeTestPattern(patchWidth, nbits):
def computeBrief( im , locs , compareA , compareB ):
def briefLite( im ):
def briefMatch( desc1 , desc2 , ratio = 0.8 ):
def plotMatches(im1,im2,matches,locs1,locs2):
def testMatch():
def briefRotTest(briefFunc=briefLite):
def briefRotLite(im):
"""
exit()
