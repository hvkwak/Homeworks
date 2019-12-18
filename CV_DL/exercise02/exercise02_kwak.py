import tensorflow.compat.v1 as tf
import numpy as np
import matplotlib.pyplot as plt
from DLCVDatasets import get_dataset

if __name__ == "__main__":
    x_train, y_train, x_test, y_test, class_names = get_dataset('cifar10', [0, 1, 2, 3, 4, 5, 6, 7, 8, 9], training_size=1000, test_size=100)

    # Normalize the dataset to have zero mean in [-0.5, 0.5]
    x_mean = (0+255)/2
    x_max = 255
    x_train = (x_train - x_mean) / x_max
    x_test = (x_test - x_mean) / x_max

    # memory matrix: W
    W = np.zeros((len(class_names), np.prod(x_train[0].shape)))

    plt.figure()
    for i in range(len(class_names)):

        # average image as a direction vector for linear classification,
        # which eventually measures cosine distance
        theta = np.mean(x_train[y_train == i], axis = 0)
        W[i, :] = theta.flatten()

        # reshape and show average image vector
        plt.subplot(2, 5, i + 1)
        plt.imshow( ( (theta * x_max) + x_mean ).astype(np.uint8) ) # recast to uint8 to properly visualize the image
        plt.title(class_names[i])
    plt.show()

    # classification rate:
    y_hat_tr = np.zeros(len(class_names), dtype=int)
    y_hat_ts = np.zeros(len(class_names), dtype=int)

    for i in range(len(x_train)):
        y_hat_tr = np.argmax(np.matmul(W, x_train[i].flatten()))
    for i in range(len(x_test)):
        y_hat_ts = np.argmax(np.matmul(W, x_test[i].flatten()))

    # tr.data classification rate: 0.114
    # ts.data classification rate: 0.11
    # No significant difference between the rates.
    # Therefore no clear sign of overfitting. 
    print("tr.data classification rate: ", np.mean(y_hat_tr == y_train))
    print("ts.data classification rate: ", np.mean(y_hat_ts == y_test))

