# frozen_string_literal: true

module Geet
  module Github
    # See AbstractIssue for the circular dependency issue notes.
    autoload :AbstractIssue, File.expand_path('abstract_issue', __dir__)

    class Issue < Geet::Github::AbstractIssue
      def self.create(title, description, api_interface)
        api_path = 'issues'
        request_data = { title: title, body: description, base: 'master' }

        response = api_interface.send_request(api_path, data: request_data)

        issue_number, title, link = response.fetch_values('number', 'title', 'html_url')

        new(issue_number, api_interface, title, link)
      end

      # See https://developer.github.com/v3/issues/#list-issues-for-a-repository
      #
      def self.list(api_interface)
        api_path = 'issues'

        response = api_interface.send_request(api_path, multipage: true)

        response.each_with_object([]) do |issue_data, result|
          if !issue_data.key?('pull_request')
            number = issue_data.fetch('number')
            title = issue_data.fetch('title')
            link = issue_data.fetch('html_url')

            result << new(number, api_interface, title, link)
          end
        end
      end
    end
  end
end