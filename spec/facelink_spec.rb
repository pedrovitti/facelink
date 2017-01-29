require "spec_helper"
require 'facelink'

describe Facelink::Report do

  describe ".interaction_for" do
    it "returns all user interactions for a given page" do
      expected_interactions = [
        { user_id: "1665226560398606",
          page_id: "305736219467790",
          post_id: "305736219467790_1343551859019549",
          post_type: "photo",
          interaction_type: "reaction",
          interaction_subtype: "LIKE"
        },
        {
          user_id: "237119710021866",
          page_id: "305736219467790",
          post_id: "305736219467790_1343551859019549",
          post_type: "photo",
          interaction_type: "reaction",
          interaction_subtype: "LIKE"
        },
        {
          user_id: "238629406558829",
          page_id: "305736219467790",
          post_id: "305736219467790_1335958239778911",
          post_type: "video",
          interaction_type: "comment"
        }]

      page_id = "305736219467790"
      expect(Facelink::Report.interactions_for(page_id, 2)).to include(expected_interactions[0], expected_interactions[1], expected_interactions[2])
    end
  end
end
