resource "aws_security_group" "rdsSg" {
  name        = "RDS-SG"
  description = "Security group for RDS to traffic for EC2 instance"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    protocol    = "tcp"
    from_port   = 3306
    to_port     = 3306
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


module "db" {
  source     = "./terraform-modules/rds-database"
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
  vpc_security_group_ids = [aws_security_group.rdsSg.id]
  maintenance_window     = "Mon:00:00-Mon:03:00"
  backup_window          = "03:00-06:00"
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
  subnet_ids = [aws_subnet.s1.id, aws_subnet.s2.id]
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
