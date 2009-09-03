class Mailer < Iso2022jpMailer
  FROM_ADDRESS = "#{APP_CONFIG[:service_name]} <#{APP_CONFIG[:admin_email]}>"
  
  def add_task( task , send_at = Time.now)
    @subject    = to_base64("[#{task.project.name}]　であなたへタスクが追加されました")
    @recipients = task.treat_user.email
    @from       = to_base64(FROM_ADDRESS)
    @sent_on    = send_at
    @headers    = {}

    body :task => task
  end
  
  def add_meeting( user, meeting , send_at = Time.now)
    @subject    = to_base64("[#{meeting.project.name}]　- #{meeting.title} 参加依頼")
    @recipients = user.email
    @from       = to_base64(FROM_ADDRESS)
    @sent_on    = send_at
    @headers    = {}

    body :meeting => meeting
  end
  
  def minutes( user, meeting, send_at = Time.now)
    @subject    = to_base64("[#{meeting.project.name}]　- #{meeting.title} 議事録")
    @recipients = user.email
    @from       = to_base64(FROM_ADDRESS)
    @sent_on    = send_at
    @headers    = {}

    body :meeting => meeting
  end
  
  #　ゲストユーザを招待したとき
  def invite_user( invite_user, send_at = Time.now)
    @subject    = to_base64("#{APP_CONFIG[:service_name]}への招待状")
    @recipients = invite_user.email
    @from       = to_base64(FROM_ADDRESS)
    @sent_on    = send_at
    @headers    = {}

    body :invite_user => invite_user
  end
  
  private 
  
  def to_base64 (value)
    base64(value)
  end
  
end
