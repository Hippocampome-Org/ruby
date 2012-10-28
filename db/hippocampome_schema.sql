DROP DATABASE IF EXISTS hippocampome;

CREATE DATABASE hippocampome
  DEFAULT CHARACTER SET utf8
  DEFAULT COLLATE utf8_general_ci;

use hippocampome;

### MAIN TABLES

CREATE TABLE Article (
  id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
  pmid_isbn BIGINT,
  pmcid VARCHAR(16),
  nihmsid VARCHAR(16),
  doi VARCHAR(64),
  open_access TINYINT(1),
  dt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  title VARCHAR(512),
  publication VARCHAR(128),
  volume VARCHAR(15),
  first_page INT,
  last_page INT,
  year VARCHAR(15),
  citation_count INT
);

CREATE TABLE Author (
  id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
  dt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  name VARCHAR(64)
);

CREATE TABLE Epdata (
  id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
  dt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  raw VARCHAR(162),
  value1 VARCHAR(32),
  value2 VARCHAR(32),
  error VARCHAR(32),
  std_sem ENUM('std', 'sem'),
  n VARCHAR(32),
  istim VARCHAR(32),
  time VARCHAR(32),
  unit VARCHAR(8),
  location VARCHAR(128)
);

CREATE TABLE Evidence (
  id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
  dt TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE Fragment (
  id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
  original_id INT,
  dt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  quote TEXT,
  page_location VARCHAR(32),
  type ENUM('data', 'protocol', 'animal'),
  attachment VARCHAR(256),
  attachment_type ENUM('figure', 'table')
);

CREATE TABLE Markerdata (
  id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
  dt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  expression VARCHAR(64),
  animal VARCHAR(64),
  protocol VARCHAR(64)
);

CREATE TABLE Property (
  id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
  dt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  subject VARCHAR(45),
  predicate VARCHAR(45),
  object VARCHAR(45)
);

CREATE TABLE Synonym (
  id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
  dt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  name VARCHAR(255)
);

CREATE TABLE Type (
  id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
  position INT,
  dt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  name VARCHAR(255),
  nickname VARCHAR(64),
  status ENUM('active', 'frozen'),
  notes TEXT
);

CREATE TABLE User (
  id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
  password VARCHAR(300),
  permission TINYINT
);

### RELATION TABLES

CREATE TABLE ArticleAuthorRel (
  id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
  dt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  Author_id INT,
  Article_id INT,
  author_pos TINYINT,
  FOREIGN KEY (Author_id) REFERENCES Author(id),
  FOREIGN KEY (Article_id) REFERENCES Article(id)
);

CREATE TABLE ArticleEvidenceRel (
  id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
  dt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  Article_id INT,
  Evidence_id INT,
  FOREIGN KEY (Article_id) REFERENCES Article(id),
  FOREIGN KEY (Evidence_id) REFERENCES Evidence(id)
);

CREATE TABLE ArticleSynonymRel (
  id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
  dt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  Article_id INT,
  Synonym_id INT,
  FOREIGN KEY (Article_id) REFERENCES Article(id),
  FOREIGN KEY (Synonym_id) REFERENCES Synonym(id)
);

CREATE TABLE EpdataEvidenceRel (
  id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
  dt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  Epdata_id INT,
  Evidence_id INT,
  FOREIGN KEY (Epdata_id) REFERENCES Epdata(id),
  FOREIGN KEY (Evidence_id) REFERENCES Evidence(id)
);

CREATE TABLE EvidenceEvidenceRel (
  id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
  dt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  Evidence1_id INT,
  Evidence2_id INT,
  type ENUM('interpretation', 'inference'),
  FOREIGN KEY (Evidence1_id) REFERENCES Evidence(id),
  FOREIGN KEY (Evidence2_id) REFERENCES Evidence(id)
);

CREATE TABLE EvidenceFragmentRel (
  id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
  dt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  Evidence_id INT,
  Fragment_id INT,
  FOREIGN KEY (Evidence_id) REFERENCES Evidence(id),
  FOREIGN KEY (Fragment_id) REFERENCES Fragment(id)
);

CREATE TABLE EvidencePropertyTypeRel (
  id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
  dt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  Evidence_id INT,
  Property_id INT,
  Type_id INT,
  priority INT DEFAULT NULL,
  FOREIGN KEY (Evidence_id) REFERENCES Evidence(id),
  FOREIGN KEY (Property_id) REFERENCES Property(id),
  FOREIGN KEY (Type_id) REFERENCES Type(id),
  unvetted TINYINT(1)
);

CREATE TABLE EvidenceMarkerdataRel (
  id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
  dt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  Evidence_id INT,
  Markerdata_id INT,
  FOREIGN KEY (Evidence_id) REFERENCES Evidence(id),
  FOREIGN KEY (Markerdata_id) REFERENCES Markerdata(id)
);

CREATE TABLE FragmentTypeRel (
  id INT NOT NULL AUTO_INCREMENT PRIMARY KEY, 
  dt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  Fragment_id INT,
  Type_id INT,
  FOREIGN KEY (Fragment_id) REFERENCES Fragment(id),
  FOREIGN KEY (Type_id) REFERENCES Type(id)
);

CREATE TABLE SynonymTypeRel (
  id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
  dt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  Synonym_id INT,
  Type_id INT,
  FOREIGN KEY (Synonym_id) REFERENCES Synonym(id),
  FOREIGN KEY (Type_id) REFERENCES Type(id)
);
