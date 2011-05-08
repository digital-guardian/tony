require_relative 'helper'
require 'fileutils'

describe Tony::Generator do
  before :each do
    @test_directory = File.join(File.dirname(__FILE__), 'test')
    Dir.mkdir(@test_directory)
  end

  after :each do
    FileUtils.rm_rf(@test_directory)
  end

  describe ".write" do
    it "creates files if they don't exist" do
      test_file = File.join(@test_directory, 'test.file')
      Tony::Generator.new(test_file).write
      File.exist?(test_file).should == true
    end

    it "creates all directories below the file if they don't exist" do
      non_existent_directory = File.join(@test_directory, 'non_existent_directory')
      test_file = File.join(non_existent_directory, 'test.file')
      Tony::Generator.new(test_file).write
      File.directory?(non_existent_directory).should == true
      File.exist?(test_file).should == true
    end

    it "writes the result of the yield block to the file" do
      test_file = File.join(@test_directory, 'test.file')
      Tony::Generator.new(test_file) do
        "the file contents"
      end.write
      File.read(test_file).should == "the file contents\n"
    end
  end
end