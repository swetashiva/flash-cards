class FolderSerializer < ActiveModel::Serializer
  attributes :id, :name
  has_many :study_sets
  belongs_to :user
end
