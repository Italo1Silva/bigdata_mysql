resource "ibm_database" "mysqldb" {
  resource_group_id = ibm_resource_group.resource_group.id
  name                                 = "mysql-big-data"
  service                              = "databases-for-mysql"
  plan                                 = "standard"
  location                             = "eu-gb"
  tags                                 = []
  adminpassword = var.mysql_password
  members_memory_allocation_mb = 122880
}

output "mysql_crn" {
  value = ibm_database.mysqldb.id 
}

output "mysql_host" {
  value = ibm_database.mysqldb.connectionstrings[0].hosts[0].hostname
}

output "mysql_port" {
  value = ibm_database.mysqldb.connectionstrings[0].hosts[0].port
}