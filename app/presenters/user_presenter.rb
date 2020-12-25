module UserPresenter
  extend ActiveSupport::Concern

  included do
    acts_as_api

    api_accessible :base do |t|
      t.add :id
      t.add :name
      t.add :email
      t.add :status
      t.add :country
      t.add :trade_role
      t.add :country_code
      t.add :telephone_no
    end

    ## ----------------------- User Response ------------------------- ##

    api_accessible :index, extend: :base

    api_accessible :show, extend: :index
  end
end
