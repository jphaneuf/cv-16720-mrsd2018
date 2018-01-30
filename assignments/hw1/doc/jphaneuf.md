# Computer Vision 16-720 Spring 2018
# Joe Phaneuf

# 2 Theory Questions  

## Q2.1  
Mapping a point in image space $(x,y)$ to Hough space, $x$ and $y$ become constants.  
$\rho(\theta) = x cos \theta + y sin \theta$  
Being a linear combination of same-period sinusoids, $\rho(\theta)$ is guaranteed to be a sinusoid.  

## Q2.2  
Hough space can be parameterized in slope-intercept form.  
Doing so creates two major problems:  

### 1. The slope and intercept parameters are unbounded, making implementation impractical

### 2. Vertical lines (infinite slope) cannot be represented  

When parameterizing in normal form, the magnitude and angle are bounded (magnitude bound is a function of image size).

$\rho = x cos \theta + y sin \theta$  
$y sin \theta = \rho - x cos \theta$  
$y = - \frac{1}{tan \theta} x + \frac{\rho}{sin \theta}$  
$m =- \frac{1}{tan \theta}$ , $c = \frac{\rho}{sin \theta}$  

## Q2.3  
The range of $\theta$ is independent on image size: $- \frac{\pi}{2} \leq \theta \leq \frac{\pi}{2}$  
The largest $\rho$ will be a diagonal across the image space: $0 \leq abs(\rho) \leq \sqrt{W^{2} + H^{2}}$

## Q2.4  
### Matlab script for plot generation in matlab/q2_4.m
Image space points (10, 10), (15, 15) and (30, 30) were represented in Hough space, resulting in sinusoids as discussed above. The sinusoids in Hough space intersect at one point. That point describes a line in image space that passes through the points (10, 10), (15, 15) and (30, 30). The sinusoids intersect at $\theta = - \frac{pi}{4}$ , $\rho = 0$, which describes a 45 degree line passing through origin in image space, i.e. $m=1$, $c=0$.

![Intersecting lines in Hough space](./doc/img/q2_4.png)  


## Q2.5  
Extra Credit

# 3 Implementation
## 3.1
## 3.2
## 3.3
## 3.4
## 3.5
## 3.6

# 4 Experiments
Did your code work well on all the image with a single set of parameters? How did the optimal set of
parameters vary with images? Which step of the algorithm causes the most problems? Did you find any
changes you could make to your code or algorithm that improved performance?
Tabulate the different experiments that you have performed with their results in your write-up. Also de-
scribe how well your code worked on different images, what effect the parameters had on any improve-
ments that you made to your code to make it work better. If you made changes to your code that required
changes to the results generation script, include your updated version in your submission.
