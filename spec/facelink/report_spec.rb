require "spec_helper"

describe Facelink::Report do
  let(:file) { File.open(File.join("spec", "fixtures", "input-file.csv")) }
  let(:report) { described_class.new(file) }

  describe ".generate_csv" do
    before do
      facebook_data = JSON.load(File.read(File.join("spec", "fixtures", "stagelink.json")))
      allow_any_instance_of(Koala::Facebook::API).to receive(:get_connections).and_return(facebook_data)
      allow_any_instance_of(Koala::Facebook::API::GraphCollection).to receive(:next_page).and_return(nil)
    end

    subject { report.generate_csv }

    it "generates a csv file" do
      subject

      expect(File.read(report.filepath)).to_not be_nil
    end

  end

end
