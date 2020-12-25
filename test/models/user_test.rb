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
require 'test_helper'

class UserTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
