# == Schema Information
#
# Table name: pages
#
#  id         :integer          not null, primary key
#  name       :string(50)
#  permalink  :string(20)
#  admin_use  :boolean
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_pages_on_name       (name) UNIQUE
#  index_pages_on_permalink  (permalink) UNIQUE
#

class Page < ActiveRecord::Base
  
    has_rich_text :content

    scope :public_viewable, -> { where(admin_use: false) }
  
    validates :name,                   presence: true,
                                       length: { maximum: 50 }
    validates :permalink,              presence: true,
                                       uniqueness: { case_sensitive: false },
                                       length: { maximum: 20 }
  
  end
