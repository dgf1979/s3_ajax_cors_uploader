class AddExampleIdToPhoto < ActiveRecord::Migration
  def change
    add_column :photos, :example_id, :integer
  end
end
