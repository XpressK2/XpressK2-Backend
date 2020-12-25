# == Schema Information
#
# Table name: users
#
#  id              :bigint           not null, primary key
#  country         :string           not null
#  country_code    :string           not null
#  email           :string           not null
#  name            :string           not null
#  password_digest :string           not null
#  status          :integer          default("inactive")
#  telephone_no    :string           not null
#  trade_role      :integer          not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
# Indexes
#
#  index_users_on_country_code_and_telephone_no             (country_code,telephone_no) UNIQUE
#  index_users_on_email_and_trade_role_and_name_and_status  (email,trade_role,name,status)
#
class User < ApplicationRecord
  # Requirements
  extend Enumerize
  include UserPresenter
  has_secure_password(validations: false)

  # # Scopes
  # # Constants
  TRADE_ROLES = { buyer: 1, saller: 2, both: 3 }
  STATUSS = { inactive: 1, active: 2 }

  # # Enums
  enumerize :trade_role, in: TRADE_ROLES, scope: true, predicates: true
  enumerize :status, in: STATUSS, scope: true, predicates: true

  # Associations
  # Validations 
  validates :name, presence: true, length: { in: 10..25 }
  validates :email,
            presence:   true,
            uniqueness: { case_sensitive: false },
            format:     { with: URI::MailTo::EMAIL_REGEXP }
  validates :telephone_no,
            presence:     true,
            uniqueness:   { case_sensitive: false, scope: :country_code },
            numericality: { only_integer: true },
            length:       { is: 9 }

  # Callbacks
  before_validation :downcase_email, :capitalize_name

  # Class Methods

  # Methods
  private

  def downcase_email
    self.email = email.downcase
  end

  def capitalize_name
    self.name = name.split.map(&:capitalize)*(' ')
  end
end
