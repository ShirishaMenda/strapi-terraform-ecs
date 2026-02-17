resource "aws_db_instance" "strapi_db" {
  identifier = "strapi-db"
  engine     = "postgres"
  instance_class = "db.t3.micro"

  allocated_storage = 20
  db_name  = "strapidb"
  username = "strapiuser"
  password = "StrapiPass123"

  skip_final_snapshot = true
}
