# frozen_string_literal: true

require "openai"

module SummarizeMeeting
  module Ai
    module OpenAIException; end
    class OpenAIError < StandardError
      include OpenAIException
    end
    class OpenAiResponseFailure < OpenAIError; end
    class OpenAiNoResponseError < OpenAIError; end
    class OpenAiRetryableError < OpenAIError; end
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
      return @access_token if defined?(@access_token)
      @access_token = ENV.fetch("OPEN_AI_API_KEY") do
        fail KeyError, "Set OPEN_AI_API_KEY in the the ENV or set access_token directly"
      end
    end

    def organization_id
      return @organization_id if defined?(@organization_id)
      @organization_id = ENV.fetch("OPEN_AI_ORGANIZATION_ID", nil)
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

    # @raise on response error or no expected response content
    def chat(messages, client: self.client)
      parameters = {
        model: "gpt-4",
        messages: messages,
      }
      response = nil
      begin
        response = client.chat(parameters: parameters)
      rescue => exception
        handle_request_error(exception)
      else
        is_failure = !response.success?
        if is_failure
          log_response_failure(response)
          raise OpenAiResponseFailure, "Failed response from OpenAI"
        else
          content = response.dig("choices", 0, "message", "content")
          if !content
            raise OpenAiNoResponseError, "No response from OpenAI in #{response.body}"
          else
            content
          end
        end
      end
    end

    def notify_error(exception, message, **options)
      if exception_notifier
        exception_notifier.call(exception, message, **options)
      else
        warn "#{exception.inspect}: #{message}. options=#{options.inspect}"
      end
    end

    # responds to call(exception, message, **options)
    def exception_notifier=(exception_notifier)
      @exception_notifier = exception_notifier
    end

    def exception_notifier
      return @exception_notifier if defined?(@exception_notifier)
      nil
    end

    def handle_request_error(exception)
      is_openai_error =
        case exception.inspect
        when /Connection refused/i then true
        when /Connection reset/i then true
        when /Connection timed out/i then true
        when /Could not connect/i then true
        when /EOFError/i then true
        when /Errno::ECONNREFUSED/i then true
        when /Errno::ECONNRESET/i then true
        when /Net::OpenTimeout/i then true
        when /Net::ReadTimeout/i then true
        when /OpenSSL::SSL::SSLError/i then false
        when /Server is unavailable or does not exist/i then true
        when /Unable to connect/i then true
        when /closed stream/i then true
        when /connect timed out/i then true
        when /end of file reached/i then true
        when /execution expired/i then true
        else false
        end
      if is_openai_error
        exception.extend OpenAIException
      end
      raise
    end

    def log_response_failure(response)
      response_details = {
        # https://github.com/jnunemaker/httparty/blob/v0.21.0/lib/httparty/response.rb#L53-L56
        response: response.to_s,
      }
      if response.class.name.match?(/HTTParty::Response/)
        response_details.merge!(
          raw_request: response.request.inspect,
          raw_response: response.response.inspect,
          response_body: response.body,
          response_code: response.code,
          response_headers: response.headers,
          # marshal_dump_base_64: Base64.encode64(response._dump(1)), # so it can be encoded as JSON
        )
      end
      notify_error(
        nil, # there's no exception object
        "Logging OpenAI Error",
        **response_details
      )
    rescue => exception
      notify_error(
        exception,
        "Unhandled error in #{name}##{__callee__}",
        response: response.inspect,
      )
    end
  end
end
