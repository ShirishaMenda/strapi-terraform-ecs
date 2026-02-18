data "aws_ssm_parameter" "ecs_ami" {
  name = "/aws/service/ecs/optimized-ami/amazon-linux-2/recommended/image_id"
}

resource "aws_instance" "ecs_instance" {
  ami           = data.aws_ssm_parameter.ecs_ami.value
  instance_type = "t3.micro"

  iam_instance_profile = aws_iam_instance_profile.ec2_profile.name
  subnet_id            = data.aws_subnets.default.ids[0]
  vpc_security_group_ids = [aws_security_group.strapi_sg.id]

  user_data = <<EOF
#!/bin/bash
echo ECS_CLUSTER=strapi-cluster >> /etc/ecs/ecs.config
EOF

  tags = {
    Name = "strapi-single-ec2"
  }

  depends_on = [
    aws_iam_instance_profile.ec2_profile
  ]
}
