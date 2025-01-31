import os
import tensorflow.keras as keras
from tensorflow.keras.datasets import mnist
from tensorflow.keras.preprocessing.image import ImageDataGenerator
from tensorflow.keras.models import Model
from tensorflow.keras.layers import Conv2D, Dense, Flatten, MaxPooling2D, Dropout, Input
from tensorflow.keras.losses import categorical_crossentropy
import tensorflow.keras.backend as K
from DeConvNet import MyCallback, DConvolution2D, DActivation, DInput, DDense, DFlatten, DPooling, load_an_image, deconv_save, load_images
import numpy as np
import math
import matplotlib.pyplot as plt
import PIL
import matplotlib.image
from PIL import Image

if __name__ == "__main__":
    #################################################################
    #                  Load Data and Preprocessing                  #
    #################################################################
    input_shape = (28, 28, 1)
    num_classes = 10

    # change these values.
    epochs = 50 # 50
    batch_size = 128 # 128

    print("Load images....")
    train_x, train_y = load_images(True)
    test_x, test_y = load_images(False)
    train_y = keras.utils.to_categorical(train_y)
    test_y = keras.utils.to_categorical(test_y)

    #################################################################
    #                  Models and Fit                               #
    #################################################################
    whichmodel = input("which model would you like? type in model2, model3 or model4. ")

    if whichmodel == "model2":
        # Model 2 - Arslan's alternative suggestion
        inputs0 = Input(shape=(28, 28, 1,))
        x = Conv2D(32, kernel_size=(3, 3), activation='relu', padding = 'same', input_shape=(28,28,1))(inputs0)
        x = Conv2D(64, kernel_size=(3, 3), activation='relu', padding = 'same', input_shape=(28,28,1))(x)
        x = MaxPooling2D(pool_size=(2, 2))(x)                        
        x = Flatten()(x)
        x = Dense(64, activation='relu')(x)
        predictions = Dense(num_classes, activation='softmax')(x)
        model_func = Model(inputs=inputs0, outputs=predictions, name = 'model2')
        
        model_func.summary()
        model_func.compile(loss=keras.losses.categorical_crossentropy, optimizer=keras.optimizers.Adadelta(), metrics=['accuracy'])
        
        model_func.fit(
            train_x, train_y,
            batch_size = batch_size,
            epochs=epochs,
            shuffle = True,
            validation_data=(test_x, test_y),
            callbacks=[MyCallback(model_func)]
            )
        
        print("current directory: ", os.getcwd())
        save_dir = os.path.join(os.getcwd(), 'saved_models')
        model_name = 'keras_trained_model_with_model_2.h5'
        if not os.path.isdir(save_dir):
            os.makedirs(save_dir)
        model_path = os.path.join(save_dir, model_name)
        model_func.save(model_path)
        print('Saved trained model at %s ' % model_path)
        
        # load 2 images
        normal_img = load_an_image() # class: paper
        img_blacked = load_an_image()[0, :, :, :] 
        img_blacked[8:22, 8:22, :] = 0
        print("model_func prediction: normal, blacked")
        print("model_func.predict(normal_img): ", model_func.predict(normal_img))
        print("model_func.predict(img_blacekd): ", model_func.predict(img_blacked[np.newaxis, :]))
        model_func.evaluate(test_x, test_y)

    elif whichmodel == "model3" : # model3
        # Model 3 - Arslan's another alternative suggestion
        inputs1 = Input(shape=(28, 28, 1,))
        x1 = Conv2D(32, (3, 3), padding='same', input_shape = (28, 28, 1), activation = 'relu')(inputs1)
        x1 = Conv2D(32, (3, 3), padding = 'same', input_shape = (28, 28, 1), activation='relu')(x1)
        x1 = MaxPooling2D(pool_size=(2, 2))(x1)
        x1 = Conv2D(64, (3, 3), padding='same', input_shape = (14, 14, 1), activation = 'relu')(x1)
        x1 = Conv2D(64, (3, 3), padding = 'same', input_shape = (14, 14, 1), activation='relu')(x1)
        x1 = MaxPooling2D(pool_size=(2, 2))(x1)
        x1 = Conv2D(64, (3, 3), padding ='same', input_shape = (7, 7, 1), activation = 'relu')(x1)
        x1 = Conv2D(64, (3, 3), padding = 'same', input_shape = (7, 7, 1), activation='relu')(x1)       
        x1 = Flatten()(x1)
        x1 = Dense(32, activation = 'relu')(x1)
        predictions1 = Dense(units = num_classes, activation = 'softmax')(x1)
        model_func1 = Model(inputs=inputs1, outputs=predictions1, name='model3')
        
        # Compiling the CNN
        model_func1.compile(loss=keras.losses.categorical_crossentropy, optimizer=keras.optimizers.RMSprop(), metrics=['accuracy'])
        model_func1.summary()
        
        model_func1.fit(
            train_x, train_y,
            batch_size = batch_size,
            epochs=epochs,
            shuffle = True,
            validation_data=(test_x, test_y),
            callbacks=[MyCallback(model_func1)]
            )
        print("current directory: ", os.getcwd())
        save_dir = os.path.join(os.getcwd(), 'saved_models')
        model_name1 = 'keras_trained_model_with_model_3.h5'
        if not os.path.isdir(save_dir):
            os.makedirs(save_dir)
        model_path1 = os.path.join(save_dir, model_name1)
        model_func1.save(model_path1)
        print('Saved trained model at %s ' % model_path1)
        # load 2 images
        normal_img = load_an_image() # class: paper
        img_blacked = load_an_image()[0, :, :, :] 
        img_blacked[8:22, 8:22, :] = 0
        print("model_func1 prediction: normal, blacked")
        print("model_func1.predict(normal_img): ", model_func1.predict(normal_img))
        print("model_func1.predict(img_blacekd): ", model_func1.predict(img_blacked[np.newaxis, :]))
        model_func1.evaluate(test_x, test_y)

    else:
        # Model 4 - another suggestion
        inputs2 = Input(shape=(28, 28, 1,))
        x2 = Conv2D(32, (3, 3), padding='same', input_shape = (28, 28, 1), activation = 'relu')(inputs2)
        x2 = Conv2D(32, (3, 3), padding = 'same', input_shape = (28, 28, 1), activation='relu')(x2)
        x2 = MaxPooling2D(pool_size=(2, 2))(x2)
        x2 = Conv2D(64, (3, 3), padding='same', input_shape = (14, 14, 1), activation = 'relu')(x2)
        x2 = Conv2D(64, (3, 3), padding = 'same', input_shape = (14, 14, 1), activation='relu')(x2)
        x2 = MaxPooling2D(pool_size=(2, 2))(x2)
        x2 = Flatten()(x2)
        x2 = Dense(64, activation = 'relu')(x2)
        predictions2 = Dense(units = num_classes, activation = 'softmax')(x2)
        model_func2 = Model(inputs=inputs2, outputs=predictions2, name='model4')
        model_func2.compile(loss=keras.losses.categorical_crossentropy, optimizer=keras.optimizers.RMSprop(), metrics=['accuracy'])
        model_func2.summary()
        
        model_func2.fit(
            train_x, train_y,
            batch_size = batch_size,
            epochs=epochs,
            shuffle = True,
            validation_data=(test_x, test_y),
            callbacks=[MyCallback(model_func2)]
            )
        print("current directory: ", os.getcwd())
        save_dir = os.path.join(os.getcwd(), 'saved_models')
        model_name2 = 'keras_trained_model_with_model_4.h5'
        if not os.path.isdir(save_dir):
            os.makedirs(save_dir)
        model_path2 = os.path.join(save_dir, model_name2)
        model_func2.save(model_path2)
        print('Saved trained model at %s ' % model_path2)
        # load 2 images
        normal_img = load_an_image() # class: paper
        img_blacked = load_an_image()[0, :, :, :] 
        img_blacked[8:22, 8:22, :] = 0
        print("model_func2 prediction: normal, blacked")
        print("model_func2.predict(normal_img): ", model_func2.predict(normal_img))
        print("model_func2.predict(img_blacekd): ", model_func2.predict(img_blacked[np.newaxis, :]))
        model_func2.evaluate(test_x, test_y)
