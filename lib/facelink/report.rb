require 'koala'
module Facelink

  class Report

    Koala.config.api_version = "v2.8"

    def self.interactions_for(page_id, limit = 25)
      @interactions = []
      posts = graph.get_connections(page_id, "posts", { limit: limit,
                                                         fields: ["reactions",
                                                                  "comments",
                                                                  "type"]})

      posts.each do |post|
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

        @interactions += @reactions + @comments
      end

      @interactions
    end

    def self.graph
      @graph ||= Koala::Facebook::API.new(ENV["ACCESS_TOKEN"])
    end
  end
end
