# frozen_string_literal: true

require 'spec_helper'

require_relative '../../lib/geet/git/repository'
require_relative '../../lib/geet/services/list_labels'

describe Geet::Services::ListLabels do
  let(:repository) { Geet::Git::Repository.new }

  context 'with github.com' do
    it 'should list the labels' do
      allow(repository).to receive(:remote).with('origin').and_return('git@github.com:donaldduck/geet')

      expected_output = <<~STR
        - bug (#ee0701)
        - enhancement (#84b6eb)
        - technical_debt (#ee0701)
        - top_priority (#d93f0b)
      STR
      expected_label_names = %w[bug enhancement technical_debt top_priority]

      actual_output = StringIO.new
      actual_labels = VCR.use_cassette('github.com/list_labels') do
        described_class.new.execute(repository, output: actual_output)
      end

      actual_label_names = actual_labels.map(&:name)

      expect(actual_output.string).to eql(expected_output)
      expect(actual_label_names).to eql(expected_label_names)
    end
  end

  context 'with gitlab.com' do
    it 'should list the labels' do
      allow(repository).to receive(:remote).with('origin').and_return('git@gitlab.com:donaldduck/testproject')

      expected_output = <<~STR
        - bug (#d9534f)
        - confirmed (#d9534f)
        - critical (#d9534f)
        - discussion (#428bca)
        - documentation (#f0ad4e)
        - enhancement (#5cb85c)
        - suggestion (#428bca)
        - support (#f0ad4e)
      STR
      expected_label_names = %w[bug confirmed critical discussion documentation enhancement suggestion support]

      actual_output = StringIO.new
      actual_labels = VCR.use_cassette('gitlab.com/list_labels') do
        described_class.new.execute(repository, output: actual_output)
      end

      actual_label_names = actual_labels.map(&:name)

      expect(actual_output.string).to eql(expected_output)
      expect(actual_label_names).to eql(expected_label_names)
    end
  end
end