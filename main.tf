provider "aws" {
  region  = "${var.region}"
  profile = "${var.profile}"
}

data "aws_vpc" "main" {
  default = true
}

resource "aws_key_pair" "main" {
  key_name_prefix = "sample-key"
  public_key      = "${file("./keys/key.rsa.pub")}"
}

resource "aws_security_group" "allow-registry-ingress" {
  name = "main"

  description = "Allows ingress SSH traffic and egress to any address."
  vpc_id      = "${data.aws_vpc.main.id}"

  ingress {
    from_port   = 5000
    to_port     = 5000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name = "allow_registry-ingress"
  }
}

resource "aws_security_group" "allow-ssh-and-egress" {
  name = "main"

  description = "Allows ingress SSH traffic and egress to any address."
  vpc_id      = "${data.aws_vpc.main.id}"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name = "allow_ssh-and-egress"
  }
}

# Template the instance initialization script with information
# regarding the region and bucket that the user configured.
data "template_cloudinit_config" "init" {
  gzip          = true
  base64_encode = true

  vars {
    bucket = "${var.bucket}"
    region = "${var.region}"
  }

  part {
    content_type = "text/x-shellscript"
    content      = "${file("./instance-init.sh")}"
  }
}

# Create an instance in the default VPC with a specified
# SSH key so we can properly SSH into it to verify whether
# everything is worked as intended.
resource "aws_instance" "main" {
  instance_type        = "t2.micro"
  ami                  = "${data.aws_ami.ubuntu.id}"
  key_name             = "${aws_key_pair.main.id}"
  iam_instance_profile = "${aws_iam_instance_profile.main.name}"
  user_data            = "${data.template_cloudinit_config.init.rendered}"

  vpc_security_group_ids = [
    "${aws_security_group.allow-ssh-and-egress.id}",
    "${aws_security_group.allow-registry-ingress.id}",
  ]
}

output "public-ip" {
  description = "Public IP of the instance created"
  value       = "${aws_instance.main.public_ip}"
}
