import tensorflow.compat.v1 as tf
import numpy as np
import cv2 as cv
from DLCVDatasets import get_dataset
from HelpfulCode import compute_hog
import matplotlib.pyplot as plt
import math

def one_hot_encoder(index, num_classes):
    '''
        returns a vector, which contains a digit 1 at the index and zeros at others.
    '''
    y = np.zeros(num_classes, dtype=np.float32)
    y[index-1] = 1
    return(y)

def one_hot_mat(y_train):
    memory_mat = np.zeros((np.prod(y_train.shape), 10))
    for i in range(memory_mat.shape[0]):
        y_vec = y_train.flatten()
        memory_mat[i] = one_hot_encoder(y_vec[i], 10)
    return(memory_mat)

def best_parameter(x_train, y_train, x_test, y_test):
    """
        finds the best combination of the available parameters.
        make sure that the MNIST image set consist of images size of (28, 28)
    """
    best_acc = 0
    best_cell = None
    best_block = None
    best_nbins = None
    cell_size = [(4, 4), (7, 7)] # takes cell_size according to image size: (28, 28)
    block_size = [(1, 1), (2, 2), (3, 3), (4, 4)]
    nbins = [9, 18, 36]

    for i in cell_size:
        for j in block_size:
            for k in nbins:
                print("cell_size: ", i)
                print("block_size: ", j)
                print("nbins: ", k)
                hog_feature_tr = compute_hog(cell_size = i, block_size = j, nbins = k, imgs_gray = x_train)
                hog_feature_ts = compute_hog(cell_size = i, block_size = j, nbins = k, imgs_gray = x_test)
                ts_acc = linear_classifier(hog_feature_tr, y_train, hog_feature_ts, y_test, 10, 0.1, x_train.shape[0])[1]
                if best_acc < ts_acc:
                    best_cell = i
                    best_block = j
                    best_nbins = k
                    best_acc = ts_acc

    return(best_cell, best_block, best_nbins, ts_acc)

def linear_classifier(x_train, y_train, x_test, y_test, num_classes, learning_rate, iterations):
    """
        Define and train linear classifier for MNIST classification

        :param  x_train  nr x num_features training data
        :param  y_train  nr x int label data
        :param  x_test   nr x num_features test data
        :param  y_test   nr x int label data
        :param  num_classes     number of classes to classify
        :param  learning_rate
        :param  iterations
        (This is a mini exercise. Let us just train one epoch.)

        :return accuracy of classification tr_acc, ts_acc

    """

    # x_train and x_test are HoG features.
    num_features = x_train.shape[1]
    
    # Build a network
    tf.disable_eager_execution()
    tf.reset_default_graph()

    x = tf.placeholder(tf.float32, shape=[None, num_features], name="images")
    y_ = tf.placeholder(tf.int32, shape=[None, num_classes], name="labels")

    w = tf.get_variable("weights", shape=[num_features, num_classes]) # default initializer
    b = tf.get_variable("offsets", shape=[1, num_classes])

    y_hat = tf.matmul(x, w) + b

    correct_labels = tf.argmax(y_, axis = 1, output_type = tf.int32)
    predicted_labels = tf.argmax(y_hat, axis=1, output_type=tf.int32)

    # type change of correct_prediction into float -> loss computation.
    correct_prediction = tf.cast(tf.equal(correct_labels, predicted_labels), tf.float32)
    # tf.reduce_sum(correct_prediction, axis = None)
    accuracy = tf.reduce_sum(correct_prediction) / tf.cast(tf.shape(correct_prediction)[0], tf.float32)

    # Loss : L2 Norm
    # loss = tf.reduce_mean(tf.nn.l2_loss(y_hat - tf.cast(y_, tf.float32)))

    # Loss : Cross-Entropy
    loss = tf.reduce_mean(tf.nn.softmax_cross_entropy_with_logits(labels=tf.cast(y_, tf.float32), logits=y_hat), name='loss')
    train_step = tf.train.GradientDescentOptimizer(learning_rate).minimize(loss)

    with tf.Session() as sess:
        # one epoch
        sess.run(tf.global_variables_initializer())
        # iterations.
        for i in range(iterations):
            y = one_hot_encoder(y_train[i], num_classes)

            # feed_dict: set the dimension of feed_dict correctly.
            # e.g. np.array([np.object])
            # train the classifier with images one by one(SGD), no batches
            sess.run((train_step, loss, accuracy), feed_dict={x:np.array([x_train[i]]), y_:np.array([y])})
        
        training_accuracy = accuracy.eval(feed_dict={x: x_train, y_: one_hot_mat(y_train)})
        testing_accuracy = accuracy.eval(feed_dict={x: x_test, y_: one_hot_mat(y_test)})

        # Return training and testing error rate
        return(training_accuracy, testing_accuracy)

