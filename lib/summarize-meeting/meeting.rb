require "json"
require "mustache"
require "openai"

module SummarizeMeeting
  class Meeting
    LINE_SUMMARY_PROMPT_TEMPLATE = [
      {
        role: "system",
        content: "You are an assistant summarizing a meeting.",
      },
      {
        role: "system",
        content: "The transcript of the meeting is split into {{chunkCount}} chunks. This is the {{chunkIndex}} chunk.",
      },
      {
        role: "assistant",
        content: "Please provide me with the next chunk of the transcript.",
      },
      {
        role: "user",
        content: "{{chunk}}",
      }
    ]

    CONSOLIDATED_SUMMARY_PROMPT_TEMPLATE = [
      {
        role: "system",
        content: "You are an assistant summarizing a meeting.",
      },
      {
        role: "system",
        content: "Notes about the meeting have been compiled.",
      },
      {
        role: "system",
        content: <<~CONTENT
          Your job is to write a thorough summary of the meeting.
          The summary should start with a brief overview of the meeting.
          The summary should be detailed and should extract any action items that were discussed.
          The summary should be organized into sections with headings and bullet points.
          The summary should include a list of attendees.
          The order of the sections should be overview, attendees, action items, and detailed notes by topic.
        CONTENT
      },
      {
        role: "assistant",
        content: "Please provide me with notes from the meeting.",
      },
      {
        role: "user",
        content: "{{notes}}",
      }
    ]

    def initialize(transcript)
      @transcript = transcript
    end

    attr_reader :transcript

    def summarize

      # Step 1. Split the transcript into lines.
      lines = transcript.split("\n")

      # Step 2. Calculate the maximum chunk size in words.
      max_total_tokens = 4000
      response_token_reserve = 500
      template_tokens = LINE_SUMMARY_PROMPT_TEMPLATE.map { |line| line[:content].split.size }.sum
      max_chunk_tokens = max_total_tokens - response_token_reserve - template_tokens
      words_per_token = 0.7
      max_chunk_word_count = max_chunk_tokens * words_per_token

      # Step 3. Split the transcript into equally sized chunks.
      chunks = split_lines_into_equal_size_chunks(lines, max_chunk_word_count)

      # Step 4. Summarize each chunk.
      previous_chunks_summary = ""
      chunks.each_with_index do |chunk, chunk_index|
        chunk_summary = summarize_chunk(chunk, chunk_index, chunks.size, previous_chunks_summary)
        previous_chunks_summary += chunk_summary
      end

      # Step 5. Write a consolidated summary.
      consolidated_template = CONSOLIDATED_SUMMARY_PROMPT_TEMPLATE
      prompt = Mustache.render(consolidated_template.to_json, { notes: previous_chunks_summary.to_json })
      messages = JSON.parse(prompt)
      response = SummarizeMeeting::Ai.client.chat(
        parameters: {
          model: "gpt-3.5-turbo",
          messages: messages,
        }
      )
      response.dig("choices", 0, "message", "content")
    end

    def summarize_chunk(chunk, chunk_index, chunk_count, previous_chunks_summary)
      template = LINE_SUMMARY_PROMPT_TEMPLATE
      prompt = Mustache.render(template.to_json, { chunkCount: chunk_count, chunkIndex: chunk_index + 1, chunk: chunk.join("\n").to_json })
      messages = JSON.parse(prompt)

      response = SummarizeMeeting::Ai.client.chat(
        parameters: {
          model: "gpt-3.5-turbo",
          messages: messages,
        }
      )
      response.dig("choices", 0, "message", "content")
    end

    def split_lines_into_equal_size_chunks(lines, max_chunk_word_count)
      chunks = []
      chunk = []
      chunk_word_count = 0
      lines.each do |line|
        line_word_count = line.split.size
        if chunk_word_count + line_word_count > max_chunk_word_count
          chunks << chunk
          chunk = []
          chunk_word_count = 0
        end
        chunk << line
        chunk_word_count += line_word_count
      end
      chunks << chunk
      chunks
    end
  end
end