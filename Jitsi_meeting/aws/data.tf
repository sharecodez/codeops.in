  locals {
  subdomain = length(var.subdomain) == 0 ? random_id.server_id.hex : var.subdomain
}  
# Fetch AZs in the current region
data "aws_availability_zones" "available" {
}

data "template_file" "stream_record" {
  template = file("./templates/jibri/stream_record.tpl")
  vars = {recorded_stream_dir = var.recorded_stream_dir
  }
}
data "template_file" "facebook_stream" {
  template = file("./templates/jibri/facebook_stream.tpl")
  vars = {
    facebook_stream_key = var.facebook_stream_key
  }
}
data "template_file" "periscope_stream" {
  template = file("./templates/jibri/periscope_stream.tpl")
  vars = {
    periscope_server_url = var.periscope_server_url
    periscope_stream_key = var.periscope_stream_key
  }
}
data "template_file" "twitch_stream" {
  template = file("./templates/jibri/twitch_stream.tpl")
  vars = {
    twitch_ingest_endpoint = var.twitch_ingest_endpoint
    twitch_stream_key      = var.twitch_stream_key
  }
}
data "template_file" "youtube_stream" {
  template = file("./templates/jibri/youtube_stream.tpl")
  vars = {
    youtube_stream_key = var.youtube_stream_key
  }
}
data "template_file" "generic_streams" {
  template = file("./templates/jibri/generic_stream.tpl")
  count    = length(var.rtmp_stream_urls)
  vars = {
    stream_url = var.rtmp_stream_urls[count.index]
  }
}
 
 data "template_file" "install_jibri" {
  template = "${file("install_jibri.tpl")}"
  vars = {
    jibri_auth_password     = random_id.jibriauthpass.hex
    jibri_recorder_password = random_id.jibrirecorderpass.hex
    recorded_stream_dir     = var.recorded_stream_dir
    record_stream           = var.record_all_streaming ? data.template_file.stream_record.rendered : "    record off;"
    facebook_stream         = (length(var.facebook_stream_key) != 0) ? data.template_file.facebook_stream.rendered : "# Facebook stream was not configured"
    periscope_stream        = (length(var.periscope_stream_key) != 0) ? data.template_file.periscope_stream.rendered : "# Periscope stream was not configured"
    twitch_stream           = (length(var.twitch_stream_key) != 0) ? data.template_file.twitch_stream.rendered : "# Twitch stream was not configured"
    youtube_stream          = (length(var.youtube_stream_key) != 0) ? data.template_file.youtube_stream.rendered : "# YouTube stream was not configured"
    generic_streams         = (length(var.rtmp_stream_urls) != 0) ? join("\n    ", data.template_file.generic_streams.*.rendered) : "# No generic stream URLs were configured"
  }
}

 data "template_file" "install_script" {
  template = "${file("install_jitsi.tpl")}"
  vars = {
    email_address             = "${var.email_address}"
    admin_username            = "${var.admin_username}"
    admin_password            = "${var.admin_password}"
    domain_name               = "${local.subdomain}.${var.parent_subdomain}"
    jibri_installation_script = var.enable_recording_streaming ? data.template_file.install_jibri.rendered : "echo \"Jibri installation is disabled\" >> /debug.txt"
    reboot_script             = var.enable_recording_streaming ? "echo \"Rebooting...\" >> /debug.txt\nreboot" : "echo \".\" >> /debug.txt"
  }
}

data "aws_route53_zone" "parent_subdomain" {
  name = var.parent_subdomain
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }
  #/ubuntu-disco-19.04-amd64-server-
  #/ubuntu-bionic-18.04-amd64-server-
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}