def distance_HoG_center(hog_feature, centers):
    '''
        returns a matrix of computed distance.
    '''
    if not hog_feature.shape[1] == centers.shape[1]:
        raise(IndexError)
    else:
        A = hog_feature.shape[0]
        B = 10
        # a matrix of inf
        D = np.array([np.float("inf")]*(A*B)).reshape((A, B))
        for i in np.arange(hog_feature.shape[0]):
            for j in np.arange(centers.shape[0]):
                dist = np.linalg.norm(hog_feature[i,:] - centers[j,:])
                D[i, j] = dist
        return(D)


def exercise03_1(x_train, y_train, x_test, y_test, class_names, training_size = 100, test_size = 100):
    '''    
    Extract HoG features from every image. Train a linear classifier to classify 
    the digit images. Try different parameter combinations (cell size, block size, 
    histogram bins) automatically and evaluate which choice of parameters works 
    best. What is the error rate when using the best parameter combination?
    '''                     
    best_cell, best_block, best_nbins, best_acc = best_parameter(x_train, y_train, x_test, y_test)
    print("-----------------------------")
    print("best_cell: ", best_cell)
    print("best_block: ", best_block)
    print("best_nbins: ", best_nbins)
    print("best_acc: ", best_acc)
    print("-----------------------------")
    return(best_cell, best_block, best_nbins, best_acc)

def exercise03_2(x_train, y_train, x_test, y_test, best_cell, best_block, best_nbins):
    '''
    Check how well the HOG feature extraction separates the different digit classes. Perform a k-
    means clustering on the HOG vectors corresponding to the best choice of feature extraction parameters.
    Use k = 10 for this (or adapt k to the number of digit classes that you work with if you do not use all of
    them). You end up with k cluster centers. Show the images corresponding to some of the HOG vectors
    that have minimum Euclidean distance to the cluster centers. Does the HOG feature extraction provide
    a useful clustering of the MNIST dataset?
    '''
    
    hog_feature_tr = np.float32(compute_hog(best_cell, best_block, best_nbins, imgs_gray = x_train))
    # hog_feature_ts = np.float32(compute_hog(best_cell, best_block, best_nbins, imgs_gray = x_test))

    # Set criteria/flags
    criteria = (cv.TERM_CRITERIA_EPS + cv.TERM_CRITERIA_MAX_ITER, 50, 1.0)
    flags = cv.KMEANS_RANDOM_CENTERS

    # Apply KMeans
    compactness, labels, centers = cv.kmeans(hog_feature_tr, 10, None, criteria, 50, flags)
    distance_Mat = distance_HoG_center(hog_feature_tr, centers)

    # minimum index each row
    min_index = np.argmin(distance_HoG_center(hog_feature_tr, centers), axis=1)

    # Visualize results:
    fig = plt.figure(figsize=(15, 15))
    images_per_row = np.int(np.ceil(np.sqrt(x_train.shape[0])+5))
    k = 1
    for i in np.arange(10):
        image_index = np.where(min_index == i)[0]
        space = images_per_row - np.mod(image_index.size, images_per_row)
        for j in np.arange(image_index.size):
            if j == 0:
                fig.add_subplot(images_per_row, images_per_row, k).set_title("Cluster: " + str(i), x=-3, y=0.0)
            fig.add_subplot(images_per_row, images_per_row, k)
            plt.imshow(x_train[image_index[j]])
            plt.axis("off")
            k = k+1
        while space > 0:
            fig.add_subplot(images_per_row, images_per_row, k)
            plt.axis("off")
            k = k + 1
            space = space - 1
    plt.show()

if __name__ == "__main__":

    # Choose the size of train/test dataset:
    training_size = 1000
    test_size = 100

    # load data
    x_train, y_train, x_test, y_test, class_names = get_dataset('mnist', 
                                                                range(10), 
                                                                training_size, 
                                                                test_size) 
    exercise03_1(x_train, y_train, x_test, y_test, class_names, training_size, test_size)
    ''' Best record(update on 20.12.2019)
        tr/ts size: 2000/500
        best_cell:  (4, 4)
        best_block:  (4, 4)
        best_nbins:  18
        best_acc:  0.842
    '''
    exercise03_2(x_train, y_train, x_test, y_test, best_cell = (4, 4), best_block = (4, 4), best_nbins = 18)