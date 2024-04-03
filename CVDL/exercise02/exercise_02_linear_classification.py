import matplotlib.pyplot as plt
import numpy as np
from DLCVDatasets import get_dataset

if __name__ == "__main__":

    x_train, y_train, x_test, y_test, class_names = get_dataset( 'cifar10', range(10), training_size=1000, test_size=100 )

    # since the range of the images is 0 to 255, we reduce it to -0.5 to 0.5
    x_mean = 127.
    x_std = 255.
    x_train = (x_train - x_mean) / x_std
    x_test = (x_test - x_mean) / x_std

    data = x_train

    num_features = np.prod( x_train[0].shape ) # size of vector to classify
    num_classes = 10 # number of classes in CIFAR

    W = np.zeros([num_features, num_classes], np.float32) 

    plt.figure()
    for class_chosen in range(10):

        # average image as a direction vector for linear classification
        theta = np.mean( x_train[y_train == class_chosen], axis = 0 ) 

        W[:, class_chosen] = theta.flatten()

        # reshape and show average image vector
        plt.subplot(2, 5, class_chosen + 1)
        plt.imshow( ( (theta * x_std) + x_mean ).astype(np.uint8) ) # recast to uint8 to properly visualize the image
        plt.title(class_names[class_chosen])
    plt.show()

    # output training and test performance
    print('Training performance')
    print('Overall training classification rate: %5.2f' % np.mean((np.argmax(np.matmul(np.reshape(x_train, [x_train.shape[0], -1]), W), axis=1) == y_train).astype(np.float32)))
    for class_chosen in range(10):
        curr_data_vec = x_train[y_train == class_chosen].reshape( [-1, num_features] )
        print('Classification training rate (%s): %5.2f' % ( class_names[class_chosen], np.mean((np.argmax(np.matmul(curr_data_vec, W), axis=1) == class_chosen).astype(np.float32)) ) )

    print('Test performance')
    print('Overall test classification rate: %5.2f' % np.mean((np.argmax(np.matmul(np.reshape(x_test, [x_test.shape[0], -1]), W), axis=1) == y_test).astype(np.float32)))
    for class_chosen in range(10):
        curr_test_data_vec = x_test[y_test == class_chosen].reshape( [-1, num_features] )
        print('Classification test rate (%s): %5.2f' % ( class_names[class_chosen], np.mean((np.argmax(np.matmul(curr_test_data_vec, W), axis=1) == class_chosen).astype(np.float32)) ) )

