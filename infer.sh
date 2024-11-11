#!/bin/bash

# Input arguments
input_file1="$1"
input_file2="$2"
output_folder="$3"
renamed_file1="image_0000.nii.gz"  # Adjust to the expected name
renamed_file2="image_0001.nii.gz"  # Adjust to the expected name

# Copy and rename files to the expected locations
cp "/data/$input_file1" "/nnUNet_raw_data_base/Dataset703_FS_SCGH_Train/imagesTs/$renamed_file1"
cp "/data/$input_file2" "/nnUNet_raw_data_base/Dataset703_FS_SCGH_Train/imagesTs/$renamed_file2"

export nnUNet_raw="/nnUNet_raw_data_base"
export nnUNet_preprocessed="/nnUNet_preprocessed"
export nnUNet_results="/nnUNet_trained_models"

# Run nnUNet inference (adjust command as needed)
# python /infer.py -o $output_folder
nnUNetv2_predict -d Dataset703_FS_SCGH_Train -f 0 1 2 3 4 -tr nnUNetTrainer -c 3d_fullres_resenc -p nnUNetPlans -i /nnUNet_raw_data_base/Dataset703_FS_SCGH_Train/imagesTs -o $output_folder