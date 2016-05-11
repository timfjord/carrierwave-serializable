RSpec.describe 'Integration' do
  ActiveRecord::Base.establish_connection adapter: 'sqlite3', database: ':memory:'
  ActiveRecord::Base.raise_in_transactional_callbacks = true
  ActiveRecord::Migration.verbose = false

  class TestMigration < ActiveRecord::Migration
    def self.up
      create_table :images, :force => true do |t|
        t.column :data, :text
      end
    end

    def self.down
      drop_table :images
    end
  end

  class ImageUploader < CarrierWave::Uploader::Base; end

  class Image < ActiveRecord::Base
    serialize :data, Hash
    mount_uploader :image1, ImageUploader, serialize_to: :data
  end

  before(:all) { TestMigration.up }
  after(:all) { TestMigration.down }
  after { Image.destroy_all }

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
end
