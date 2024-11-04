# PET-CT-nnUNet

## Steps to run inference

1. Build docker image using
     ```
   docker build -t <name for your docker image> .
      ```
3. Run the docker container using
     ```
   docker run  --runtime=nvidia -it  --shm-size=4g --gpus all --ipc=host -v /path/to/mount:/target_dir <name of docker image>
     ```
4. Attach Visual Studio Code to the container.
5. Clone into nnUNetv2 2.3.1, using :
     ```
         git clone https://github.com/MIC-DKFZ/nnUNet.git
         cd nnUNet
         git checkout tags/v2.3.1 -b version-2.3.1-branch
     ```
6. Navigate to plans_handler.py in nnUNet in the Git repo downloaded in the last step (nnUNet/nnunetv2/utilities/plans_handling/plans_handler.py).
7. Replace the ```arch_dict``` definition (as seen [here](https://github.com/MIC-DKFZ/nnUNet/blob/master/nnunetv2/utilities/plans_handling/plans_handler.py#L57)), with the following code:
     ```
     if unet_class_name == "PlainConvUNet":
       
       arch_dict = {
        'network_class_name': network_class_name,
        'arch_kwargs': {
            "n_stages": n_stages,
            "features_per_stage": [min(self.configuration["UNet_base_num_features"] * 2 ** i,
                                    self.configuration["unet_max_num_features"])
                                for i in range(n_stages)],
            "conv_op": conv_op.__module__ + '.' + conv_op.__name__,
            "kernel_sizes": deepcopy(self.configuration["conv_kernel_sizes"]),
            "strides": deepcopy(self.configuration["pool_op_kernel_sizes"]),
            "n_conv_per_stage": deepcopy(self.configuration["n_conv_per_stage_encoder"]),
            "n_conv_per_stage_decoder": deepcopy(self.configuration["n_conv_per_stage_decoder"]),
            "conv_bias": True,
            "norm_op": instnorm.__module__ + '.' + instnorm.__name__,
            "norm_op_kwargs": {
                "eps": 1e-05,
                "affine": True
            },
            "dropout_op": None,
            "dropout_op_kwargs": None,
            "nonlin": "torch.nn.LeakyReLU",
            "nonlin_kwargs": {
                "inplace": True
            }
        },
        # these need to be imported with locate in order to use them:
        # `conv_op = pydoc.locate(architecture_kwargs['conv_op'])`
        "_kw_requires_import": [
            "conv_op",
            "norm_op",
            "dropout_op",
            "nonlin"
        ]
    }
    elif unet_class_name == 'ResidualEncoderUNet':
       
       arch_dict = {
          'network_class_name': network_class_name,
          'arch_kwargs': {
              "n_stages": n_stages,
              "features_per_stage": [min(self.configuration["UNet_base_num_features"] * 2 ** i,
                                      self.configuration["unet_max_num_features"])
                                  for i in range(n_stages)],
              "conv_op": conv_op.__module__ + '.' + conv_op.__name__,
              "kernel_sizes": deepcopy(self.configuration["conv_kernel_sizes"]),
              "strides": deepcopy(self.configuration["pool_op_kernel_sizes"]),
              "n_blocks_per_stage": deepcopy(self.configuration["n_conv_per_stage_encoder"]),
              "n_conv_per_stage_decoder": deepcopy(self.configuration["n_conv_per_stage_decoder"]),
              "conv_bias": True,
              "norm_op": instnorm.__module__ + '.' + instnorm.__name__,
              "norm_op_kwargs": {
                  "eps": 1e-05,
                  "affine": True
              },
              "dropout_op": None,
              "dropout_op_kwargs": None,
              "nonlin": "torch.nn.LeakyReLU",
              "nonlin_kwargs": {
                  "inplace": True
              }
          },
          # these need to be imported with locate in order to use them:
          # `conv_op = pydoc.locate(architecture_kwargs['conv_op'])`
          "_kw_requires_import": [
              "conv_op",
              "norm_op",
              "dropout_op",
              "nonlin"
          ]
      }
     ```
8. Navigate back to the root nnunet repository folder. If the path of the cloned repo is the same as in above steps, it can be done using :
     ```
     cd /
     cd nnunet
     ```
9. Install nnunetv2 from the modified repo using
    ```
    pip install -e .
    ```
10. Create three folders for nnUNet folder structure and export the environment variables:
    ```
    export nnUNet_raw=/path/to/nnUNet_raw_data_base
    export nnUNet_preprocessed=/path/to/nnUNet_preprocessed
    export nnUNet_results=/path/to/nnUNet_trained_models
    ```
12. Install pretrained models from the model file:
    ```
    nnUNetv2_install_pretrained_model_from_zip <model file path>
    ```
11. Inside the raw data base folder,  create a folder for our dataset with the name Dataset703_FS_SCGH_Train  (name should match exactly)
12. Create a folder named imagesTs inside the Dataset folder we created in the previous step.
13. Copy images for inference inside this folder. Note that each case should have 2 modalities ie 2 image files per case, one for PET (_0000) and one for CT (_0001). The names for each case should be something like (case_id)_0000.nii.gz and (case_id)_0001.nii.gz
14. Once the images for inference are ready , we can run inference using the following command. Make sure to have environment variables set as per step 10.
    ```
    nnUNetv2_predict -d Dataset703_FS_SCGH_Train -i INPUT_FOLDER -o OUTPUT_FOLDER -f  0 1 2 3 4 -tr nnUNetTrainer -c 3d_fullres_resenc -p nnUNetPlans
    ```
   
