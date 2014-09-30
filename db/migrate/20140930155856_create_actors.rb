class CreateActors < ActiveRecord::Migration
  def change
    create_table :actors do |t|
      t.string :firstname
      t.string :lastname
      t.string :gender
      t.datetime :birthdate

      t.timestamps
    end
  end
end
