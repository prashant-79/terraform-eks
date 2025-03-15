variable "environment" {
  default = "dev"
}

variable "project" {
    default = "eks"
  
}

variable "SOURCE_GMAIL_ID"{
  description = "Source GMAIl Id"
  default = "devops4solutions@gmail.com"
}
variable "SOURCE_AUTH_PASSWORD"{
  description = "Source Auth Password"
  default ="eumqeqwngvyyrbqg"
}
variable "DESTINATION_GMAIL_ID"{
  description = ""
  default ="khandelwal12nidhi@gmail.com"
}

variable "domain_name" {
  default = "devops4solutions.com"
}

variable "allow_ip" {
  default = ["0.0.0.0/0"]
}