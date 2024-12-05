resource "aws_instance" "db2_server" {
  ami                  = "ami-0a45c8b16782f3406"
  instance_type        = var.instance_type
  subnet_id            = var.subnet_id
  iam_instance_profile = var.iam_instance_profile
  key_name             = var.key_name

  root_block_device {
    volume_size = var.root_volume_size
    volume_type = "gp3"
    encrypted   = true
  }

  dynamic "ebs_block_device" {
    for_each = var.ebs_volume_config
    content {
      device_name = "/dev/sd${lookup({ 0 = "f", 1 = "g", 2 = "h", 3 = "i", 4 = "j", 5 = "k", 6 = "l" }, index(var.ebs_volume_config, ebs_block_device.value))}"
      volume_size = ebs_block_device.value.size
      volume_type = ebs_block_device.value.type
      iops        = ebs_block_device.value.iops
      encrypted   = true
    }
  }

  user_data = templatefile("${path.module}/user_data.sh.tpl", {
    ebs_volume_config = var.ebs_volume_config
  })

  tags = var.tags
}
