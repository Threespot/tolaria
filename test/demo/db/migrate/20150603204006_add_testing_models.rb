class AddTestingModels < ActiveRecord::Migration
  def change

    create_table :blog_posts, force: :true do |t|
      t.timestamps null:false
      t.string :title, null: false
      t.datetime :published_at, null: false
      t.text :summary
      t.text :body
      t.string :color
      t.text :portrait
      t.text :attachment
    end

    create_table :categories, force:true do |t|
      t.timestamps null:false
      t.string :label, null:false
      t.string :slug, null:false, index:true
    end

    create_table :blog_post_categories, force:true do |t|
      t.integer :blog_post_id, null:false, index:true
      t.integer :category_id, null:false, index:true
    end

  end
end
