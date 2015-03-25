require "spec_helper"
require "yaml"
require "inifile"

RSpec.describe AwsKeys do

  describe "#version" do
    it 'should return version number' do
      expect(AwsKeys::VERSION).not_to be nil
    end
  end

  describe "#load" do

    context "when load aws keys from ENV" do
      before(:each){
        ENV["AWS_ACCESS_KEY"]="my_access_key"
        ENV["AWS_SECRET_KEY"]="my_secret_key"
      }

      after(:each){
        ENV.delete("AWS_ACCESS_KEY")
        ENV.delete("AWS_SECRET_KEY")
      }

      it 'should return a hash of aws keys' do
        expected = {
          "aws_access_key"=>ENV["AWS_ACCESS_KEY"], 
          "aws_secret_key"=>ENV["AWS_SECRET_KEY"]
        }
        expect(described_class.load).to eq(expected)
      end
  end  

  context "when load aws keys from yml file" do

    after(:each){ 
      FileUtils.rm_rf("test.yml")
      FileUtils.rm_rf(ENV["HOME"] + "/.aws.yml")
    }

    let(:yml_content){{
        "aws_access_key"=>"my_access_key", 
        "aws_secret_key"=>"my_secret_key"
        }
    }
    let(:file){ ENV["HOME"] + "/.aws.yml" }

    it 'should return a hash of aws keys' do
      File.open(file, "w"){|f| YAML.dump(yml_content, f)}
      expect(described_class.load).to eq(yml_content)
    end

    it 'should return a hash of aws keys using a profile' do
      yml_file = { "default" => yml_content }
      File.open(file, "w"){|f| YAML.dump(yml_file, f)}
    
      aws_keys = described_class.load(profile: "default")
      expect(aws_keys).to eq(yml_file["default"])
    end
  end

  context "when load aws keys from ~/aws/credentials file" do

    before(:all){
      FileUtils.mkdir(ENV["HOME"] + "/aws", :noop => true)

      @admin = {
        "aws_access_key"=>"admin_access_key", 
        "aws_secret_key"=>"admin_secret_key"
        }

      @yml_content = {
        "aws_access_key"=>"my_access_key", 
        "aws_secret_key"=>"my_secret_key"
        }

      @file = ENV["HOME"] + "/aws/credentials"

      new_file = IniFile.new
      new_file["default"] = @yml_content 
      new_file["admin"] = @admin
      new_file.filename = @file
      new_file.write()
    }

    after(:all){ FileUtils.rm_rf(@file)}

    it 'with profile' do  
      expect(described_class.load).to eq(@yml_content)
    end

    it 'with other profile' do
      aws_keys = described_class.load(profile: "admin")
      expect(aws_keys).to eq(@admin)
    end
  end
  end
end
