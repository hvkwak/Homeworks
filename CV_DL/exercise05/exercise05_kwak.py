'''
    created by: Hyovin Kwak
'''

import tensorflow.compat.v1 as tf
import numpy as np
# from DLCVDatasets import get_dataset
import math
import os

def get_progress_arrow(width: int, progress: float):
    num_progress = math.floor(width * progress)
    arrow = num_progress * "="
    if num_progress != width:
        arrow += ">"
        arrow += " " * (width - 1 - num_progress)
    return arrow

def get_name(func):
    return func.__name__

class Network:

    def __init__(self):
        self.x = None
        self.y_ = None

        self.weights = []
        self.biases = []

        self.loss = None
        self.accuracy = None

        self.init_op = None
        self.train_step = None



def conv2d(current_layer, filter_size, strides_, out_channels, name):
    with tf.variable_scope("ConvLayer" + name):
        in_channels = current_layer.get_shape()[-1]
        filters = tf.get_variable("filters", shape=[filter_size, filter_size, in_channels, out_channels])
        x = tf.nn.conv2d(current_layer, filters, strides=[1, strides_, strides_, 1], padding='SAME')
        # x = tf.nn.bias_add(x, b)
        return x

def maxpool2d(current_layer, name, k=2):
    with tf.variable_scope("MaxPoolLayer" + name):
        # ksize = kernel size
        return tf.nn.max_pool(current_layer, ksize=[1, k, k, 1], strides=[1, k, k, 1], padding='SAME')


def get_network_graph(image_shape, num_classes,
                      num_layers, activation_function,
                      learning_rate = 0.1):

    n = Network()

    tf.disable_eager_execution()
    tf.reset_default_graph()

    input_shape = image_shape
    if len(input_shape) < 3: # only two elements like (28, 28)
        input_shape = input_shape + (1,)
    
    # x and y of Network n are placeholders.
    # n.x : placeholder. no matter the number of row, it works.
    n.x = tf.placeholder(tf.float32, shape=[None, *input_shape], name="images")
    n.y_ = tf.placeholder(tf.int32, shape=[None], name="labels")

    # add a Convolution and a Max-Pooling layer
    current_layer = n.x
    for i in np.arange(1):
        current_layer = conv2d(current_layer, 3, 1, 16, str(i+1))
        current_layer = maxpool2d(current_layer, str(i+1))

    # Flatten the current_layer to put into fully connected layers!
    current_layer = tf.layers.Flatten()(current_layer)
    print("After Flatten: {}".format(current_layer.get_shape()))

    # Add fully connected layers
    # First hidden layer
    # variables are in the scope of Layer1:
    with tf.variable_scope("Layer1"):
        neurons_num = current_layer.get_shape()[1] # also for hidden neurons
        # not to forget that the dimension of the weight matrix and bias vector
        # is transposed.
        w = tf.get_variable("weights", shape=[neurons_num, neurons_num])
        b = tf.get_variable("offsets", shape=[1, neurons_num])

        # w(weights) shape of (num_features, num_hidden_neurons) added.
        # b(biases) shape of (1, num_hidden_neurons) biases added.
        n.weights.append(w)
        n.biases.append(b)
        
        # check the dimension of tf.matmul and activation function.
        current_layer = activation_function(tf.matmul(current_layer, w) + b)

    # Other hidden layers
    for i in range(2, num_layers + 1):
        with tf.variable_scope("Layer" + str(i)):
            w = tf.get_variable("weights", shape=[neurons_num, neurons_num])
            b = tf.get_variable("offsets", shape=[1, neurons_num])
            n.weights.append(w)
            n.biases.append(b)
            current_layer = activation_function(tf.matmul(current_layer, w) + b)

    # Output layer
    with tf.variable_scope("LayerOutput"):
        w = tf.get_variable("weights", shape=[neurons_num, num_classes])
        b = tf.get_variable("offsets", shape=[1, num_classes])
        n.weights.append(w)
        n.biases.append(b)
        y_unscaled = tf.matmul(current_layer, w) + b

    correct_labels = n.y_
    predicted_labels = tf.argmax(y_unscaled, axis=1, output_type=tf.int32)
    
    # change the true/falses to float32.
    correct_prediction = tf.cast(tf.equal(correct_labels, predicted_labels), tf.float32)
    n.accuracy = tf.reduce_sum(correct_prediction) / tf.cast(tf.shape(correct_prediction)[0], tf.float32)

    # loss, train_step, variables initilizer
    n.loss = tf.reduce_mean(tf.nn.sparse_softmax_cross_entropy_with_logits(logits=y_unscaled, labels=n.y_))
    n.train_step = tf.train.GradientDescentOptimizer(learning_rate).minimize(n.loss)
    n.init_op = tf.global_variables_initializer()

    # return the network.
    return n


