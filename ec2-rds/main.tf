module "vm-instance-one" {
  source        = "./terraform-modules/ec2-instance"
  vpc_id        = "xx"
  subnet_id     = "xx"
  keyname       = "xx"
  ami           = "xx"
  vmname        = "xx"
  instance_type = "xx"
  ports = {
    "443"  = ["0.0.0.0/0"]
    "22"   = ["0.0.0.0/0"]
    "80"   = ["0.0.0.0/0"]
    "8080" = ["0.0.0.0/0"]
  }
  additional_tags = {
    environment = "demo"
    Owner       = "htc"
  }
}

module "vm-instance-two" {
  source        = "./terraform-modules/ec2-instance"
  vpc_id        = "yy"
  subnet_id     = "yy"
  keyname       = "yy"
  ami           = "yy"
  vmname        = "yy"
  instance_type = "yy"
  ports = {
    "443"  = ["0.0.0.0/0"]
    "22"   = ["0.0.0.0/0"]
    "80"   = ["0.0.0.0/0"]
    "8080" = ["0.0.0.0/0"]
  }
  additional_tags = {
    environment = "demo"
    Owner       = "htc"
  }
}


module "db" {
  source  = "./terraform-modules/rds-database"
  identifier = "stagedb"
  # Engine status
  engine               = "mysql"
  engine_version       = "8.0.25"
  instance_class       = "db.t3.large"
  allocated_storage    = 5
  family               = "mysql8.0" # DB parameter group
  major_engine_version = "8.0"      # DB option group
  # credentials information
  name     = "stagedb"
  username = "user"
  password = "YourPwdShouldBeLongAndSecure!"
  port     = "3306"
  # Disble iam database authentication
  iam_database_authentication_enabled = false
  # security group
  vpc_security_group_ids = [aws_security_group.rds-sg.id]
  maintenance_window = "Mon:00:00-Mon:03:00"
  backup_window      = "03:00-06:00"
  # Enhanced Monitoring - see example for details on how to create the role
  # by yourself, in case you don't want to create it automatically
  monitoring_interval    = "30"
  monitoring_role_name   = "stagRDSMonitoringRole"
  create_monitoring_role = true
  # tags
  tags = {
    Owner       = "user"
    Environment = "prod"
  }
  # DB subnet group
  subnet_ids = [ var.subnet-i-id, var.subnet-2-id ]
  # Final snapshot
  skip_final_snapshot = true
  # Database Deletion Protection
  deletion_protection = false
  parameters = [
    {
      name  = "character_set_client"
      value = "utf8mb4"
    },
    {
      name  = "character_set_server"
      value = "utf8mb4"
    }
  ]

  options = [
    {
      option_name = "MARIADB_AUDIT_PLUGIN"

      option_settings = [
        {
          name  = "SERVER_AUDIT_EVENTS"
          value = "CONNECT"
        },
        {
          name  = "SERVER_AUDIT_FILE_ROTATIONS"
          value = "37"
        },
      ]
    },
  ]
}