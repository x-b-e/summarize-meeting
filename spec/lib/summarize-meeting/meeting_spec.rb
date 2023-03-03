require "spec_helper"

module SummarizeMeeting
  RSpec.describe Meeting do
    let(:transcript) do
      File.read("spec/fixtures/transcript.txt")
    end

    subject do
      described_class.new transcript
    end

    it "has a transcript" do
      expect(subject.transcript).to eq(transcript)
    end

    describe "#summarize" do
      it "returns a summary of the meeting" do
        VCR.use_cassette("meeting/summarize", record: :once) do
          summary = subject.summarize
          expect(summary).to be_a(String)
        end
      end
    end
  end
end