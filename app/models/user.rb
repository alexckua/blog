# frozen_string_literal: true

class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         authentication_keys: [:login]

  attr_writer :login

  validates_format_of :username, with: /^[a-zA-Z0-9_\.]*$/, multiline: true

  validates :first_name, :last_name, length: { maximum: 20 }, allow_blank: true

  validates :username, presence: true, uniqueness: { case_sensitive: false }

  has_many :posts

  enum role: %i[user admin]

  def login
    @login || username || email
  end

  def full_name
    "#{first_name} #{last_name}"
  end

  # rubocop:disable all
  def self.find_first_by_auth_conditions(warden_conditions)
    conditions = warden_conditions.dup
    if login = conditions.delete(:login)
      where(conditions).where(['lower(username) = :value OR lower(email) = :value', { value: login.downcase }]).first
    else
      if conditions[:username].nil?
        where(conditions).first
      else
        where(username: conditions[:username]).first
      end
    end
  end
  # rubocop:enable all
end
