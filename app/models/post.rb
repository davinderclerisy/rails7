class Post < ApplicationRecord
  belongs_to :user

  # Active Record Validation 
  validates :title, presence: { 
    message: I18n.t('validation.cannot_be_blank') 
  }
  validates :body, presence: { 
    message: I18n.t('validation.cannot_be_blank') 
  }
  
end
