# PET-CT-nnUNet

## Steps to run inference

1. Clone this repository and build docker image using: (nnunet_inference is the container name that will get created , can be replace with name of your choice) using:
     ```
     git clone https://github.com/p4rallax/PET-CT-nnUNet.git
     cd PET-CT-nnUNet/
     docker build -t nnunet_inference .
     ```

2. Run the docker container using: (Make sure container name is same as used in previous step). Note that file1 is PET image and file2 is CT.
     ```
   docker run --rm  --runtime=nvidia -it  --shm-size=4g --gpus all --ipc=host  -v /path/to/image/folder:/data/input  -v /path/to/output/folder:/data/output nnunet_inference  file1.nii.gz file2.nii.gz /data/output
     ```



   
   
