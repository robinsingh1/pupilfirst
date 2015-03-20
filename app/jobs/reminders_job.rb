class RemindersJob < ActiveJob::Base
  queue_as :default

  def perform
    # Reminders for expiry in 1 month, and 20 days.
    Startup.where(agreement_ends_at: [1.month.from_now.to_date, 20.days.from_now.to_date]).each do |startup|
      expires_in = ((startup.agreement_ends_at - Time.zone.now) / 1.day).round
      renew_within = expires_in - 15

      # Push notification
      push_message = "Your incubation agreement expires in #{expires_in} days. To continue enjoying the services provided by Startup Village, please renew your agreement within #{renew_within} days."

      startup.founders.each do |user|
        UserPushNotifyJob.perform_later(user.id, 'startup_agreement_expiry', push_message)
      end

      # Email
      StartupMailer.agreement_expiring_soon(startup, expires_in, renew_within).deliver_later
    end
  end
end
