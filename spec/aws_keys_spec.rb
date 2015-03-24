require "spec_helper"
require "yaml"
require "inifile"

describe AwsKeys do
  let(:yml_content){
      {
        "aws_access_key"=>"my_access_key", 
        "aws_secret_key"=>"my_secret_key"
        }
    }

  it 'has a version number' do
    expect(AwsKeys::VERSION).not_to be nil
  end

  describe "does load AWS Keys from ENV" do
    after(:each){
      ENV.delete("AWS_ACCESS_KEY")
      ENV.delete("AWS_SECRET_KEY")
    }

    it 'asd' do
      ENV["AWS_ACCESS_KEY"]="my_access_key"
      ENV["AWS_SECRET_KEY"]="my_secret_key"

      aws_keys = AwsKeys.load
      expected = {
        "aws_access_key"=>ENV["AWS_ACCESS_KEY"], 
        "aws_secret_key"=>ENV["AWS_SECRET_KEY"]
      }
      expect(aws_keys).to eq(expected)
    end
  end  

  describe "does load AWS Keys from yml file" do
    before(:each){ 
      FileUtils.rm_rf("test.yml")
      FileUtils.rm_rf(ENV["HOME"] + ".aws.yml")
    }

    let(:file){ ENV["HOME"] + "/.aws.yml" }

    it 'using default yml path' do
      File.open(file, "w"){|f| YAML.dump(yml_content, f)}
    
      aws_keys = AwsKeys.load
      expect(aws_keys).to eq(yml_content)
    end

    it 'using default profile' do
      File.open(file, "w"){|f| YAML.dump({ "default" => yml_content }, f)}

      aws_keys = AwsKeys.load(profile: "default")
      expect(aws_keys).to eq(yml_content)
    end

    it 'with profile' do
      yml_file = { "default" => yml_content }
      File.open("test.yml", "w"){|f| YAML.dump(yml_file, f)}
    
      aws_keys = AwsKeys.load(yml: {path: "test.yml"}, profile: "default")
      expect(aws_keys).to eq(yml_file["default"])
    end

    it 'without profile' do
      File.open("test.yml", "w"){|f| YAML.dump(yml_content, f)}
    
      aws_keys = AwsKeys.load(yml: {path: "test.yml"})
      expect(aws_keys).to eq(yml_content)
    end
  end

  describe "does load AWS Keys from ~/aws/credential file" do
    
    before(:each){ FileUtils.rm_rf(file)}

    let(:file){ ENV["HOME"] + "/aws/credential" }

    let(:newfile){
      new_file = IniFile.new
      new_file["default"] = yml_content 
      new_file.filename = file
      new_file.write()
    }

    let(:multiple_profiles){
      new_file = IniFile.new
      new_file["default"] = yml_content 
      new_file["admin"] = admin
      new_file.filename = file
      new_file.write()
    }

    let(:admin){
      {
        "aws_access_key"=>"admin_access_key", 
        "aws_secret_key"=>"admin_secret_key"
        }
    }

    it 'with profile' do
      aws_keys = AwsKeys.load(profile: "default")
      expect(aws_keys).to eq(yml_content)
    end

    it 'with multiple profiles' do
      aws_keys = AwsKeys.load(profile: "admin")
      expect(aws_keys).to eq(admin)
    end
  end

end
