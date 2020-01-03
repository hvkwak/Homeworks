import tensorflow.compat.v1 as tf
import numpy as np
from DLCVDatasets import get_dataset
import math

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




def get_network_graph(num_features, num_classes,
                      num_layers, activation_function,
                      learning_rate = 0.1):

    n = Network()
    num_hidden_neurons = 20  # Neurons per hidden layer

    tf.disable_eager_execution()
    tf.reset_default_graph()

    # n.x : placeholder. no matter the number of row, it works.
    n.x = tf.placeholder(tf.float32, shape=[None, num_features], name="images")
    n.y_ = tf.placeholder(tf.int32, shape=[None], name="labels")

    current_layer = n.x

    # First hidden layer
    # variables are in the scope of Layer1:
    with tf.variable_scope("Layer1"):
        w = tf.get_variable("weights", shape=[num_features, num_hidden_neurons])
        b = tf.get_variable("offsets", shape=[1, num_hidden_neurons])
        n.weights.append(w)
        n.biases.append(b)
        
        # check the dimension of tf.matmul and activation function.
        current_layer = activation_function(tf.matmul(current_layer, w) + b)

    '''
    # Other hidden layers
    for i in range(2, num_layers + 1):
        with tf.variable_scope("Layer" + str(i)):
            w = tf.get_variable("weights", shape=[num_hidden_neurons, num_hidden_neurons])
            b = tf.get_variable("offsets", shape=[1, num_hidden_neurons])
            n.weights.append(w)
            n.biases.append(b)
            current_layer = activation_function(tf.matmul(current_layer, w) + b)
    '''

    # Output layer
    with tf.variable_scope("LayerOutput"):
        w = tf.get_variable("weights", shape=[num_hidden_neurons, num_classes])
        b = tf.get_variable("offsets", shape=[1, num_classes])
        n.weights.append(w)
        n.biases.append(b)
        y_unscaled = tf.matmul(current_layer, w) + b

    correct_labels = n.y_
    predicted_labels = tf.argmax(y_unscaled, axis=1, output_type=tf.int32)
    correct_prediction = tf.cast(tf.equal(correct_labels, predicted_labels), tf.float32)
    n.accuracy = tf.reduce_sum(correct_prediction) / tf.cast(tf.shape(correct_prediction)[0], tf.float32)

    # loss, train_step, init_op.
    n.loss = tf.reduce_mean(tf.nn.sparse_softmax_cross_entropy_with_logits(logits=y_unscaled, labels=n.y_))
    n.train_step = tf.train.GradientDescentOptimizer(learning_rate).minimize(n.loss)
    n.init_op = tf.global_variables_initializer()

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
    last_whole_percent = 0

    # Train network
    config = tf.ConfigProto()
    config.gpu_options.allow_growth = True

    with tf.Session(config=config) as sess:

        sess.run(n.init_op) # variables initializer
        old_weights = [w.eval() for w in n.weights] # old weights.

        for epoch in range(num_epochs): # per epoch
            for batch in range(num_batches): # per batch

                # batch_start and batch_end index
                batch_start = batch * batch_size
                batch_end = batch_start + batch_size

                # run train_step and loss
                _, loss_val = sess.run((n.train_step, n.loss), 
                                        feed_dict={
                                        n.x : tr_data[batch_start:batch_end],
                                        n.y_: tr_labels[batch_start:batch_end],
                                        })
                new_weights = [w.eval() for w in n.weights]

                # Print status at certain intervals
                iteration = epoch * num_batches + batch
                progress = (iteration + 1) / total_iterations
                whole_percent = math.floor(progress * 100)

                if iteration == 0 or last_whole_percent != whole_percent:
                    # Calculate change in weights after each batch
                    weight_change = np.asarray([np.mean(np.abs(old - new))
                                                for old, new in zip(old_weights, new_weights)])
                    # Calculate training and testing accuracy
                    training_accuracy = n.accuracy.eval(feed_dict={n.x: tr_data, n.y_: tr_labels})
                    testing_accuracy = n.accuracy.eval(feed_dict={n.x: ts_data, n.y_: ts_labels})
                    # Print status
                    print("\r{:4d}/{} [{}] ({:3.0f}%), L: {:f}, ATrain: {:4.1f}%, ATest: {:4.1f}%, dW: {}".format(
                        epoch + 1, num_epochs, get_progress_arrow(20, progress), progress * 100,
                        loss_val, training_accuracy * 100, testing_accuracy * 100, weight_change
                    ), end="")
                last_whole_percent = whole_percent
                old_weights = new_weights

                if batch == 0 and epoch % 5 == 0:
                    # After the first batch of some epochs print a new line to keep a history in console
                    print("")

        print("")  # New line

        training_accuracy = n.accuracy.eval(feed_dict={n.x: tr_data, n.y_: tr_labels})
        testing_accuracy = n.accuracy.eval(feed_dict={n.x: ts_data, n.y_: ts_labels})
        print("Finished training with {:4.1f}% training and {:4.1f}% testing accuracy"
              .format(training_accuracy * 100, testing_accuracy * 100))

        # Return training and testing error rate
        return 1 - training_accuracy, 1 - testing_accuracy


def build_and_train_network(train_data, train_labels,
                            test_data, test_labels, num_classes,
                            num_layers, activation_function,
                            learning_rate = 0.1, num_epochs = 20):
    # data: rows are images, columns are hog features
    # labels_one_hot: rows are images, columns are classes
    num_images, num_features = train_data.shape
    print("\nTraining network with {} features, {} hidden layer(s) using {}, and {} classes on {} training images"
          .format(num_features, num_layers, get_name(activation_function), num_classes, num_images))

    # Build network
    network = get_network_graph(num_features, num_classes, num_layers, activation_function, learning_rate)

    train_network(network, train_data, train_labels, test_data, test_labels, num_epochs)

def reshape_and_normalize_data(x_train, x_test):
    
    # Flatten all but first dimension (which are the different input images)
    x_train = np.reshape(x_train, (x_train.shape[0], -1))
    x_test = np.reshape(x_test, (x_test.shape[0], -1))

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


def main():
    # Adapt this to control the size of the training data
    used_labels = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]
    training_size = 6000
    test_size = 1000
    num_classes = len(used_labels)

    x_train, y_train, x_test, y_test, class_names = get_dataset('mnist', used_labels, training_size, test_size)    
    x_train, x_test = reshape_and_normalize_data(x_train, x_test)

    for activation_function in [tf.sigmoid, tf.nn.relu]:
        for num_layers in [1, 2, 3, 8]:
            build_and_train_network(x_train, y_train, x_test, y_test, num_classes, num_layers, activation_function)    

if __name__ == "__main__":
    os.environ['TF_CPP_MIN_LOG_LEVEL'] = '3'  # Suppress TensorFlow GPU Debug Log Output
    np.set_printoptions(precision=6, linewidth=200)  # Print weight changes on a single line
    main()