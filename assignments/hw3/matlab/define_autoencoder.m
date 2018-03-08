function layers = define_autoencoder()

layers = [
    imageInputLayer([32,32,1]) % H W channels
    % intermediate layers go between here ...
    conv2D(4,1,4,1,2)
    conv2D(4,4,8,1,2)
    conv2D(8,8,64,0,1)
    transpConv2D(8,64,8,0,1)
    transpConv2D(4,8,4,1,2)
    transpConv2D(4,4,1,1,2)
    % ... and here
    regressionLayer
];


%{
diff --git a/assignments/hw3/matlab/define_autoencoder.m b/assignments/hw3/matlab/define_autoencoder.m
index 98d474a..19d3d94 100755
--- a/assignments/hw3/matlab/define_autoencoder.m
+++ b/assignments/hw3/matlab/define_autoencoder.m
@@ -3,13 +3,12 @@ function layers = define_autoencoder()
 layers = [
     imageInputLayer([32,32,1]) % H W channels
     % intermediate layers go between here ...
-    conv2D(4,1,8,1,2)
-    conv2D(4,8,16,1,2)
-    conv2D(8,16,64,0,1)
-    transpConv2D(8,64,16,0,1)
-    transpConv2D(4,16,8,1,2)
-    transpConv2D(4,8,1,1,2)
+    conv2D(4,1,4,1,2)
+    conv2D(4,4,8,1,2)
+    conv2D(8,8,64,0,1)
+    transpConv2D(8,64,8,0,1)
+    transpConv2D(4,8,4,1,2)
+    transpConv2D(4,4,1,1,2)
     % ... and here
     regressionLayer
 ];
-
%}
