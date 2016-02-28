class AddPropertyNameToAnswer < ActiveRecord::Migration
  def change
    add_column :answers, :property_name, :string
  end
end
