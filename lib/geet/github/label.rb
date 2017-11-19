# frozen_string_literal: true

require 'date'

module Geet
  module Github
    class Label
      # Returns a flat list of names in string form.
      def self.list(api_interface)
        api_path = 'labels'
        response = api_interface.send_request(api_path, multipage: true)

        response.map { |label_entry| label_entry['name'] }
      end
    end
  end
end
