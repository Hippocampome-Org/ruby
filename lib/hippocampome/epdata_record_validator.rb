module Hippocampome

  class EpdataRecordValidator < CSVPort::RecordValidator

    @tests = self.superclass.tests.dup << {
      name: "data is extracted",
      field: :statement,
      test: lambda {
        not (@record[:statement].match(/@_/) or @record[:statement].match(/_@/) or @record[:statement].match(/^\d+\s*$/))
      },
      error_data: lambda {
        {
          type: :not_yet_extracted,
          raw_content: @record[:statement]
        }
      }
    }

    def initialize(record, opts={})
      super
    end

  end

end
