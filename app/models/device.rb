# == Schema Information
#
# Table name: devices
#
#  id                 :integer          not null, primary key
#  name               :string(255)      not null
#  encrypted_password :string(255)      not null
#  created_at         :datetime
#  updated_at         :datetime
#

class Device < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable#, :registerable,
         #:recoverable, :rememberable, :trackable, :validatable
  has_many :events, dependent: :destroy

  validates :name, presence: true

  def events_folded
    folded = []
    event_types = events.pluck(:event_type).uniq
    event_types.each do |event_type|
      events_of_this_type = events.where(event_type: event_type).order(created_at: :desc).to_a
      events_of_this_type.each_index do |i|
        while i < events_of_this_type.size - 1 && events_of_this_type[i].value == events_of_this_type[i+1].value
          events_of_this_type.delete events_of_this_type[i+1]
        end
      end
      folded += events_of_this_type
    end
    folded
  end

end
