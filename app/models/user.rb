class User < ApplicationRecord
    default_scope { select(:id, :name, :user_name, :email, :created_at, :updated_at, :is_verified) } 
    
    # macros
    has_secure_password 

    # associations
    has_many :posts 

    # Active Record Callback
    before_validation :sanitize_user_name 

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

    def as_json(options = {})
       super({:only => [:id, :name, :user_name, :email, :created_at, :updated_at, :is_verified]}.merge(options))
    end
    
end
