import os
import random
from PIL import Image, ImageEnhance, ImageFilter
import numpy as np
import shutil

def adjust_brightness(image, factor):
    enhancer = ImageEnhance.Brightness(image)
    return enhancer.enhance(factor)

def adjust_contrast(image, factor):
    enhancer = ImageEnhance.Contrast(image)
    return enhancer.enhance(factor)

def adjust_saturation(image, factor):
    enhancer = ImageEnhance.Color(image)
    return enhancer.enhance(factor)

def adjust_hue(image, factor):
    image = np.array(image.convert('HSV'))
    image[:, :, 0] = (image[:, :, 0].astype(int) + factor) % 256
    return Image.fromarray(image, 'HSV').convert('RGB')

def add_noise(image):
    image = np.array(image)
    noise = np.random.normal(0, 25, image.shape).astype(np.uint8)
    noisy_image = Image.fromarray(np.clip(image + noise, 0, 255).astype(np.uint8))
    return noisy_image

def sharpen_image(image):
    return image.filter(ImageFilter.SHARPEN)

def augment_image(image_path, label_path, output_dir):
    image = Image.open(image_path)
    base_name = os.path.splitext(os.path.basename(image_path))[0]
    label_name = os.path.splitext(os.path.basename(label_path))[0]

    brightness_factors = {
        "very_dark": 0.2,
        "dark": 0.5,
        "bright": 1.5,
        "very_bright": 2.0,
        "extremely_bright": 2.5
    }

    augmentations = {
        "contrast": lambda img: adjust_contrast(img, random.uniform(0.5, 1.5)),
        "saturation": lambda img: adjust_saturation(img, random.uniform(0.5, 1.5)),
        "hue": lambda img: adjust_hue(img, random.randint(-30, 30)),
        "noise": add_noise,
        "sharp": sharpen_image
    }

    for aug_name, aug_function in augmentations.items():
        augmented_image = aug_function(image)
        new_image_name = f"{base_name}_{aug_name}.jpg"
        new_image_path = os.path.join(output_dir, new_image_name)
        augmented_image.save(new_image_path)

        new_label_name = f"{label_name}_{aug_name}.txt"
        new_label_path = os.path.join(output_dir, new_label_name)
        shutil.copy(label_path, new_label_path)

    for bright_name, bright_factor in brightness_factors.items():
        bright_image = adjust_brightness(image, bright_factor)
        new_image_name = f"{base_name}_{bright_name}.jpg"
        new_image_path = os.path.join(output_dir, new_image_name)
        bright_image.save(new_image_path)

        new_label_name = f"{label_name}_{bright_name}.txt"
        new_label_path = os.path.join(output_dir, new_label_name)
        shutil.copy(label_path, new_label_path)

def augment_dataset(input_dir, output_dir):
    if not os.path.exists(output_dir):
        os.makedirs(output_dir)

    for file_name in os.listdir(input_dir):
        if file_name.endswith('.jpg'):
            image_path = os.path.join(input_dir, file_name)
            label_path = os.path.join(input_dir, os.path.splitext(file_name)[0] + '.txt')
            if os.path.exists(label_path):
                augment_image(image_path, label_path, output_dir)


# windows directory path
# ------------------------------------------------------------------------------
input_directory = r''  # TODO
output_directory = r''  # TODO
# ------------------------------------------------------------------------------
# if u want to run the script in the Linux, u should comment out these two lines above, and use the two lines below
# input_directory = 'path_to_input_directory'
# output_directory = 'path_to_output_directory'


augment_dataset(input_directory, output_directory)

