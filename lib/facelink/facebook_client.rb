require 'koala'

module Facelink
  class FacebookClient
    attr_reader :client

    def initialize
      @client ||= Koala::Facebook::API.new(Facelink::Config.access_token)
    end

    def interactions_data_for(interaction_type)
      Koala::Facebook::API::GraphCollection.new(interaction_type, client)
    end

    def posts(page_id, limit)
      client.get_connections(page_id, 'posts', limit: limit,
                                               fields: ['reactions{id, type}',
                                                        'comments{id, from}',
                                                        'type'])
    end
  end
end
