#!/bin/bash
sudo dnf install -y https://s3.amazonaws.com/ec2-downloads-windows/SSMAgent/latest/linux_amd64/amazon-ssm-agent.rpm

# Format and mount EBS volumes
%{ for idx, volume in ebs_volume_config }
device_name="/dev/nvme${idx}n1"
mount_point="${volume.mount_point}"
sudo mkfs -t xfs $device_name
sudo mkdir -p $mount_point
sudo mount $device_name $mount_point
echo "$device_name $mount_point xfs defaults,nofail 0 2" | sudo tee -a /etc/fstab
%{ endfor }