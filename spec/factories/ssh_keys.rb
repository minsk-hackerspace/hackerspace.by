class SSHKeyFactory
  SSH_KEY_PART = "AAAAB3NzaC1yc2EAAAADAQABAAABgQDLmHlIJyd60EZBzLrxMNSwx6pUVKXe9Zrh9YANZ5Ez9TIFz+qwjAXCF+e/eQzNT/4NbgkossvusnqDtVje6ylq0HLYIQSdEuS9LeScny3EVuPpamNdiBbSJNArijvJxYJKNheBhir4PwYQhqylatZ/EwEXokXd38Nz+DcHY3OTpQhbRW6LxJ1OBsjYGiKf8WaCLJCDnYev/6bOPfWJTQo/9HiiY7LxpmYh+mflT8WPuRXxujgcTZjPfwlO2NeeLvOT13QeLGvwmgb+6zlHADWu6+j2xUExKijCMWMTJOWeMKTrBAYb6Gi82WU2ezrWRqXVHnkvBTkXj6XFj6pLkRZbwW8TCYUwK4F3FmlSW8oZJUWfZWOFuboEcxAg2kuyS/FnT5OBljkecprE4ldU/Wbgs2UytSrlvQqO2Mu/1ucH7FHhVR9/77ssp+kPNGo8p2ISkMZtDhlgXoKVmrsoY/vZaUHIGwdtLmJ8g6pS8erXeUEBEFTWLBo4jq8kIeZS04k="

  SSH_KEYS = {
    valid1: "ssh-rsa #{SSH_KEY_PART} test@example.com",
    valid2: "ssh-rsa #{SSH_KEY_PART}",
    invalid_type: "ssh-rsssa #{SSH_KEY_PART} test@example.com",
    invalid_format: "ssh-rsa test@example.com",
    with_options: "agent-forwarding,cert-authority ssh-rsa #{SSH_KEY_PART} test@example.com"
  }

  def self.create(type)
    key = SSH_KEYS[type]
    raise "SSHKeyFactory: Unknown key variant" if key.nil?
    key
  end
end
