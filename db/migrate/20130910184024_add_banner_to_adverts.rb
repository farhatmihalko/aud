class AddBannerToAdverts < ActiveRecord::Migration
  def change
    add_column :adverts, :banner, :string
  end
end
