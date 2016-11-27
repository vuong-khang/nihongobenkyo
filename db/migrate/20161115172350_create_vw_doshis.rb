class CreateVwDoshis < ActiveRecord::Migration
  def change
    create_table :vw_doshis do |t|
      t.string :index
      t.string :jishokei
      t.string :yomikata
      t.integer :group
      t.string :masukei
      t.string :masukei_yomikata
      t.string :tekei
      t.string :tekei_yomikata
      t.string :kakokei
      t.string :kakokei_yomikata
      t.string :hiteikei
      t.string :hiteikei_yomikata
      t.string :kanokei
      t.string :kanokei_yomikata
      t.string :ishikei
      t.string :ishikei_yomikata
      t.string :jyokenkei
      t.string :jyokenkei_yomikata
      t.string :meireikei
      t.string :meireikei_yomikata
      t.string :kinshikei
      t.string :kinshikei_yomikata
      t.string :ukemikei
      t.string :ukemikei_yomikata
      t.string :shiekikei
      t.string :shiekikei_yomikata
      t.string :shiekiukemi
      t.string :shiekiukemi_yomikata
      t.datetime :dt_create
      t.datetime :dt_update

      t.timestamps null: false
    end
  end
end
