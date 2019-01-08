class Micropost < ApplicationRecord
  belongs_to :user
  validates :user_id, presence: true
  validates :content, presence: true, length: {maximum: Settings.content_maximum}
  mount_uploader :picture, PictureUploader
  scope :order_desc, ->{order created_at: :desc}
  validate :picture_size

  private

  def picture_size
    return unless picture.size > Settings.size_picturn.megabytes
    errors.add :picture, t("imag_erro")
  end
end
