class CreateMaShiekiukemikeis < ActiveRecord::Migration
  def change
    create_table :ma_shiekiukemikeis do |t|
      t.string :index
      t.string :kotoba_kj_1
      t.string :kotoba_kj_2
      t.string :kotoba_hira_1
      t.string :kotoba_hira_2
      t.datetime :dt_create
      t.datetime :dt_update

      t.timestamps null: false
    end
  end
end
