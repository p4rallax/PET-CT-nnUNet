import os
import subprocess




def main():
    # Set environment variables
    os.environ['CUDA_VISIBLE_DEVICES'] = '1'
    base_nnunet_dir = "/"
    raw_data_base_dir = "/nnUNet_raw_data_base"
    preprocessed_dir = "/nnUNet_preprocessed"
    trained_models_dir = "/nnUNet_trained_models"

    task_name = 'Dataset703_FS_SCGH_Train' #change here for different task name
  
    os.environ['nnUNet_raw'] = raw_data_base_dir
    os.environ['nnUNet_preprocessed'] = preprocessed_dir
    os.environ['nnUNet_results'] = trained_models_dir
    
    # Set the working directory
    workdir = "/nnUNet/"
    os.chdir(workdir)
    
    # Add the directory to PYTHONPATH
    pythonpath = os.environ.get('PYTHONPATH', '')
    os.environ['PYTHONPATH'] = f"{workdir}:{pythonpath}"
    
    # Print PYTHONPATH for debugging purposes
    print(f"PYTHONPATH: {os.environ['PYTHONPATH']}")
    
  
    
    # Run inference
    inference_command = [
        # "python", "./nnunetv,2/inference/predict_from_raw_data.py",
        "nnUNetv2_predict",
        "-d", "Dataset703_FS_SCGH_Train",
        "-f", "0" ,"1", "2", "3", "4",
        "-tr", "nnUNetTrainer",
        "-c", "3d_fullres_resenc",
        "-p", "nnUNetPlans",
        "-i", "/nnUNet_raw_data_base/Dataset703_FS_SCGH_Train/imagesTs",
        "-o", "/nnUNet_trained_models/predictions/"
        
    ]
    subprocess.run(inference_command, check=True)



if __name__ == '__main__':
    main()