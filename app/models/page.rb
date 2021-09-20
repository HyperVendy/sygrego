# == Schema Information
#
# Table name: pages
#
#  id         :bigint           not null, primary key
#  admin      :boolean
#  name       :string(50)
#  permalink  :string(20)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Page < ActiveRecord::Base
  
    has_rich_text :content
    
    scope :public_viewable, -> { where(admin: false) }
  
    validates :name,                   presence: true,
                                       length: { maximum: 50 }
    validates :permalink,              presence: true,
                                       uniqueness: { case_sensitive: false },
                                       length: { maximum: 20 }
  
#    searchable_by :name, :content
  
    def self.per_page
      30
    end
  end
