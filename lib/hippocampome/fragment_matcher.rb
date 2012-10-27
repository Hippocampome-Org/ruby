module Hippocampome

  class FragmentMatcher

    def initialize(pmid_isbn, values, opts={})
      @pmid_isbn = pmid_isbn.to_i
      @values = values
      @opts = opts
    end

    def match
      partial_fragment = Fragment.new(@values)
      @fragments = Fragment[partial_fragment.values]
      @fragments = [@fragments] unless (@fragments.nil? or @fragments.class == Array)
      fragment = select_fragment
      if fragment
        fragment = fragment.first if fragment.class == Array
        return (@opts[:return_model] ? fragment : fragment.id )
      else
        return nil
      end
    end

    def select_fragment
      if @fragments
        @fragments.each do |fragment|
          if fragment.Evidence.any?
            evidence = fragment.Evidence.first
            if evidence.Article.any?
              article = evidence.Article.first
              pmid_isbn = article.pmid_isbn
              return fragment if pmid_isbn == @pmid_isbn
            end
          end
        end
      end
    else
      return nil
    end

  end

end
