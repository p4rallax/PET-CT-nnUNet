FROM nvcr.io/nvidia/pytorch:23.05-py3 

RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y ffmpeg libsm6 libxext6 libglib2.0-0 git ca-certificates && apt-get clean 

RUN apt-get install -y python3.10 curl && \
    curl -sS https://bootstrap.pypa.io/get-pip.py | python3.10

RUN curl -sSL https://install.python-poetry.org | python3.10 - --preview
RUN pip3 install --upgrade requests
RUN ln -fs /usr/bin/python3.10 /usr/bin/python

COPY requirements.txt /tmp/

RUN pip install -r /tmp/requirements.txt && pip install --upgrade google-cloud-storage

WORKDIR /

# Clone nnUNet repo and checkout specific version
RUN git clone https://github.com/MIC-DKFZ/nnUNet.git && \
    cd nnUNet && \
    git checkout tags/v2.3.1 -b version-2.3.1-branch

# Replace the plans_handler.py file
COPY plans_handler_modification.py /nnUNet/nnunetv2/utilities/plans_handling/plans_handler.py

COPY infer.py /infer.py
# Install nnUNet with the modified files

RUN cd nnUNet && \
    pip install -e .

# Create the necessary directories for nnUNet
ENV nnUNet_raw=/nnUNet_raw_data_base \
    nnUNet_preprocessed=/nnUNet_preprocessed \
    nnUNet_results=/nnUNet_trained_models

RUN mkdir -p "$nnUNet_raw" "$nnUNet_preprocessed" "$nnUNet_results"



# Download the pretrained model file
RUN cd /
RUN wget -O /tmp/nnUNet_pretrained_model.zip "https://url.au.m.mimecastprotect.com/s/3Z2TCGv0q2F722vjIKfwCBhEef?domain=dropbox.com"

# Extract the model into a temporary directory
RUN unzip /tmp/nnUNet_pretrained_model.zip -d /tmp/nnUNet_pretrained_model

# Install pretrained model for nnUNet
RUN nnUNetv2_install_pretrained_model_from_zip /tmp/nnUNet_pretrained_model/nnunet_resenc_output


# Set up folders and prepare for inference
RUN mkdir -p $nnUNet_raw/Dataset703_FS_SCGH_Train/imagesTs

# Expose a folder for mounting external data (e.g., for inference data)
VOLUME /data

# Set the default command
CMD ["bash"]