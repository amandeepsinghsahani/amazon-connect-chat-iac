resource "aws_connect_instance" "this" {
  instance_alias                    = "${var.instance_alias}-${var.environment}"
  identity_management_type          = "CONNECT_MANAGED"
  inbound_calls_enabled             = true
  outbound_calls_enabled            = true
  contact_flow_logs_enabled         = true
  contact_lens_enabled              = false
}

resource "aws_connect_hours_of_operation" "chat_24x7" {
  instance_id = aws_connect_instance.this.id
  name        = "24x7-Chat-Support"
  description = "24/7 Chat Hours for Optum Support"
  time_zone   = "UTC"

  config {
    day = "MONDAY"
    start_time {
      hours   = 0
      minutes = 0
    }
    end_time {
      hours   = 23
      minutes = 59
    }
  }

  config {
    day = "TUESDAY"
    start_time {
      hours   = 0
      minutes = 0
    }
    end_time {
      hours   = 23
      minutes = 59
    }
  }

  config {
    day = "WEDNESDAY"
    start_time {
      hours   = 0
      minutes = 0
    }
    end_time {
      hours   = 23
      minutes = 59
    }
  }

  config {
    day = "THURSDAY"
    start_time {
      hours   = 0
      minutes = 0
    }
    end_time {
      hours   = 23
      minutes = 59
    }
  }

  config {
    day = "FRIDAY"
    start_time {
      hours   = 0
      minutes = 0
    }
    end_time {
      hours   = 23
      minutes = 59
    }
  }

  config {
    day = "SATURDAY"
    start_time {
      hours   = 0
      minutes = 0
    }
    end_time {
      hours   = 23
      minutes = 59
    }
  }

  config {
    day = "SUNDAY"
    start_time {
      hours   = 0
      minutes = 0
    }
    end_time {
      hours   = 23
      minutes = 59
    }
  }
}

resource "aws_connect_queue" "chat_queue" {
  instance_id           = aws_connect_instance.this.id
  name                  = "Chat-Support-Queue"
  description           = "Optum Chat Support Queue"
  hours_of_operation_id = aws_connect_hours_of_operation.chat_24x7.hours_of_operation_id
}

# Temporarily commented due to timing issue
# resource "aws_connect_routing_profile" "chat_profile" {
#   instance_id = aws_connect_instance.this.id
#   name        = "Chat-Agent-Profile"
#   description = "Routing profile for chat agents"

#   default_outbound_queue_id = aws_connect_queue.chat_queue.id

#   media_concurrencies {
#     channel     = "CHAT"
#     concurrency = 5
#   }

#   depends_on = [aws_connect_queue.chat_queue]
# }