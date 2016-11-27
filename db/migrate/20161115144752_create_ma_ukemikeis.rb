class CreateMaUkemikeis < ActiveRecord::Migration
  def change
    create_table :ma_ukemikeis do |t|
      t.string :index
      t.string :kotoba_kj
      t.string :kotoba_hira
      t.datetime :dt_create
      t.datetime :dt_update

      t.timestamps null: false
    end
  end
end
