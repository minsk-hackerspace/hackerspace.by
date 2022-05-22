# == Schema Information
#
# Table name: public_ssh_keys
#
#  id         :integer          not null, primary key
#  body       :text
#  user_id    :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_public_ssh_keys_on_user_id  (user_id)
#
# Foreign Keys
#
#  user_id  (user_id => users.id)
#
FactoryBot.define do
  factory :public_ssh_key do
    body { "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDLmHlIJyd60EZBzLrxMNSwx6pUVKXe9Zrh9YANZ5Ez9TIFz+qwjAXCF+e/eQzNT/4NbgkossvusnqDtVje6ylq0HLYIQSdEuS9LeScny3EVuPpamNdiBbSJNArijvJxYJKNheBhir4PwYQhqylatZ/EwEXokXd38Nz+DcHY3OTpQhbRW6LxJ1OBsjYGiKf8WaCLJCDnYev/6bOPfWJTQo/9HiiY7LxpmYh+mflT8WPuRXxujgcTZjPfwlO2NeeLvOT13QeLGvwmgb+6zlHADWu6+j2xUExKijCMWMTJOWeMKTrBAYb6Gi82WU2ezrWRqXVHnkvBTkXj6XFj6pLkRZbwW8TCYUwK4F3FmlSW8oZJUWfZWOFuboEcxAg2kuyS/FnT5OBljkecprE4ldU/Wbgs2UytSrlvQqO2Mu/1ucH7FHhVR9/77ssp+kPNGo8p2ISkMZtDhlgXoKVmrsoY/vZaUHIGwdtLmJ8g6pS8erXeUEBEFTWLBo4jq8kIeZS04k= test@example.com" }
    user

    trait :without_email do
      body { "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDLmHlIJyd60EZBzLrxMNSwx6pUVKXe9Zrh9YANZ5Ez9TIFz+qwjAXCF+e/eQzNT/4NbgkossvusnqDtVje6ylq0HLYIQSdEuS9LeScny3EVuPpamNdiBbSJNArijvJxYJKNheBhir4PwYQhqylatZ/EwEXokXd38Nz+DcHY3OTpQhbRW6LxJ1OBsjYGiKf8WaCLJCDnYev/6bOPfWJTQo/9HiiY7LxpmYh+mflT8WPuRXxujgcTZjPfwlO2NeeLvOT13QeLGvwmgb+6zlHADWu6+j2xUExKijCMWMTJOWeMKTrBAYb6Gi82WU2ezrWRqXVHnkvBTkXj6XFj6pLkRZbwW8TCYUwK4F3FmlSW8oZJUWfZWOFuboEcxAg2kuyS/FnT5OBljkecprE4ldU/Wbgs2UytSrlvQqO2Mu/1ucH7FHhVR9/77ssp+kPNGo8p2ISkMZtDhlgXoKVmrsoY/vZaUHIGwdtLmJ8g6pS8erXeUEBEFTWLBo4jq8kIeZS04k=" }
    end

    trait :invalid_type do
      body { "ssh-rsssa AAAAB3NzaC1yc2EAAAADAQABAAABgQDLmHlIJyd60EZBzLrxMNSwx6pUVKXe9Zrh9YANZ5Ez9TIFz+qwjAXCF+e/eQzNT/4NbgkossvusnqDtVje6ylq0HLYIQSdEuS9LeScny3EVuPpamNdiBbSJNArijvJxYJKNheBhir4PwYQhqylatZ/EwEXokXd38Nz+DcHY3OTpQhbRW6LxJ1OBsjYGiKf8WaCLJCDnYev/6bOPfWJTQo/9HiiY7LxpmYh+mflT8WPuRXxujgcTZjPfwlO2NeeLvOT13QeLGvwmgb+6zlHADWu6+j2xUExKijCMWMTJOWeMKTrBAYb6Gi82WU2ezrWRqXVHnkvBTkXj6XFj6pLkRZbwW8TCYUwK4F3FmlSW8oZJUWfZWOFuboEcxAg2kuyS/FnT5OBljkecprE4ldU/Wbgs2UytSrlvQqO2Mu/1ucH7FHhVR9/77ssp+kPNGo8p2ISkMZtDhlgXoKVmrsoY/vZaUHIGwdtLmJ8g6pS8erXeUEBEFTWLBo4jq8kIeZS04k= test@example.com" }
    end

    trait :invalid_format do
      body { "ssh-rsa test@example.com" }
    end

    trait :with_options do
      body { "agent-forwarding,cert-authority ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDLmHlIJyd60EZBzLrxMNSwx6pUVKXe9Zrh9YANZ5Ez9TIFz+qwjAXCF+e/eQzNT/4NbgkossvusnqDtVje6ylq0HLYIQSdEuS9LeScny3EVuPpamNdiBbSJNArijvJxYJKNheBhir4PwYQhqylatZ/EwEXokXd38Nz+DcHY3OTpQhbRW6LxJ1OBsjYGiKf8WaCLJCDnYev/6bOPfWJTQo/9HiiY7LxpmYh+mflT8WPuRXxujgcTZjPfwlO2NeeLvOT13QeLGvwmgb+6zlHADWu6+j2xUExKijCMWMTJOWeMKTrBAYb6Gi82WU2ezrWRqXVHnkvBTkXj6XFj6pLkRZbwW8TCYUwK4F3FmlSW8oZJUWfZWOFuboEcxAg2kuyS/FnT5OBljkecprE4ldU/Wbgs2UytSrlvQqO2Mu/1ucH7FHhVR9/77ssp+kPNGo8p2ISkMZtDhlgXoKVmrsoY/vZaUHIGwdtLmJ8g6pS8erXeUEBEFTWLBo4jq8kIeZS04k= test@example.com" }
    end
  end
end
