class AddUpdatedByToSports < ActiveRecord::Migration[6.1]
  def change
    add_column :sports, :updated_by, :bigint
  end
end
