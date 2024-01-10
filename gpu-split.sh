#!/bin/bash
/usr/lib/nvidia/sriov-manage -e all
set -e

# Function to get PCIe ID of a GPU
get_pci_id() {
    local gpu_index=$1
    nvidia-smi -q -i "$gpu_index" | grep 'Bus Id' | awk '{print substr(tolower($4), 5)}'
}

# Function to create vGPU
create_vgpu() {
    local vf_path=$1
    local nvprofile=$2
    local mdev_supported_types_path="/sys/class/mdev_bus/$vf_path/mdev_supported_types"

    if [ -d "$mdev_supported_types_path/$nvprofile" ]; then
        if [ "$(cat "$mdev_supported_types_path/$nvprofile/available_instances")" -gt 0 ]; then
            local uuid=$(uuidgen)
            if echo "$uuid" > "$mdev_supported_types_path/$nvprofile/create"; then
                echo "vGPU profile $nvprofile successfully created with UUID $uuid on $vf_path"
            else
                echo "Failed to create vGPU profile $nvprofile on $vf_path. Please check system logs for more details."
            fi
        else
            echo "No available instances for vGPU profile $nvprofile on $vf_path."
        fi
    else
        echo "Profile $nvprofile not supported on $vf_path"
    fi
}

# Main
# Get the number of NVIDIA GPUs
num_gpus=$(nvidia-smi -L | wc -l)

# Iterate through each GPU and handle virtual functions
for gpu_index in $(seq 0 $((num_gpus - 1))); do
    nvidia_device=$(get_pci_id "$gpu_index")
    if [ -z "$nvidia_device" ]; then
        echo "Failed to find PCIe ID for GPU $gpu_index"
        continue
    fi
    echo "Processing NVIDIA GPU $gpu_index with PCIe ID: $nvidia_device"

    # Get list of all virtual functions for the GPU
    vf_paths=($(ls -l /sys/bus/pci/devices/$nvidia_device/ | grep virtfn | awk '{print $11}' | awk -F '/' '{print $2}'))

    if [ ${#vf_paths[@]} -eq 0 ]; then
        echo "No virtual functions found for GPU $gpu_index"
        continue
    fi

    # Display available vGPU profiles for the first virtual function
    first_vf_path=${vf_paths[0]}
    echo "Supported vGPU profiles for $first_vf_path:"
    ls "/sys/class/mdev_bus/$first_vf_path/mdev_supported_types"

    echo "Please select a profile for GPU $gpu_index (e.g., nvidia-829): "
    read nvprofile

    # Iterate through each virtual function and create a vGPU
    for vf_path in "${vf_paths[@]}"; do
        create_vgpu "$vf_path" "$nvprofile"
    done
done
