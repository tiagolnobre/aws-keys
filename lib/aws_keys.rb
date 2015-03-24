require 'inifile'
require 'yaml'
require "aws_keys/version"

module AwsKeys
 
  def self.load(profile: nil, yml_file: ENV['HOME'] + "/.aws.yml")
  
    aws_credential_path = ENV['HOME'] + "/aws/credentials"

    case
    when !(ENV.keys & %w[AWS_ACCESS_KEY AWS_SECRET_KEY]).empty?
     {
        "aws_access_key"=>ENV["AWS_ACCESS_KEY"], 
        "aws_secret_key"=>ENV["AWS_SECRET_KEY"]
      }
    when File.exist?(yml_file)
      data = YAML.load_file(yml_file)
      profile.nil? ? data : data[profile]
    when File.exist?(aws_credential_path)
      file = IniFile.load(aws_credential_path)
      profile.nil? ? file["default"] : file[profile]
    else
      fail NoAwsKeys, "None of ENV variables, ~/aws/credentials or aws.yml were found"
    end
  end 

  class NoAwsKeys < StandardError; end
end
