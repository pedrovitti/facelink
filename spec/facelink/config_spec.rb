require "spec_helper"
require "json"

describe Facelink::Client do
  let(:client) { described_class.new }
  let(:page_id) { "305736219467790" }

  before { Facelink::Config.configure_facebook_client }

  describe "#interactions_for" do
    before do
      facebook_data = JSON.load(File.read(File.join("spec", "fixtures", "stagelink.json")))
      allow_any_instance_of(Koala::Facebook::API).to receive(:get_connections).and_return(facebook_data)
    end

    subject { client.interactions_for(page_id, 2) }

    it "returns both user interactions for a given page" do
      expected_interactions = [
        { user_id: "237119710021866",
          page_id: "305736219467790",
          post_id: "305736219467790_1351587491549319",
          post_type: "video",
          interaction_type: "reaction",
          interaction_subtype: "LIKE"
        },
        {
          user_id: "595464013920911",
          page_id: "305736219467790",
          post_id: "305736219467790_1335958239778911",
          post_type: "video",
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

      expect(subject).to include(*expected_interactions)
    end
  end

  describe "#reactions" do
    let(:reactions_data) { JSON.load(File.read(File.join("spec", "fixtures", "stagelink-reactions.json"))) }

    subject { client.reactions(reactions_data, page_id) }

    it "returns 25 user reactions" do
      expect(subject.count).to be 25
    end

    it "returns reaction from specific user" do
      expected_reaction =
        { user_id: "208217512958711",
          page_id: "305736219467790",
          post_id: "305736219467790_1350374218337313",
          post_type: "photo",
          interaction_type: "reaction",
          interaction_subtype: "LIKE"
        }

      expect(subject).to include expected_reaction
    end
  end

  describe "#comments" do
    let(:comments_data) { JSON.load(File.read(File.join("spec", "fixtures", "stagelink-comments.json"))) }

    subject { client.comments(comments_data, page_id) }

    it "returns 3 user comments" do
      expect(subject.count).to be 3
    end

    it "returns reaction from specific user" do
      expected_reaction =
        {  user_id: "220108871733421",
           page_id: "305736219467790",
           post_id: "305736219467790_1350374218337313",
           post_type: "photo",
           interaction_type: "comment"
        }

      expect(subject).to include expected_reaction
    end
  end
end