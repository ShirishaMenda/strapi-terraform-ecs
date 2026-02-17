resource "aws_instance" "ecs_instance" {
  ami           = "ami-0b6c6ebed2801a5cb"
  instance_type = "t3.micro"

  iam_instance_profile = aws_iam_instance_profile.ec2_profile.name

  user_data = <<EOF
#!/bin/bash
echo ECS_CLUSTER=${aws_ecs_cluster.strapi_cluster.name} >> /etc/ecs/ecs.config
EOF

  tags = {
    Name = "strapi-single-ec2"
  }

  depends_on = [
    aws_iam_instance_profile.ec2_profile
  ]
}
