# Declare project variables here

variable "environment" {
    description = "Environment type for a specif scenario, dev, stage or prod"
    type = string
    default = "test"
} 

variable "PROJECT" {
    description = "Proj name"
    type = string
    #default = "test"
} 