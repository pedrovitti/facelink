require 'csv'

module Facelink

  class Report

    attr_reader :file

    def initialize(file)
      @file = file
    end

    def generate_csv
      csv_file = CSV.open(filepath, 'w') do |csv|
        CSV.foreach(file) do |row|
          page_id = row[0]
          limit = row[1]
          interactions = Facelink::Client.new(page_id, limit, Facelink::FacebookClient.new).interactions
          interactions.each { |interaction| csv << interaction.values }
        end
      end
    end

    def filepath
      input_file = File.basename(file.path, ".*")
      "#{File.dirname(file.path)}/#{input_file}-user-interactions.csv"
    end
  end

end
