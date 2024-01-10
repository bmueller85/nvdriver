Description
This Bash script is designed for use with Nvidia NVAIE driver environments to enable Single Root Input/Output Virtualization (SR-IOV) and facilitate the splitting of NVIDIA GPUs into virtual GPU (vGPU) instances. It automates the process of creating vGPU profiles, making it easier to utilize GPUs for compute profiles in systems like Ubuntu 22.04.
Features
    Enabling SR-IOV: Automatically enables SR-IOV on all NVIDIA GPUs in the system.
    Dynamic GPU Handling: Identifies and processes each NVIDIA GPU based on its PCIe ID.
    vGPU Creation: Streamlines the creation of vGPU instances with user-selected profiles.
Prerequisites
    Ubuntu 22.04 or a compatible Linux distribution.
    NVIDIA NVAIE driver installed on your system.
Installation and Usage
    Clone the Repository:
    
git clone https://github.com/bmueller85/nvdriver.git
cd nvdriver/

Set Script Permissions:
Make the script executable by running:
sudo chmod +x gpu-split.sh
Run the Script:
Execute the script as a superuser:

    sudo ./gpu-split.sh
    
Follow the on-screen prompts to select vGPU profiles for each GPU.
Additional Information
    The script starts by enabling SR-IOV on all detected NVIDIA GPUs.
    It retrieves the PCIe ID of each GPU and lists all available vGPU profiles for the first virtual function.
    Users are prompted to select a vGPU profile for each GPU.
    The script attempts to create a vGPU with the chosen profile and provides feedback on the success or failure of this process.
Troubleshooting
    Ensure that the Nvidia NVAIE driver is correctly installed and compatible with your system.
    Run the script with superuser privileges to ensure it has the necessary permissions.
    If a GPU or vGPU profile is not detected, check your hardware configuration and driver installation.
Contributing
Feedback and contributions to this script are welcome. Please feel free to submit issues or pull requests through GitHub.
