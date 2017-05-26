module Facelink
  class Client
    attr_accessor :page_id, :limit, :facebook_client

    def initialize(page_id, limit = 25, facebook_client)
      @page_id = page_id
      @limit = limit
      @facebook_client = facebook_client || Facelink::FacebookClient.new
    end

    def interactions
      interactions = []
      posts = facebook_client.posts(page_id, limit)

      posts.each do |post|
        interactions += interactions_for(post, 'reactions') + interactions_for(post, 'comments')
      end

      interactions
    end

    def interactions_for(post, interaction_type)
      return [] unless post[interaction_type]

      interactions_data = facebook_client.interactions_data_for(post[interaction_type])

      interactions = transform_data(interactions_data, post, interaction_type)
      interactions_data = interactions_data.next_page

      while interactions_data
        interactions += transform_data(interactions_data, post, interaction_type)
        interactions_data = interactions_data.next_page
      end

      interactions
    end

    private

    def transform_data(data, post, interaction_type)
      data.map do |interaction|
        formatted_data = {
          user_id: interaction['id'],
          page_id: page_id,
          post_id: post['id'],
          post_type: post['type']
        }

        formatted_data.merge(transform_data_for(interaction_type, interaction))
      end
    end

    def transform_data_for(interaction_type, interaction)
      case interaction_type
      when 'comments'
        { user_id: interaction['from']['id'], interaction_type: 'comment' }
      when 'reactions'
        { user_id: interaction['id'], interaction_type: 'reaction', interaction_subtype: interaction['type'] }
      else
        {}
      end
    end
  end
end
