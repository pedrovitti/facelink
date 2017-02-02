module Facelink

  class Client

    attr_accessor :page_id, :limit

    def initialize(page_id, limit = 25)
      @page_id = page_id
      @limit = limit
    end

    def interactions()
      @interactions = []
      posts = graph.get_connections(page_id, "posts", { limit: limit,
                                                         fields: ["reactions",
                                                                  "comments",
                                                                  "type"]})

      posts.each do |post|
        @interactions += reactions(post) + comments(post)
      end

      @interactions
    end

    def reactions(post)
      reactions_data = Koala::Facebook::API::GraphCollection.new(post["reactions"], graph) || []

      @reactions = transform_data(reactions_data, post, "reaction")
      reactions_data = reactions_data.next_page

      while reactions_data
        @reactions += transform_data(reactions_data, post, "reaction")
        reactions_data = reactions_data.next_page
      end

      @reactions
    end

    def comments(post)
      comments_data = Koala::Facebook::API::GraphCollection.new(post["comments"], graph) || []

      @comments = transform_data(comments_data, post, "comment")
      comments_data = comments_data.next_page

      while comments_data
        @comments += transform_data(comments_data, post, "comment")
        comments_data = comments_data.next_page
      end

      @comments
    end

    def graph
      @graph ||= Koala::Facebook::API.new(Facelink::Config.access_token)
    end

    private

    def transform_data(data, post, interaction_type)
      data.map do |interaction|
        formatted_data  = {
          user_id: interaction["id"],
          page_id: page_id,
          post_id: post["id"],
          post_type: post["type"],
          interaction_type: interaction_type
        }

        formatted_data.merge(transform_data_for(interaction_type, interaction))
      end
    end

    def transform_data_for(interaction_type, interaction)
      case interaction_type
      when "comment"
        { user_id: interaction["from"]["id"] }
      when "reaction"
        { user_id: interaction["id"], interaction_subtype: interaction["type"] }
      else
        {}
      end
    end

  end

end
