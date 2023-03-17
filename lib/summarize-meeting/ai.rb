module SummarizeMeeting
  module Ai
    class OpenAiError < StandardError; end
    MAX_TOTAL_TOKENS = 8000
    WORDS_PER_TOKEN = 0.75

    @@access_token = ENV["OPENAI_KEY"]
    @@organization_id = ENV["OPENAI_ORG"]

    def self.client
      @client ||= new_client(access_token: access_token, organization_id: organization_id)
    end

    def self.new_client(access_token:, organization_id:)
      OpenAI::Client.new(access_token: access_token, organization_id: organization_id)
    end

    def self.access_token
      @@access_token
    end

    def self.organization_id
      @@organization_id
    end

    def self.access_token=(token)
      @@access_token = token
    end

    def self.organization_id=(id)
      @@organization_id = id
    end

    def self.calculate_token_word_count(token_count)
      (token_count * WORDS_PER_TOKEN.to_f).ceil
    end

    def self.calculate_word_token_count(word_count)
      (word_count / WORDS_PER_TOKEN.to_f).ceil
    end

    def self.chat(messages, client: self.client)
      parameters = {
        model: "gpt-4",
        messages: messages,
      }
      response = client.chat(parameters: parameters)
      content = response.dig("choices", 0, "message", "content")
      if !content
        raise OpenAiError, "No response from OpenAI"
      else
        content
      end
    end
  end
end