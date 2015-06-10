class CreateAdditionalDemoObjects < ActiveRecord::Migration
  def change

    create_table :images, force:true do |t|
      t.timestamps null:false
      t.string :title, null:false
      t.text :alternate_text
      t.text :credit
      t.text :keywords
      t.text :attachment_address, null:false
    end

    create_table :videos, force:true do |t|
      t.timestamps null:false
      t.string :title, null:false
      t.string :youtube_id, null:false
      t.string :description
    end

    create_table :legal_pages, force:true do |t|
      t.timestamps null:false
      t.string :title, null:false
      t.string :slug, null:false, index:true
      t.text :summary, null:false
      t.text :body
    end

    create_table :miscellany, force:true do |t|
      t.timestamps null:false
      t.string :key, null:false, index:true
      t.text :value, null:false
      t.text :description, null:false
    end

    drop_table :categories
    drop_table :blog_post_categories

    create_table :topics, force:true do |t|
      t.timestamps
      t.string :label, null:false
      t.string :slug, null:false, index:true
    end

    create_table :blog_post_topics, force:true do |t|
      t.integer :blog_post_id, null:false, index:true
      t.integer :topic_id, null:false, index:true
    end

  end
end
