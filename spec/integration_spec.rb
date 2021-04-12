RSpec.describe 'Integration' do
  ActiveRecord::Base.establish_connection adapter: 'sqlite3', database: ':memory:'
  ActiveRecord::Migration.verbose = false

  class TestMigration < ActiveRecord::Migration[4.2]
    def self.up
      create_table :avatars, force: true do |t|
        t.column :image1, :text
      end

      create_table :images, force: true do |t|
        t.column :data, :text
      end
    end

    def self.down
      drop_table :avatars
      drop_table :images
    end
  end

  class ImageUploader < CarrierWave::Uploader::Base; end

  class ApplicationRecord < ActiveRecord::Base
    self.abstract_class = true

    mount_uploader :base_image, ImageUploader, serialize_to: :data
  end

  class Avatar < ApplicationRecord
    mount_uploader :image1, ImageUploader
  end

  class Image < ApplicationRecord
    serialize :data, Hash
    mount_uploader :image1, ImageUploader, serialize_to: :data
  end

  before(:all) { TestMigration.up }
  after(:all) { TestMigration.down }

  after do
    Avatar.destroy_all
    Image.destroy_all
  end

  let(:image) { Image.new }

  it 'should mount uploader to serialized field' do
    expect(image.image1).to be_instance_of ImageUploader
  end

  it 'should upload image and store it to the serialized field' do
    with_image do |file|
      image.image1 = file
      image.save!

      expect(image.data['image1']).to be_present
    end
  end

  it 'inherits superclass uploaders' do
    with_image do |file|
      image.base_image = file
      image.save!

      expect(image.data['base_image']).to be_present
    end
  end

  describe 'model with the regular uploader and same name as serialized uploader' do
    before do
      Image.new
    end

    it 'mounts uploader to regular field' do
      avatar = Avatar.new

      expect(avatar.image1).to be_instance_of ImageUploader
    end
  end
end
