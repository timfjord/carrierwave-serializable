module FileHelper
  def with_image(name = 'blank.gif', &block)
    File.open File.expand_path("../../fixtures/#{name}", __FILE__), &block
  end
end
