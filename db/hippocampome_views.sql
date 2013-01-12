### VIEWS

use hippocampome;

CREATE VIEW article_with_author AS
(
  SELECT pmid_isbn, GROUP_CONCAT(au.name SEPARATOR ', ') as authors, year, title, publication, volume, first_page, last_page, Article_id
  FROM ArticleAuthorRel aar
  JOIN (Article ar, Author au) ON (aar.Article_id = ar.id AND aar.Author_id = au.id)
  GROUP BY ar.id
  ORDER BY aar.author_pos
);

CREATE VIEW property_with_type AS
(
  SELECT DISTINCT t.name, t.nickname, p.subject, p.predicate, p.object, eptr.Type_id, eptr.Property_id
  FROM EvidencePropertyTypeRel eptr
  JOIN (Property p, Type t) ON (eptr.Property_id = p.id AND eptr.Type_id = t.id)
);

CREATE VIEW evidence_with_markerdata as
(
  SELECT Evidence_id, Markerdata.id as Markerdata_id, expression, animal, protocol
  FROM EvidenceMarkerdataRel emr
  JOIN (Evidence, Markerdata) ON (Evidence.id = emr.Evidence_id AND Markerdata.id = emr.Markerdata_id)
);

CREATE VIEW evidence_with_epdata as
(
  SELECT Evidence_id, Epdata.id as Epdata_id, raw, value1, value2, error, std_sem, n, istim, time
  FROM EpdataEvidenceRel eer
  JOIN (Evidence, Epdata) ON (Evidence.id = eer.Evidence_id AND Epdata.id = eer.Epdata_id)
);

CREATE VIEW evidence_with_fragment as
(
  SELECT Evidence_id, Fragment.id as Fragment_id, original_id, quote, page_location, type, attachment, attachment_type
  FROM EvidenceFragmentRel efr
  JOIN (Evidence, Fragment) ON (Evidence.id = efr.Evidence_id AND Fragment.id = efr.Fragment_id)
);


CREATE VIEW figure_fragment_with_type as 
(
  SELECT Type.id as Type_id, Type.name, Fragment.id as Fragment_id, Fragment.quote, Fragment.page_location, Fragment.attachment
  FROM FragmentTypeRel ftr
  JOIN (Fragment, Type) ON (Fragment.id = ftr.Fragment_id AND Type.id = ftr.Type_id)
);

CREATE VIEW synonym_with_type as
(
  SELECT Type.id as Type_id, Type.name, nickname, Synonym.name as synonym, Synonym.id 
  FROM SynonymTypeRel str
  JOIN (Synonym, Type) ON (Synonym.id = str.Synonym_id AND Type.id = str.Type_id)
);

CREATE VIEW synonym_with_article as
(
  SELECT Article.* , synonym.name as synonym
  FROM ArticleSynonymRel sar
  JOIN (Synonym, Article) ON (Synonym.id = sar.Synonym_id AND Article.id = sar.Article_id)
);

CREATE VIEW article_with_evidence as
(
  SELECT a.id as Article_id, a.pmid_isbn, a.title, a.publication, a. volume, a.first_page, a.last_page, a.year, Evidence.id as Evidence_id
  FROM ArticleEvidenceRel aer
  JOIN (Article a, Evidence) ON (a.id = aer.Article_id AND Evidence.id = aer.Evidence_id)
);

CREATE VIEW article_with_fragment as
(
  SELECT awe.Article_id, awe.pmid_isbn, awe.first_page, awe.title, awe.year, ewf.*
  FROM article_with_evidence awe
  JOIN evidence_with_fragment ewf ON awe.Evidence_id = ewf.Evidence_id
);

CREATE VIEW property_with_type_linked_sub AS
(
  SELECT DISTINCT t.name, t.nickname, p.subject, p.predicate, p.object, eptr.Type_id, eptr.Property_id, eptr.Evidence_id as Evidence1_id, Evidence2_id, a.pmid_isbn as secondary_pmid
  FROM EvidencePropertyTypeRel eptr
  JOIN (Property p, Type t, Article a, EvidenceEvidenceRel eer) ON (eptr.Property_id = p.id AND eptr.Type_id = t.id AND eptr.Article_id = a.id AND eptr.Evidence_id = eer.Evidence1_id)
);

CREATE VIEW property_with_type_linked as
(
  SELECT pwtls.*, awe.pmid_isbn as primary_pmid, ewf.quote, ewf.original_id, ewf.Fragment_id as Fragment_id
  FROM property_with_type_linked_sub pwtls
  JOIN article_with_evidence awe ON (Evidence2_id = awe.Evidence_id)
  JOIN evidence_with_fragment ewf ON (ewf.Evidence_id = Evidence2_id)
);

CREATE VIEW property_with_type_and_evidence AS
(
  SELECT  t.name, t.nickname, p.subject, p.predicate, p.object, eptr.Type_id, eptr.Property_id, eptr.Evidence_id
  FROM EvidencePropertyTypeRel eptr
  JOIN (Property p, Type t) ON (eptr.Property_id = p.id AND eptr.Type_id = t.id)
);

CREATE VIEW epdata_with_type as
(
  SELECT *
  FROM property_with_type_and_evidence pwtae
  JOIN evidence_with_epdata ewe USING (Evidence_id)
);


CREATE VIEW markerdata_with_type as
(
  SELECT *
  FROM property_with_type_and_evidence pwtae
  JOIN evidence_with_markerdata ewe USING (Evidence_id)
);

CREATE VIEW property_with_type_and_fragment as
(
  SELECT *
  FROM property_with_type_and_evidence pwtae
  JOIN article_with_fragment awf USING(Evidence_id) 
);

CREATE VIEW property_with_type_and_fragment_marker as
(
  SELECT pwtae.*, awf.quote, awf.original_id, awf.pmid_isbn, awf.title
  FROM property_with_type_and_evidence pwtae
  JOIN evidenceevidencerel eer ON eer.Evidence1_id = pwtae.Evidence_id
  JOIN article_with_fragment awf ON eer.Evidence2_id = awf.Evidence_id
);
