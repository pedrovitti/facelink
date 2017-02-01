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

      @reactions = transform_data(reactions_data, post)
      reactions_data = reactions_data.next_page

      while reactions_data
        @reactions += transform_data(reactions_data, post)
        reactions_data = reactions_data.next_page
      end

      @reactions
    end


    def comments(post)
      comments_data = Koala::Facebook::API::GraphCollection.new(post["comments"], graph) || []

      @comments = comments_data.map do |comment|
        {
          user_id: comment["from"]["id"],
          page_id: page_id,
          post_id: post["id"],
          post_type: post["type"],
          interaction_type: "comment"
        }
      end

       comments_data = comments_data.next_page

      while comments_data
        @comments = comments_data.map do |comment|
          {
            user_id: comment["from"]["id"],
            page_id: page_id,
            post_id: post["id"],
            post_type: post["type"],
            interaction_type: "comment"
          }
        end

        comments_data = comments_data.next_page
      end

      @comments
    end

    def graph
      @graph ||= Koala::Facebook::API.new(Facelink::Config.access_token)
    end

    private

    def transform_data(reactions_data, post)
      reactions_data.map do |reaction|
        {
          user_id: reaction["id"],
          page_id: page_id,
          post_id: post["id"],
          post_type: post["type"],
          interaction_type: "reaction",
          interaction_subtype: reaction["type"]
        }
      end
    end

  end

end
