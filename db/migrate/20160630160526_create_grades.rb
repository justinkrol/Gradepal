class CreateGrades < ActiveRecord::Migration
  def change
    create_table :grades do |t|
      t.string :name
      t.integer :score
      t.integer :max
      t.references :component, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
