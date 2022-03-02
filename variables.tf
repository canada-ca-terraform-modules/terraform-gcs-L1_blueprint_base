variable "env" {
  type = string
}

variable "group" {
  type = string
}

variable "project" {
  type = string
}

variable "default_region" {
  type    = string
  default = "northamerica-northeast1"
}

variable "project_name" {
  type = string
}

variable "deployOptionalFeatures" {
  type = any
}

variable "dnsConfig" {
  type = any
}

variable "network" {
  type = any
}

variable "VMs" {
  type = any
}

variable "firewall" {
  type = any
}