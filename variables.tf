# Declare project variables here

variable "environment" {
    description = "Environment type for a specif scenario, dev, stage or prod"
    type = string
    default = "development"
} 

variable "workspace_name" {
    description = "Workspace name in TFC"
    type = string
    default = "GitHub-Actions-Environments"
} 