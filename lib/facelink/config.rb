require 'yaml'
require 'koala'

module Facelink

  module Config

    CONFIG_PATH = '~/.facelink-config.yml'
    API_VERSION = "2.8"

    module_function

    def config
      @config ||= YAML.load_file(File.expand_path(CONFIG_PATH))
    end

    def configure_facebook_client
      Koala.config.api_version = config["facebook"]["api_version"]
    end

    def create_config_file(access_token, api_version = API_VERSION)
      configuration = { "facebook" => { "access_token" => access_token, "api_version" => api_version } }

      File.open(File.expand_path(CONFIG_PATH), 'w') { |f| f.write configuration.to_yaml }
    end

    def access_token
     config["facebook"]["access_token"]
    end

  end

end
