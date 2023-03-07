require "spec_helper"
require "pry"

module SummarizeMeeting
  RSpec.describe Meeting do
    let(:transcript) do
      File.read("spec/fixtures/transcripts/transcript-1.txt")
    end

    subject do
      described_class.new transcript
    end

    it "has a transcript" do
      expect(subject.transcript).to eq(transcript)
    end

    describe "#summarize" do
      let(:transcripts) do
        Dir["spec/fixtures/transcripts/*.txt"].map do |file|
          File.read(file)
        end
      end
      it "returns a summary of the meeting" do
        VCR.use_cassette("meeting/summarize", record: :once) do
          transcripts.each do |transcript|
            meeting = described_class.new transcript
            summary = meeting.summarize
            expect(summary).to be_a(String)
          end
        end
      end
    end
  end
end