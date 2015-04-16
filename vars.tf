variable "amis" {
  default = {
    linux = "ami-8e682ce6" /* Amazon Linux */
    windows = "ami-aa7830c2" /* Windows Server 2012 r2 */
    linux_hvm = "ami-1ecae776"
  }
}
