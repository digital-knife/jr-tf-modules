variable "sink_name" {
  type        = string
  description = "The name of the OAM sink"
}

variable "sink_policy" {
  type        = string
  description = "The JSON policy for the sink"
}

resource "aws_oam_sink" "this" {
  name = var.sink_name
}

resource "aws_oam_sink_policy" "this" {
  sink_identifier = aws_oam_sink.this.id
  policy          = var.sink_policy
}
