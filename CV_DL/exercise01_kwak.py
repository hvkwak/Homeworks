import tensorflow as tf
import numpy as np

tf.disable_eager_execution()

# instead of: tf.reset_default_graph()
# initialize a default graph:
tf.reset_default_graph() 

# initial Variable of x = [2, 1] : Initial Value
# constant variable of y = [3, 5] : Target
x = tf.Variable(np.array([2, 1]), dtype=tf.float32, name = "x") 
y = tf.constant(np.array([3, 5]), dtype=tf.float32, name = "y") # this changes not

z = tf.placeholder(shape = [None, 2], dtype=tf.float32, name = "z")

loss = tf.reduce_sum((x - y + z)**2)
train_step = tf.train.GradientDescentOptimizer(0.1).minimize(loss)
z_ = np.array([[2,0]])

# Optimizes the loss, using the z value as a placeholder.
# Because of z_ = [2, 0], variable x converges to [1, 5], so that this
# minimize the loss of (x - y + z)**2.
with tf.Session() as sess:
    sess.run(tf.global_variables_initializer()) # To have these variables initialized 
    for k in range(100):
        train_step.run( feed_dict={z:z_})
        print("Step No. %d" % k)
        print(loss.eval( feed_dict={z:z_}) )
        print( x.eval() )

# Alternatively we could remove z and optimize the loss, so that x
# converges to [3, 5].