User.class_eval do
  alias_attribute :token, :api_key
  before_validation :generate_token
  validates_presence_of :token

  def generate_token
    self.token ||= secure_digest(Time.now, (1..10).map{ rand.to_s })
  end

  def regenerate_token!
    self.update_attribute(:api_key, secure_digest(Time.now, (1..10).map{ rand.to_s }))
  end

  private
  def secure_digest(*args)
    Digest::SHA1.hexdigest(args.flatten.join('--'))
  end
end