class CreateFootnotes < ActiveRecord::Migration
  def change
    create_table :footnotes do |t|
      t.timestamps null:false
      t.integer :blog_post_id, null:false, index:true
      t.text :description
      t.text :url
    end
  end
end
