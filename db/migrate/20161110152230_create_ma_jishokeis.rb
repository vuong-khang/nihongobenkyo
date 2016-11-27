class CreateMaJishokeis < ActiveRecord::Migration
  def change
    create_table :ma_jishokeis do |t|
      t.string :index
      t.string :kotoba_kj
      t.string :kotoba_hira
      t.integer :group
      t.string :imi_en
      t.string :imi_vi
      t.datetime :dt_create
      t.datetime :dt_update

      t.timestamps null: false
    end
  end
end
