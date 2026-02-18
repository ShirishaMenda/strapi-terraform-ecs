resource "aws_db_instance" "strapi_db" {
  identifier              = "strapi-db"
  engine                  = "postgres"
  engine_version          = "15"
  instance_class          = "db.t3.micro"
  allocated_storage       = 20
  storage_type            = "gp2"

  username                = "strapiadmin"
  password                = "Strapi_12345"
  db_name                 = "strapidb"

  db_subnet_group_name    = aws_db_subnet_group.rds_subnet_group.name
  vpc_security_group_ids  = [aws_security_group.rds_sg.id]

  publicly_accessible     = false
  multi_az                = false
  skip_final_snapshot     = true
  deletion_protection     = false

  backup_retention_period = 7
}
