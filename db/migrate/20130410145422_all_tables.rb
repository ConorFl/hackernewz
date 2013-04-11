class AllTables < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :name, :email, :password_digest
      t.timestamps
    end
    create_table :posts do |t|
      t.string :title, :body
      t.references :user
      t.timestamps
    end
    create_table :comments do |t|
      t.string :body
      t.references :post, :user
    end
    create_table :post_votes do |t|
      t.integer :value
      t.timestamps
      t.references :post, :user
    end
    create_table :comment_votes do |t|
      t.integer :value
      t.timestamps
      t.references :comment, :user
    end

  end
end
