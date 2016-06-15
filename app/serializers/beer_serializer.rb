class BeerSerializer < ActiveModel::Serializer
  attributes :name, :image, :abv, :bdb_id, :favorite
end
