module Facelink

  class Client

    def interactions_for(page_id, limit = 25)
      @interactions = []
      posts = graph.get_connections(page_id, "posts", { limit: limit,
                                                         fields: ["reactions",
                                                                  "comments",
                                                                  "type"]})

      posts.each do |post|
        @interactions += reactions(post, page_id) + comments(post, page_id)
      end

      @interactions
    end

    def reactions(post, page_id)
      reactions_data = post["reactions"] && post["reactions"]["data"] || []
      @reactions = reactions_data.map do |reaction|
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

    def comments(post, page_id)
      comments_data = post["comments"] && post["comments"]["data"] || []
      @comments = comments_data.map do |comment|
        {
          user_id: comment["from"]["id"],
          page_id: page_id,
          post_id: post["id"],
          post_type: post["type"],
          interaction_type: "comment"
        }
      end
    end

    def graph
      @graph ||= Koala::Facebook::API.new(Facelink::Config.access_token)
    end

  end

end
