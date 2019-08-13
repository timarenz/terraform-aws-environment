variable "environment_name" {
  type = string
}

variable "owner_name" {
  type = string
}

variable "ttl" {
  type    = number
  default = 48
}

variable "cidr_block" {
  type    = string
  default = "192.168.0.0/16"
}

variable "tags" {
  type    = map
  default = null
}

variable "public_subnets" {
  # type = list
  default = [
    {
      name   = "public-subnet-1"
      prefix = "192.168.30.0/24"
      tags   = null
    },
    {
      name   = "public-subnet-2"
      prefix = "192.168.31.0/24"
      tags   = null
    },
    {
      name   = "public-subnet-3"
      prefix = "192.168.32.0/24"
      tags   = null
    },
  ]
}

variable "private_subnets" {
  # type = list
  default = [
    {
      name   = "private-subnet-1"
      prefix = "192.168.40.0/24"
      tags   = null
    },
    {
      name   = "private-subnet-2"
      prefix = "192.168.41.0/24"
      tags   = null
    },
    {
      name   = "private-subnet-3"
      prefix = "192.168.42.0/24"
      tags   = null
    },
  ]
}

variable "nat_gateway" {
  type    = bool
  default = true
}
