class ChargedPerson < ApplicationRecord
  belongs_to :client

  validates :name, presence: true
  validates :phone , numericality: {only_integer: true}
  
end
