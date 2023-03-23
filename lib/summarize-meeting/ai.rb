# frozen_string_literal: true

require "openai"

module SummarizeMeeting
  module Ai
    class OpenAIError < StandardError; end
    extend self

    MAX_TOTAL_TOKENS = 8000
    WORDS_PER_TOKEN = 0.75

    def client
      @client ||= new_client(access_token: access_token, organization_id: organization_id)
    end

    def new_client(access_token:, organization_id:)
      OpenAI::Client.new(access_token: access_token, organization_id: organization_id)
    end

    def access_token
      @access_token ||= ENV.fetch("OPENAI_KEY") do
        fail KeyError, "Set OPENAI_KEY in the the ENV or set access_token directly"
      end
    end

    def organization_id
      @organization_id ||= ENV.fetch("OPENAI_ORG") do
        fail KeyError, "Set OPENAI_ORG in the the ENV or set organization_id directly"
      end
    end

    def access_token=(token)
      @access_token = token
    end

    def organization_id=(id)
      @organization_id = id
    end

    def calculate_token_word_count(token_count)
      (token_count * WORDS_PER_TOKEN.to_f).ceil
    end

    def calculate_word_token_count(word_count)
      (word_count / WORDS_PER_TOKEN.to_f).ceil
    end

    def chat(messages, client: self.client)
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
