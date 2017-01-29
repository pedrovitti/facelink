require "spec_helper"
require 'facelink'

describe Facelink::Report do

  describe ".interaction_for" do
    it "returns all user interactions for a given post" do
      expected_interactions = [
        { user_id: 1665226560398606,
          page_id: 305736219467790,
          post_id: 1343551859019549,
          post_type: "photo",
          interaction_type: "reaction",
          interaction_subtype: "LIKE"
        },
        {
          user_id: 237119710021866,
          page_id: 305736219467790,
          post_id: 1343551859019549,
          post_type: "photo",
          interaction_type: "reaction",
          interaction_subtype: "LIKE"
        }]

      post_id = "305736219467790"
      expect(Facelink::Report.interactions_for(post_id)).to eql(expected_interactions)
    end
  end
end
