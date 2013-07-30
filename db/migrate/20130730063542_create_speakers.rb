class CreateSpeakers < ActiveRecord::Migration
  def change
    create_table :speakers do |t|
      t.integer :parent_id
      t.integer :language_id
      t.string :name
      t.string :hidden_markov_model
      t.string :language_model
      t.string :dictionary

      t.timestamps
    end
  end
end
