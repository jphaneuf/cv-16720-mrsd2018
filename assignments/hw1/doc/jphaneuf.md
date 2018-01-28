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
The range of $\theta$ is independent on image size: $0 \leq \theta \leq \frac{\pi}/{2}$  

## Q2.4  
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
