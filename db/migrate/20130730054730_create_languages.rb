class CreateLanguages < ActiveRecord::Migration
  def change
    create_table :languages do |t|
      t.string :name
      t.string :short_code
      t.string :long_code

      t.timestamps
    end
  end
end
