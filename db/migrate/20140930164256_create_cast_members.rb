class CreateCastMembers < ActiveRecord::Migration
  def change
    create_table :cast_members do |t|
      t.references :actor, index: true
      t.references :movie, index: true

      t.timestamps
    end
  end
end
