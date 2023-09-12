class User < ApplicationRecord
    has_secure_password # macro
    has_many :posts # association

    before_validation :sanitize_user_name # Active Record Callback

    # Active Record Validation 
    validates :email, presence: { 
        message: I18n.t('validation.cannot_be_blank') 
    }, uniqueness: { 
        message: I18n.t('validation.already_exists')
    }, format: { 
        with: URI::MailTo::EMAIL_REGEXP, 
        message: I18n.t('validation.invalid') 
    }
    validates :user_name, presence: { 
        message: I18n.t('validation.cannot_be_blank')
    }, uniqueness: { 
        message: I18n.t('validation.already_exists')
    }
    validates :password, length: { minimum: 6,
        message: I18n.t('validation.must_be_at_least', count: 6)
    }, if: -> { new_record? || !password.nil? }
 
    def sanitize_user_name
        self.user_name = user_name.downcase.gsub(/[^a-z0-9]+/, "")
    end
    
end
