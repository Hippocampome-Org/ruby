require 'csv'


class Article < Sequel::Model(DB[:Article])

  many_to_many :authors, :class=>:Author, :join_table=>:ArticleAuthorRel

  def to_s
    pmid_isbn
  end

  def to_csv(author_list)
    authors_str = authors.inject{|string, au| string += ", #{au.name}"}
    binding.pry
    other_data = values.values_at(:pmid_isbn, :first_page, :last_page, :title, :year, :publication, :volume)
    class_mapping = nil
    packet = 0
    row = [authors_str, *other_data, class_mapping, packet].to_csv
  end

end

class Author < Sequel::Model(DB[:Author])

  many_to_many :Article, :join_table=>:ArticleAuthorRel

  def to_s
    name
  end

end

class Epdata < Sequel::Model(DB[:Epdata])
end

class Evidence < Sequel::Model(DB[:Evidence])
  many_to_many :Article, :join_table=>:ArticleEvidenceRel
  many_to_many :Fragment, :join_table=>:EvidenceFragmentRel
end

DUMMY_EVIDENCE = Evidence.new.save

class Markerdata < Sequel:: Model(DB[:Markerdata])
end

class Fragment < Sequel::Model(DB[:Fragment])
  many_to_many :Evidence, :join_table=>:EvidenceFragmentRel 
  #unrestrict_primary_key
  def to_s
    id
  end

  def eql?(other)  # for using fragments as hash keys
    self.quote == other.quote
  end

  def hash
    quote.hash
  end

end

class Property < Sequel::Model(DB[:Property])
  many_to_many :Type, :join_table => :EvidencePropertyTypeRel

  def to_s
    "%s %s %s" % values.values_at(:subject, :predicate, :object)
  end
end

class Synonym < Sequel::Model(DB[:Synonym])
  def to_s
    name
  end
end

class Type < Sequel::Model(DB[:Type])

  many_to_many :Property, :join_table => :EvidencePropertyTypeRel

  unrestrict_primary_key

  def to_s
    nickname
  end

  def subregion
    values[:nickname].split(':').first
  end

end

class ArticleAuthorRel < Sequel::Model(DB[:ArticleAuthorRel])
end

class ArticleFragmentRel < Sequel::Model(DB[:ArticleFragmentRel])
end

class ArticleSynonymRel < Sequel::Model(DB[:ArticleSynonymRel])
end

class EpdataEvidenceRel < Sequel::Model(DB[:EpdataEvidenceRel])
end 

class EvidenceMarkerdataRel < Sequel::Model(DB[:EvidenceMarkerdataRel])
end 

class EvidenceEvidenceRel < Sequel::Model(DB[:EvidenceEvidenceRel])
end 

class EvidencePropertyTypeRel < Sequel::Model(DB[:EvidencePropertyTypeRel])
end 

class ArticleEvidenceRel < Sequel::Model(DB[:ArticleEvidenceRel])
end 

class EvidenceFragmentRel < Sequel::Model(DB[:EvidenceFragmentRel])
end

class FragmentPropertyTypeRelRel < Sequel::Model(DB[:FragmentPropertyTypeRelRel])
end

class FragmentTypeRel <Sequel::Model(DB[:FragmentTypeRel])
end

class PropertyTypeRel < Sequel::Model(DB[:PropertyTypeRel])
  unrestrict_primary_key
end

class SynonymTypeRel < Sequel::Model(DB[:SynonymTypeRel])
end 

