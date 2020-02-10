variable "write" {
  type        = bool
  default     = false
  description = "Write secret if 'true', read it if 'false'"
}

variable "path" {
    type = string
    default = ""
    description = "The path of the secret. If not specified, it will be constructed from the rest of parameters. To be used when override is required"
}

variable "mount_path" {
  type = string
  default = "secret"
  description = "The base path were the KeyValueV2 secret engine is mounted"
}

variable "value" {
  type        = string
  default     = ""
  description = "The value of the secret, only relevant when action is 'write'"
}

variable "scope" {
  type        = string
  default     = "org"
  description = "The user scope that has read access to this secret. One of user/team/org"
}

variable "owner" {
  type        = string
  default     = ""
  description = "Determines who has access to the secret. Should be a user name or a team name, depending on the value passed to 'scope'"
}


variable "project" {
  type        = string
  default     = ""
  description = "Project name: eng/saas"
}

variable "environment" {
  type        = string
  default     = ""
  description = "Environment: pro/stg/dev"
}

variable "workload" {
  type        = string
  default     = ""
  description = "Solution name: system/zync/backend/keycloak/apicast/apicurio"
}

variable "type" {
  type        = string
  default     = ""
  description = "Abreviated resource type: i, sg, vpc, rt, s3, rds, es, ec ..."
}

variable "enabled" {
  type        = bool
  default     = true
  description = "Set to false to prevent the module from creating any resources"
}

variable "delimiter" {
  type        = string
  default     = "-"
  description = "Delimiter to be used between `namespace`, `environment`, `stage`, `name` and `attributes`"
}

variable "attributes" {
  type        = list(string)
  default     = []
  description = "Additional attributes (e.g. `1`)"
}

variable "context" {
  type = object({
    environment = string
    project     = string
    workload    = string
    type        = string

    enabled             = bool
    delimiter           = string
    tf_config           = string
    attributes          = list(string)
    label_order         = list(string)
    tags                = map(string)
    additional_tag_map  = map(string)
    regex_replace_chars = string
  })
  default = {
    environment = ""
    project     = ""
    workload    = ""
    type        = ""

    enabled             = true
    delimiter           = ""
    tf_config           = ""
    attributes          = []
    label_order         = []
    tags                = {}
    additional_tag_map  = {}
    regex_replace_chars = ""
  }
  description = "Default context to use for passing state between label invocations"
}

variable "label_order" {
  type        = list(string)
  default     = []
  description = "The naming order of the id output and Name tag"
}

variable "regex_replace_chars" {
  type        = string
  default     = "/[^a-zA-Z0-9-]/"
  description = "Regex to replace chars with empty string in `project`, `environment` and `workload`. By default only hyphens, letters and digits are allowed, all other chars are removed"
}