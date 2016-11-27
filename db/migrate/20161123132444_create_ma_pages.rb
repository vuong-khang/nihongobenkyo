class CreateMaPages < ActiveRecord::Migration
  def change
    create_table :ma_pages do |t|
      t.integer :id
      t.string :header_jp
      t.string :header_en
      t.string :header_vi
      t.string :title_jp
      t.string :title_en
      t.string :title_vi
      t.string :icon
      t.string :path
      t.integer :parent_id

      t.timestamps null: false
    end
  end
end
