json.array!(@users) do |user|
  json.extract! user, :id, :email, :sign_in_count, :last_sign_in_at, :current_sign_in_ip, :last_sign_in_ip, :created_at, :hacker_comment, :photo_file_name, :first_name, :last_name, :telegram_username, :alice_greeting, :last_seen_in_hackerspace, :account_suspended, :account_banned, :monthly_payment_amount, :github_username, :ssh_public_key, :is_learner, :guarantor1_id, :guarantor2_id
  json.paid_until user.paid_until
  json.url user_url(user, format: :json)
end
