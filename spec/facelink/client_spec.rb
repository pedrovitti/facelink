require "spec_helper"
require "json"

describe Facelink::Client do
  let(:page_id) { "305736219467790" }
  let(:facebook_client) { Facelink::FacebookClient.new }
  let(:client) { described_class.new(page_id, 2, facebook_client) }

  before { Facelink::Config.configure_koala_facebook_client }

  describe "#interactions" do
    let(:facebook_data) { JSON.load(File.read(File.join("spec", "fixtures", "stagelink.json"))) }

    before do
      allow_any_instance_of(Facelink::FacebookClient).to receive(:posts).and_return(facebook_data)
      allow_any_instance_of(Koala::Facebook::API::GraphCollection).to receive(:next_page).and_return(nil)
    end

    subject { client.interactions }

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

    context "when no reactions" do
      before do
        facebook_data.first.delete("reactions")
      end

      it "returns all comments" do
        expect(subject.count).to eq 64
      end
    end

  end

  describe "#interactions_for" do
    context "when reactions" do
      let(:reactions_data) { JSON.load(File.read(File.join("spec", "fixtures", "stagelink-reactions.json"))) }

      subject { client.interactions_for(reactions_data, "reactions") }

      context "with less or equal 25 reactions (no pagination)" do
        before { allow_any_instance_of(Koala::Facebook::API::GraphCollection).to receive(:next_page).and_return(nil) }

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

      context "when more than 25 reactions (with pagination)" do
        let(:second_page_reactions_data) { JSON.load(File.read(File.join("spec", "fixtures", "stagelink-reactions-page2.json"))) }

        before do
          allow_any_instance_of(Koala::Facebook::API::GraphCollection).to receive(:next_page).and_return(second_page_reactions_data["data"])
          allow_any_instance_of(Array).to receive(:next_page).and_return(nil)
        end

        it "returns a user reaction in the second page" do

          expected_reaction =
            { user_id: "628684973875832",
              page_id: "305736219467790",
              post_id: "305736219467790_1350374218337313",
              post_type: "photo",
              interaction_type: "reaction",
              interaction_subtype: "LIKE"
            }

            expect(subject).to include expected_reaction
        end
      end

      context "when no reactions" do
        before do
          reactions_data.delete("reactions")
        end

        it "returns no reactions" do
          expect(subject.count).to eq 0
        end
      end

    end

    context "when comments" do
      let(:comments_data) { JSON.load(File.read(File.join("spec", "fixtures", "stagelink-comments.json"))) }

      subject { client.interactions_for(comments_data, "comments") }

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

      context "when no comments" do
        before do
          comments_data.delete("comments")
        end

        it "returns no comments" do
          expect(subject.count).to eq 0
        end
      end
    end
  end
end
