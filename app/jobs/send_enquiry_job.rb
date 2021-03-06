class SendEnquiryJob < ActiveJob::Base
  queue_as :default

  def perform(enquiry)
    attachments = []
    attachments <<
        {
            "title": enquiry.subject,
            "pretext": "From #{enquiry.name} (#{enquiry.email})",
            "text": enquiry.text,
            "mrkdwn_in": ["text", "pretext"]
        }
    enquiry.user.send_im("Incoming message from someone who's seen your profile:", attachments)

    enquiry.team.notify_inuda("New enquiry for #{enquiry.user_name} from #{enquiry.name} (#{enquiry.email})")
  end
end