def train_network(n, tr_data, tr_labels,
                  ts_data, ts_labels,
                  num_epochs= 20, batch_size = 128):

    sample_size = tr_data.shape[0]
    if batch_size is None:
        # sample_size itself will be the batch_size.
        batch_size = sample_size

    num_batches = math.ceil(sample_size / batch_size)
    total_iterations = num_epochs * num_batches
    last_progress_in_percent = 0

    # Train network: loss and train_step update

    config = tf.ConfigProto()
    config.gpu_options.allow_growth = True
    with tf.Session(config=config) as sess:

        sess.run(n.init_op) # variables initializer
        # old_weights = [w.eval() for w in n.weights] # a list of weights.

        for epoch in range(num_epochs): # per epoch
            for batch in range(num_batches): # per batch

                # batch_start and batch_end index
                batch_start = batch * batch_size
                batch_end = batch_start + batch_size

                # run train_step and loss
                # you can train and compute loss at the same time like this:
                _, loss_val = sess.run((n.train_step, n.loss), 
                                        feed_dict={
                                        n.x : tr_data[batch_start:batch_end],
                                        n.y_: tr_labels[batch_start:batch_end],
                                        })
                new_weights = [w.eval() for w in n.weights]

                # Print status at certain intervals
                iteration = epoch * num_batches + batch
                progress = (iteration + 1) / total_iterations
                progress_in_percent = math.floor(progress * 100)

                if iteration == 0 or last_progress_in_percent != progress_in_percent:
                    # Calculate change in weights after each batch
                    '''
                    weight_change = np.asarray([np.mean(np.abs(old - new))
                                                for old, new in zip(old_weights, new_weights)])
                    '''
                    # Calculate training and testing accuracy
                    training_accuracy = n.accuracy.eval(feed_dict={n.x: tr_data, n.y_: tr_labels})
                    testing_accuracy = n.accuracy.eval(feed_dict={n.x: ts_data, n.y_: ts_labels})
                    # Print status
                    print("\r{:4d}/{} [{}] ({:3.0f}%), L: {:f}, ATrain: {:4.1f}%, ATest: {:4.1f}%".format(
                        epoch + 1, num_epochs, get_progress_arrow(20, progress), progress * 100,
                        loss_val, training_accuracy * 100, testing_accuracy * 100
                    ), end="")
                
                # progress and weights update:
                last_progress_in_percent = progress_in_percent
                old_weights = new_weights

                # every 5 epoch print an additional new line.
                if batch == 0 and epoch % 5 == 0:
                    # After the first batch of some epochs print a new line to keep a history in console
                    print("")

        print("")  # New line

        # check the accuracy after training.
        training_accuracy = n.accuracy.eval(feed_dict={n.x: tr_data, n.y_: tr_labels})
        testing_accuracy = n.accuracy.eval(feed_dict={n.x: ts_data, n.y_: ts_labels})
        print("Finished training with {:4.1f}% training and {:4.1f}% testing accuracy"
              .format(training_accuracy * 100, testing_accuracy * 100))

        # Return training and testing error rate
        return 1 - training_accuracy, 1 - testing_accuracy

'''
def build_and_train_network(train_data, train_labels,
                            test_data, test_labels, num_classes,
                            num_layers, activation_function,
                            learning_rate = 0.1, num_epochs = 20):
    # data: rows are images, columns are hog features
    # labels_one_hot: rows are images, columns are classes
    num_images = train_data.shape[0]
    image_shape = train_data.shape[1:2]
    print("\nTraining network with {} features, {} hidden layer(s) using {}, and {} classes on {} training images"
          .format(num_features, num_layers, get_name(activation_function), num_classes, num_images))

    # Build network
    network = get_network_graph(num_features, num_classes, num_layers, activation_function, learning_rate)

    # train the network and show the results:
    train_network(network, train_data, train_labels, test_data, test_labels, num_epochs)
'''

def normalize_data(x_train, x_test):
    
    # Flatten all but first dimension (which are the different input images)
    # x_train = np.reshape(x_train, (x_train.shape[0], -1))
    # x_test = np.reshape(x_test, (x_test.shape[0], -1))

    # Convert to float32
    x_train = np.float32(x_train)
    x_test = np.float32(x_test)

    # Minus mean
    mean = np.mean(x_train)
    x_train -= mean
    x_test -= mean

    # Standard deviation of 1
    std = np.std(x_train)
    x_train = x_train / std
    x_test = x_test / std

    # return the normalized and flattened dataset
    return x_train, x_test

def loadMNIST(prefix, folder):
	intType = np.dtype( 'int32' ).newbyteorder( '>' )
	nMetaDataBytes = 4 * intType.itemsize

	data = np.fromfile( folder + "/" + prefix + '-images-idx3-ubyte', dtype = 'ubyte' )
	magicBytes, nImages, width, height = np.frombuffer( data[:nMetaDataBytes].tobytes(), intType )
	data = data[nMetaDataBytes:].astype( dtype = 'float32' ).reshape( [ nImages, width, height ] )

	labels = np.fromfile( folder + "/" + prefix + '-labels-idx1-ubyte',
                          dtype = 'ubyte' )[2 * intType.itemsize:]
	return data, labels
'''
trainingImages, trainingLabels = loadMNIST( "train", "/data/MNIST/raw" )
testImages, testLabels = loadMNIST( "t10k", "/data/MNIST/raw" )
'''

def main():
    # Adapt this to control the size of the training data
    used_labels = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]
    training_size = 6000
    test_size = 1000
    num_classes = len(used_labels)

    '''
    x_train, y_train, x_test, y_test, class_names = get_dataset('mnist', used_labels, training_size, test_size)    
    '''
    x_train, y_train = loadMNIST( "train", "/data/MNIST/raw")
    x_test, y_test = loadMNIST( "t10k", "/data/MNIST/raw")
    x_train, x_test = normalize_data(x_train, x_test)

    if len(x_train.shape) < 4:
        x_train = x_train[:, :, :, np.newaxis]
        x_test = x_test[:, :, :, np.newaxis]

    for activation_function in [tf.nn.relu]:
        for num_layers in [3]:
            # Build network
            network = get_network_graph(x_train.shape[1:], num_classes, num_layers, activation_function, learning_rate = 0.1)

            # train the network and show the results:
            train_network(network, x_train, y_train, x_test, y_test, num_epochs = 20)

            # build_and_train_network(x_train, y_train, x_test, y_test, num_classes, num_layers, activation_function)    

if __name__ == "__main__":
    os.environ['TF_CPP_MIN_LOG_LEVEL'] = '3'  # Suppress TensorFlow GPU Debug Log Output
    np.set_printoptions(precision=6, linewidth=200)  # Print weight changes on a single line
    main()