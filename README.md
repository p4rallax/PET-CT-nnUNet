# PET-CT-nnUNet

## Steps to run inference

1. Clone this repository using:
     ```
     https://github.com/p4rallax/PET-CT-nnUNet.git
     ```
     
2. Build docker image using: (nnunet_inference is the container name that will get created , can be replace with name of your choice).
     ```
     cd PET-CT-nnUNet/
   docker build -t nnunet_inference .
      ```
3. Run the docker container using: (Make sure container name is same as used in previous step)
     ```
   docker run  --runtime=nvidia -it  --shm-size=4g --gpus all --ipc=host -v /path/to/mount:/target_dir nnunet_inference
     ```
4. Attach Visual Studio Code to the container.
5. Copy inference images into /nnUNet_raw_data_base/Dataset703_FS_SCGH_Train/imagesTs. Each image should have 2 modalities , with _0000 and _0001 suffixes. It should look something like this:
   ![image](https://github.com/user-attachments/assets/1f14163a-6138-42f1-83d1-8b1221d72fc1)
7. Run ```python infer.py```


   
   
