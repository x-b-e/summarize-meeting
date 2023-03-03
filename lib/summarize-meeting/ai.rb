require "openai"

module SummarizeMeeting
  module Ai
    @@access_token = ENV["OPENAI_KEY"]
    @@organization_id = ENV["OPENAI_ORG"]

    def self.client
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
  end
end