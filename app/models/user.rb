class User < ApplicationRecord
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :name,  presence: true, length: {maximum: Settings.name_maximum}
  validates :password, presence: true, length: {maximum: Settings.pass_maximum}
  validates :email, presence: true, length: {maximum: Settings.email_maximum},
    format: {with: VALID_EMAIL_REGEX}, uniqueness: {case_sensitive: false}
  before_save :downcase_email
  has_secure_password

  private

  def downcase_email
    email.downcase!
  end
end
