class Contact < ApplicationRecord
  validates :first_name, presence: true
  
  belongs_to :owner, polymorphic: true
  belongs_to :creator, class_name: 'User'

  def self.ransackable_attributes(auth_object = nil)
    %w[ first_name last_name email phone_number created_at updated_at ]
  end

  def self.ransackable_associations(auth_object = nil)
    []
  end

  def full_name
    "#{first_name} #{last_name}"
  end
end
