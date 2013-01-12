<?php
session_start();
$perm = $_SESSION['perm'];
if ($perm == NULL)
	header("Location:error1.html");
	
include ("access_db.php");
include ("function/neuron_page_text_file.php");
include ("function/name_ephys_for_evidence.php");
include ("function/get_abbreviation_definition_box.php");
require_once('class/class.type.php');
require_once('class/class.property.php');
require_once('class/class.synonym.php');
require_once('class/class.evidencepropertyyperel.php');
require_once('class/class.epdataevidencerel.php');
require_once('class/class.epdata.php');
require_once('class/class.synonymtyperel.php');
require_once('class/class.fragmenttyperel.php');
require_once('class/class.fragment.php');
require_once('class/class.evidencefragmentrel.php');
require_once('class/class.typetyperel.php');

require_once('class/class.article.php');
require_once('class/class.author.php');
require_once('class/class.articleevidencerel.php');
require_once('class/class.articleauthorrel.php');

function show_ephys($var)
{
	if($var == 'Vrest')
	{	
		$name_show = 'V<small><sub>rest</small></sub>';
		$flag = 2;
		$units='mV';
	}
	if($var == 'Rin')
	{	
		$name_show = 'R<small><sub>in</small></sub>';
		$flag = 2;
		$units='M&Omega;';
	}
	if($var == 'tm')
	{	
		$name_show = '&tau;<small><sub>m</small></sub>';
		$flag = 1;
		$units='ms';
	}
	if($var == 'Vthresh')
	{	
		$name_show = 'V<small><sub>thresh</small></sub>';
		$flag = 2;
		$units='mV';
	}	
	if($var == 'fast_AHP')
	{	
		$name_show = 'Fast AHP<small><sub>ampl</small></sub>';
		$flag = 2;
		$units='mV';
	}	
	if($var == 'AP_ampl')
	{	
		$name_show = 'AP<small><sub>ampl</small></sub>';
		$flag = 1;
		$units='mV';
	}		
	if($var == 'AP_width')
	{	
		$name_show = 'AP<small><sub>width</small></sub>';
		$flag = 1;
		$units='ms';
	}		
	if($var == 'max_fr')
	{	
		$name_show = 'Max FR';
		$flag = 1;
		$units='Hz';
	}		
	if($var == 'slow_AHP')
	{	
		$name_show = 'Slow APH<small><sub>ampl</small></sub> ';
		$flag = 1;
		$units='mV ';
	}
	if($var == 'sag_ratio')
	{	
		$name_show = 'Sag ratio';
		$flag = 1;
		$units='';
	}

	$res[0]= $name_show;    //name showed
	$res[1] =$flag;
	$res[2] =$units;

	return($res);
}

$id = $_REQUEST['id'];
	
$type = new type($class_type);
$type -> retrive_by_id($id);

$synonym = new synonym($class_synonym);

$property = new property($class_property);

$evidencepropertyyperel = new evidencepropertyyperel($class_evidence_property_type_rel);

$epdataevidencerel = new epdataevidencerel($class_epdataevidencerel);

$epdata = new epdata($class_epdata);

$synonymtyperel = new synonymtyperel('SynonymTypeRel');

$fragmenttyperel = new fragmenttyperel();

$fragment = new fragment($class_fragment);

$evidencefragmentrel = new evidencefragmentrel($class_evidencefragmentrel);

$typetyperel = new typetyperel();


$articleevidencerel = new articleevidencerel($class_articleevidencerel);

$article = new article($class_article);

$articleauthorrel = new articleauthorrel($class_articleauthorrel);

$author = new author($class_author);


if ($text_file_creation)
{
	$name_file = neuron_page_text_file($id, $type, $synonymtyperel, $synonym, $evidencepropertyyperel, $property, $epdataevidencerel, $epdata, $class_type);
	print ("<script type=\"text/javascript\">");
	echo("window.open('$name_file','', 'menubar=yes, width=900, height=700' );");
	print ("</script>");
}
?>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<?php include ("function/icon.html"); ?>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<title><?php print $type->getSubregion(); print " "; print $type->getNickname(); ?></title>
<script type="text/javascript" src="style/resolution.js"></script>
</head>

<body>

<!-- COPY IN ALL PAGES -->
<?php include ("function/title.php"); ?>

		
<div align="center" class="title_3">
	<table width="90%" border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td width="100%">
			<font size='4' color="#990000" face="Verdana, Arial, Helvetica, sans-serif"><?php print $type->getSubregion(); print " "; print $type->getNickname(); ?> </font>
		</td>
	</tr>
	</table>
</div>


<!-- ---------------------- -->

<div align="center">
<table width="85%" border="0" cellspacing="0" cellpadding="0" class='body_table'>
  <tr height="150">
    <td></td>
  </tr>
  <tr>
    <td align="center">
		<!-- ****************  BODY **************** -->		
		<table width="80%" border="0" cellspacing="2" cellpadding="0">
			<tr>
				<td width="20%" align="right">
					<form action="neuron_page.php" method="post" style='display:inline'>
				<!--	<input type="submit" name='text_file_creation' value=' TEXT FILE ' /> -->
					<input type="hidden" name='id' value='<?php print $id; ?>' />
					</form>
				</td>
				<td align="left" width="80%">
				</td>				
			</tr>		
		</table>		
		
		<br />
		
		<!-- TABLE NAME -->		
		<table width="80%" border="0" cellspacing="2" cellpadding="0">
			<tr>
				<td width="20%" align="right" class="table_neuron_page1">
					Name
				</td>
				<td align="left" width="80%" class="table_neuron_page1">
				</td>				
			</tr>
			<tr>
				<td width="20%" align="right">
				</td>
				<td align="left" width="80%" class="table_neuron_page2">
					&nbsp; <?php print $type->getName(); ?> 
				</td>				
			</tr>			
		</table>
		
		<br />
		
		<!-- TABLE SYNONYM -->
		<table width="80%" border="0" cellspacing="2" cellpadding="0">
			<tr>
				<td width="20%" align="right" class="table_neuron_page1">
					Synonym(s)
				</td>
				<td align="left" width="80%" class="table_neuron_page1">
				</td>				
			</tr>			
			<?php			
				// Retrive the Synonim_id from synonymtyperel by ID type:
				$synonymtyperel -> retrive_synonym_id($id);
				$n_syn = $synonymtyperel -> getN_synonym();
				
				for ($i1=0; $i1<$n_syn; $i1++)
				{
					$Synonym_id = $synonymtyperel -> getSynonym_id($i1);
					
					$synonym -> retrive_by_id($Synonym_id);
					$syn = $synonym -> getName();					
					print ("				
					<tr>
						<td width='20%' align='right'>
						</td>
						<td align='left' width='80%' class='table_neuron_page2'>
							 $syn
						</td>					
					</tr>			
					");								
				} 
			?>
		</table>		
		
		<br />	

		<!-- TABLE Morphology -->
		<table width="80%" border="0" cellspacing="0" cellpadding="0">
			<tr>
				<td width="20%" align="center" class="table_neuron_page3">
					Morphology
				</td>			
			</tr>			
		</table>

		<?php
		// retrive propertytyperel.property_id By type.id 
		$evidencepropertyyperel -> retrive_Property_id_by_Type_id($id);
	
		$n = $evidencepropertyyperel -> getN_Property_id();
		$q=0;
		for ($i5=0; $i5<$n; $i5++)
		{
			$property_id[$i5] = $evidencepropertyyperel -> getProperty_id_array($i5);		
		}
		?>
			<!-- SOMA sub-table -->
			<table width="80%" border="0" cellspacing="2" cellpadding="0">
				<tr>
					<td width="20%" align="right" class="table_neuron_page1">
						Soma
					</td>
					<td align="left" width="80%" class="table_neuron_page1">
					</td>				
				</tr>	
				<?php
				// retrive information for SOMA in property table.
				for ($i=0; $i<$n; $i++)
				{
					$property -> retrive_by_id($property_id[$i]);
					$part = $property -> getPart();
					if ($part == 'somata')
					{
						$val = $property -> getVal();
						$rel = $property -> getRel();
						$id_somata = $property -> getID();
						
						$val1 = str_replace(':', '_', $val);
						
						// retrieve UNVETTED:
						$evidencepropertyyperel -> retrive_unvetted($id, $property_id[$i]);
						$unvetted = $evidencepropertyyperel -> getUnvetted();
						
						if ($unvetted == 1)
							$font_col = 'font4_unvetted';
						else
							$font_col = 'font4';
												
						if ($rel == 'in')  // Show only IN
						{	
							print ("
								<tr>
									<td width='20%' align='right'>
									</td>
									<td align='left' width='80%' class='table_neuron_page2'>
									<a href='property_page_morphology.php?id_neuron=$id&val_property=$val1&color=somata&page=1' target='_blank'>
										<font class='$font_col'> $val </font>
									</a> 
									</td>					
								</tr>							
							");										
						}
					}
					else;
				}				
				?>
				</table>

			<!-- Dentrides sub-table -->
			<table width="80%" border="0" cellspacing="2" cellpadding="0">
				<tr>
					<td width="20%" align="right" class="table_neuron_page1">
						Dendrites
					</td>
					<td align="left" width="80%" class="table_neuron_page1">
					</td>				
				</tr>	
				<?php
				// retrive information for DENDRITES in property table.
				for ($i=0; $i<$n; $i++)
				{
					$property -> retrive_by_id($property_id[$i]);
					$part = $property -> getPart();
					if ($part == 'dendrites')
					{
						$val = $property -> getVal();
						$rel = $property -> getRel();
						
						$val1 = str_replace(':', '_', $val);

						// retrieve UNVETTED:
						$evidencepropertyyperel -> retrive_unvetted($id, $property_id[$i]);
						$unvetted = $evidencepropertyyperel -> getUnvetted();
						
						if ($unvetted == 1)
							$font_col = 'font4_unvetted';
						else
							$font_col = 'font4';
													
						if ($rel == 'in')  // Show only IN
						{	
							print ("
								<tr>
									<td width='20%' align='right'>
									</td>
									<td align='left' width='80%' class='table_neuron_page2'>
									
									<a href='property_page_morphology.php?id_neuron=$id&val_property=$val1&color=blue&page=1' target='_blank'>
										<font class='$font_col'> $val </font>
									 </a> 
									</td>					
								</tr>							
							");	
						}										
					}
					else;
				}				
				?>
				</table>

			<!-- Axons sub-table -->
			<table width="80%" border="0" cellspacing="2" cellpadding="0">
				<tr>
					<td width="20%" align="right" class="table_neuron_page1">
						Axons
					</td>
					<td align="left" width="80%" class="table_neuron_page1">
					</td>				
				</tr>	
				<?php
				// retrive information for AXONS in property table.
				for ($i=0; $i<$n; $i++)
				{
					$property -> retrive_by_id($property_id[$i]);
					$part = $property -> getPart();
					if ($part == 'axons')
					{
						$val = $property -> getVal();
						$rel = $property -> getRel();
						
						$val1 = str_replace(':', '_', $val);

						// retrieve UNVETTED:
						$evidencepropertyyperel -> retrive_unvetted($id, $property_id[$i]);
						$unvetted = $evidencepropertyyperel -> getUnvetted();
						
						if ($unvetted == 1)
							$font_col = 'font4_unvetted';
						else
							$font_col = 'font4';
							
						if ($rel == 'in')  // Show only IN
						{												
							print ("
								<tr>
									<td width='20%' align='right'>
									</td>
									<td align='left' width='80%' class='table_neuron_page2'>
									<a href='property_page_morphology.php?id_neuron=$id&val_property=$val1&color=red&page=1' target='_blank'>
										<font class='$font_col'> $val </font>
									 </a> 
									</td>					
								</tr>							
							");	
						}										
					}
					else;
				}				
				?>
				</table>

		<br />	




		<?php
			// TABLE FIGURE ********************************************************************************************************************************
		
			// retrieve the name of figure: --------------------------------------------------
			$fragmenttyperel -> retrive_fragment_id_priority_uno($id);
			$id_fragment = $fragmenttyperel -> getFragment_id();
			
			$fragment ->  retrive_by_id($id_fragment);
			
			$attachment = $fragment -> getAttachment();
			$attachment_type = $fragment -> getAttachment_type();
	
			// change PFD in JPG:
			$attachment_jpg = str_replace('jpg', 'jpeg', $attachment);
			$link_figure = "figure/".$attachment_jpg;	
			// -------------------------------------------------------------------------------		
		
			// Citation figure: ***************************************************************
			$fragment -> retrive_by_id($id_fragment);
			$citation = $fragment -> getQuote();

			//$original_id = $fragment -> getOriginal_id();

			// retrieve article_id from ArticleEvidenceRel by using Evidence_id
			$articleevidencerel -> retrive_article_id($id_fragment);
			$id_article = $articleevidencerel -> getArticle_id_array(0);

			// retrieve all information from article table by using article_id
			$article -> retrive_by_id($id_article) ; 
			$title = $article -> getTitle();
			$pmid_isbn = $article -> getPmid_isbn(); 
			$issue = $article -> getIssue();
			$doi = $article -> getDoi(); 
			$publication = $article -> getPublication();
			$year = $article -> getYear();
			$first_page = $article -> getFirst_page(); 
			$last_page = $article -> getLast_page(); 
			$pmcid = $article -> getPmcid(); 
			$nihmsid = $article -> getNihmsid(); 
			$open_access = $article -> getOpen_access(); 
			$citation_count = $article -> getLast_page(); 
			$volume = $article -> getVolume();
			
			// retrive the Author Position from ArticleAuthorRel
			$articleauthorrel -> retrive_author_position($id_article);
			$n_author = $articleauthorrel -> getN_author_id();
			
			for ($ii3=0; $ii3<$n_author; $ii3++)
				$auth_pos[$ii3] = $articleauthorrel -> getAuthor_position_array($ii3);
				
			if ($auth_pos)	
				sort ($auth_pos);
			
			$name_authors = NULL;
			for ($ii3=0; $ii3<$n_author; $ii3++)
			{
				$articleauthorrel -> retrive_author_id($id_article, $auth_pos[$ii3]);
				$id_author = $articleauthorrel -> getAuthor_id_array(0);
				
				$author -> retrive_by_id($id_author);
				$name_a = $author -> getName_author_array(0);
				
				$name_authors = $name_authors.', '.$name_a;
			}
			$name_authors[0] = '';
			$name_authors = trim($name_authors);				

			$pages= $first_page." - ".$last_page;

			// ********************************************************************************

			
			if ($attachment_jpg != NULL)
			{
			?>
				<table width="80%" border="0" cellspacing="0" cellpadding="0">
					<tr>
						<td width="20%" align="center" class="table_neuron_page3">
							Representative figure
						</td>			
					</tr>	
				</table>
				<table width="80%" border="0" cellspacing="0" cellpadding="0">
					<?php
						// TABLE OF THE ARTICLES: ************************************************************************************************
						
						if (strlen($pmid_isbn) > 10 )
						{									
							$link2 = "<a href='$link_isbn$pmid_isbn' target='_blank'>";
							$string_pmid = "<strong>ISBN: </strong>".$link2;	
						}
						else
						{
							$value_link ='PMID: '.$pmid_isbn;
							$link2 = "<a href='http://www.ncbi.nlm.nih.gov/pubmed?term=$value_link' target='_blank'>";								
							$string_pmid = "<strong>PMID: </strong>".$link2;			
						}
						
						if ($issue != NULL)
							$issue_tot = "($issue),";
						else
							$issue_tot = "";
							
						if ($doi != NULL)
							$doi_tot = "DOI: $doi";
						else
							$doi_tot = "";							
						
						print ("
						<tr>
							<td width='20%' align='right'>
							</td>
							<td align='left' width='80%' class='table_neuron_page2'>
								<font color='#000000'><strong>$title</strong></font> <br>
								$name_authors <br>
								$publication, $year, $volume $issue_tot pages: $pages <br>
								$string_pmid <font class='font13'>$pmid_isbn</font></a>; $doi_tot
							</td>
						</tr>
						");					

					?>
				</table>
				<table>
					<tr>
						<td width="20%" align="center">
							<br />
		
							<?php								
								if ($attachment_type == 'figure')
								{
									print ("<a href='$link_figure' target='_blank'>");
									print ("<img src='$link_figure' border='2' width='30%'>");
									print ("</a>");
								
									print ("<br>");
									print ("<em>$citation</em>");
								}	
								else;							
							?>
						</td>			
					</tr>			
							
				</table>
		
					<br />	<br />
							
			<?php
			}
			
			?>				
							
		
		<!-- TABLE Molecular markers: -->
		<table width="80%" border="0" cellspacing="0" cellpadding="0">
			<tr>
				<td width="20%" align="center" class="table_neuron_page3">
					Molecular markers
				</td>			
			</tr>			
		</table>	
	
			<!-- Positive sub-table -->
			<table width="80%" border="0" cellspacing="2" cellpadding="0">
				<tr>
					<td width="20%" align="right" class="table_neuron_page1">
						Positive
					</td>
					<td align="left" width="80%" class="table_neuron_page1">
					</td>				
				</tr>	
				<?php
				// retrive information for POSITIVE AND WEAK-POSITIVE in property table.
				for ($i=0; $i<$n; $i++)
				{
					$property -> retrive_by_id($property_id[$i]);
					$val = $property -> getVal();
					if ($val == 'positive')
					{
						$part = $property -> getPart();

						// retrieve UNVETTED:
						$evidencepropertyyperel -> retrive_unvetted($id, $property_id[$i]);
						$unvetted = $evidencepropertyyperel -> getUnvetted();
						
						if ($unvetted == 1)
							$font_col = 'font4_unvetted';
						else
							$font_col = 'font4';
						
						print ("
							<tr>
								<td width='20%' align='right'>
								</td>
								<td align='left' width='80%' class='table_neuron_page2'>
								<a href='property_page_markers.php?id_neuron=$id&val_property=$part&page=markers&color=positive' target='_blank' class='$font_col'>
								$part 
								</a>	
								</td>					
							</tr>							
						");										
					}

					else;
				}	
				for ($i=0; $i<$n; $i++)
				{
					$property -> retrive_by_id($property_id[$i]);
					$val = $property -> getVal();
					
					// retrieve UNVETTED:
					$evidencepropertyyperel -> retrive_unvetted($id, $property_id[$i]);
					$unvetted = $evidencepropertyyperel -> getUnvetted();
					
					if ($unvetted == 1)
						$font_col = 'font4_unvetted';
					else
						$font_col = 'font4';
												
					if ($val == 'weak_positive')
					{
						$part = $property -> getPart();
						print ("
							<tr>
								<td width='20%' align='right'>
								</td>
								<td align='left' width='80%' class='table_neuron_page2'>
								<a href='property_page_markers.php?id_neuron=$id&val_property=$part&page=markers&color=weak_positive' target='_blank' class='$font_col'>
								$part (Weak Positive)
								</a>
								</td>					
							</tr>							
						");										
					}
					else;
				}								
				?>
			</table>	
	
			<!-- Negative sub-table -->
			<table width="80%" border="0" cellspacing="2" cellpadding="0">
				<tr>
					<td width="20%" align="right" class="table_neuron_page1">
						Negative
					</td>
					<td align="left" width="80%" class="table_neuron_page1">
					</td>				
				</tr>	
				<?php
				// retrive information for NEGATIVE in property table.
				for ($i=0; $i<$n; $i++)
				{
					$property -> retrive_by_id($property_id[$i]);
					$val = $property -> getVal();
					if ($val == 'negative')
					{
						$part = $property -> getPart();
						
					// retrieve UNVETTED:
					$evidencepropertyyperel -> retrive_unvetted($id, $property_id[$i]);
					$unvetted = $evidencepropertyyperel -> getUnvetted();
					
					if ($unvetted == 1)
						$font_col = 'font4_unvetted';
					else
						$font_col = 'font4';
												
						print ("
							<tr>
								<td width='20%' align='right'>
								</td>
								<td align='left' width='80%' class='table_neuron_page2'>
								<a href='property_page_markers.php?id_neuron=$id&val_property=$part&page=markers&color=negative' target='_blank' class='$font_col'>
								$part
								</a>
								</td>					
							</tr>							
						");										
					}
					else;
				}				
				?>
				</table>	
	
		<br />
		
		
		<!-- TABLE Electrophysiological properties: ******************************************************************************************************************** -->
		<table width="80%" border="0" cellspacing="2" cellpadding="0">
			<tr>
				<td width="20%" align="center" class="table_neuron_page3">
					Electrophysiological properties
				</td>			
			</tr>			
		</table>		

		<table width="80%" border="0" cellspacing="2" cellpadding="0">
		<?php		
      $abbreviations = array();
			for ($i=0; $i<$n; $i++)
			{
				$property -> retrive_by_id($property_id[$i]);
				$predicate = $property -> getRel();
		
				if ($predicate != 'is between');
				else
				{
					$subject = $property -> getPart();

					// Keep only property_id related by id_type;
					// and retrieve id_evidence by these id:
					$evidencepropertyyperel -> retrive_evidence_id($property_id[$i], $id);
					$nn = $evidencepropertyyperel ->getN_evidence_id();	
						
					if ($nn == 0);
					else 
					{
						$evidence_id = $evidencepropertyyperel -> getEvidence_id_array(0);
						
						// Retrieve Epdata from EpdataEvidenceRel by using Evidence ID: 
						$epdataevidencerel -> retrive_Epdata($evidence_id);
						
						$epdata_id = $epdataevidencerel -> getEpdata_id();
            $epdataevidencerel -> setEpdata_id(NULL);
						
						if ($epdata_id == NULL);
						else
						{
							$complete_name = real_name_ephys_evidence($subject);
							$res=show_ephys($subject);

							$epdata -> retrive_all_information($epdata_id);
							$value1 = $epdata -> getValue1();
							$value2 = $epdata -> getValue2();
							$error = $epdata -> getError();
							$n_measurement = $epdata -> getN();
							$istim =  $epdata -> getIstim();	
							$time =  $epdata -> getTime();	
							$std_sem =  $epdata -> getStd_sem();	
              array_push($abbreviations, $std_sem);  // will read these out at end to print abbreviations
							
							// -------------------------------------------------------------------------------------
								// both value1 and value2: 
								if ($value1 && $value2 && !$istim)
								{
									$meas=" [$value1, $value2] $res[2] ";
								}
								// no value2, but has value1 and error:
								if ($value1 && $error && !$istim)
								{
									$meas=" $value1 &plusmn; $error $res[2] ";
								}
								// no value2, but has value1 and error:
								if ($value1 && !$value2 && !$error && !$istim)
								{
									$meas=" $value1 $res[2] ";
								}		
										
								// istim field
								if (($istim) and ($istim != "unknown"))
								{
									if ($value2)
									{
										$mean_value = ($value1 + $value2) / 2;
										$range = "[$value1 - $value2]";
									}
									else
									{
										$mean_value = "$value1";	
										$range = "";
									}
									if ($error)
										$error_value = "&plusmn; $error";
									
									if ($time)
										$time_val = ", $time ms";	
									
									//if ($res[2])
										//$res_2_1 = $res[2];
										
									//if ($istim)
										//$istim_show =" $istim";	
										
									if ($istim)
										$istim_show =", ".$istim;											
				
									$meas=" $mean_value $range $error_value $res[2] $istim_show pA $time_val";
								}				
								
																
								if ($error)
								{
									if ($std_sem == 'std')
										$std_sem_value = ", Mean &plusmn; SD";
									else if ($std_sem == 'sem')	
										$std_sem_value = ", Mean &plusmn; SEM";
									else
										$std_sem_value ='';
										
									$n_error = 1;	
								}
								else
									$std_sem_value ='';
								
								if ($n_measurement)
									$N = "(n=$n_measurement)";							
							
							// -------------------------------------------------------------------------------------

							$id_ephys2 = $epdata_id;						
						}					
					}	

					// retrieve UNVETTED:
					$evidencepropertyyperel -> retrive_unvetted($id, $property_id[$i]);
					$unvetted = $evidencepropertyyperel -> getUnvetted();

					if ($unvetted == 1)
						$font_col = 'font4_unvetted';
					else
						$font_col = 'font4';

					if ($meas)
					{
						print ("
							<tr>
								<td width='20%' align='right'>
								</td>
								<td align='left' width='80%' class='table_neuron_page2'>
								<a href='property_page_ephys.php?id_ephys=$epdata_id&id_neuron=$id&ep=$subject' target='_blank' class='$font_col'>
								<strong>$complete_name ($res[0]):</strong> $meas  $N  $std_sem_value 
								</a>
								</td>					
							</tr>							
							");								
            $meas = NULL;
					}
				}		
			}

      // Abbreviations Box
      $abbreviations = array_unique($abbreviations);
      if ($abbreviations) {  // checks for non-null vals
        $definitions = get_abbreviation_definitions($abbreviations);
        $definition_str = implode('; ', $definitions);
				print ("
				<tr>
					<td width='20%' align='right'>
					</td>
					<td align='left' width='80%' class='table_neuron_page2'>
						<br>
            $definition_str
					</td>					
				</tr>							
				");	
			}

		?>
		</table>	

		<br />
		
		<!-- TABLE Notes: -->
		<?php
			$type -> retrive_notes($id);
			$notes = $type -> getNotes();
		
			if ($notes)
			{
		?>
			<table width="80%" border="0" cellspacing="2" cellpadding="0">
				<tr>
					<td width="100%" align="center" class="table_neuron_page3">
						Notes
					</td>			
				</tr>			
			</table>	
		
			<table width="80%" border="0" cellspacing="2" cellpadding="0">
				<tr>
					<td align='left' width='20%'>	 
					</td>							
					<td align='left' width='80%' class='table_neuron_page2'>
					<?php print $notes; ?>
					</td>		
				</tr>		
			</table>
		<?php
			}
		?>	

		<br />
		
		
		<!-- TABLE Potential postsynaptic connections: -->
		<?php

      // STM Potential Pre-Post List

      // components of html
      function connection_table_head($title) {
        $html = "<table width='80%' border='0' cellspacing='2' cellpadding='0'>
          <tr>
          <td width='100%' align='center' class='table_neuron_page3'>
          $title
          </td>			
          </tr>			
          </table>		

          <table width='80%' border='0' cellspacing='2' cellpadding='0'>
          <tr>
          <td width='20%' align='left'>
          </td>	
          <td width='800%' align='left'>
          <font color='#009900' face='Verdana, Arial, Helvetica, sans-serif' size='2'>Excitatory </font> or  
          <font color='#CC0000' face='Verdana, Arial, Helvetica, sans-serif' size='2'>Inhibitory </font>
          </td>		
          </tr>			
          </table>

          <table width='80%' border='0' cellspacing='2' cellpadding='0'>";
        return $html;
      }

      function get_excit_inhib_font_class($name) {
        if (strpos($name, '(+)')) {
          $font_class = 'font10';
        } else { // is (-)
          $font_class = 'font11';
        }
        return $font_class;
      }

      function name_row($record) {
        $name = to_name($record);
        $id = $record["id"];
        $font_class = get_excit_inhib_font_class($name);
        $html =
          "<tr>
            <td width='20%' align='right'/>
            <td align='left' width='80%' class='table_neuron_page2'>
              <a href='neuron_page.php?id=$id' target='_blank' class='$font_class'>
                $name
              </a>
            </td>					
          </tr>";					
        return $html;
      }

      function connection_table_foot() {
        $html= "</table>
          </br>";
        return $html;
      }


      // functions for the pre-post list

      function result_set_to_array($result_set, $field="all") {
        $records = array();
          while($record = mysql_fetch_assoc($result_set)) {
            if ($field == "all") {  // extract a particular field
              $records[] = $record;
            } else {
              $records[] = $record[$field];
            }
          }
        return $records;
      }

      function get_sorted_records($type_ids) {  // used to sort type records
        $quoted_ids = array_map("quote_for_mysql", $type_ids);
        $query = "SELECT * FROM Type WHERE id IN (" . implode(', ', $quoted_ids) . ') ORDER BY position';
        $result = mysql_query($query);
        $records = result_set_to_array($result);
        //$names = array_map("to_name", $records);
        return $records;
      }

      function to_name($record, $type_prefix='') {  // use type prefix when there are multiple types returned
        $sub_field = "subregion";
        $nickname_field = "nickname";
        $name = $record[$sub_field] . ':' . $record[$nickname_field];
        return $name;
      }

      function quote_for_mysql($str) {
        $quoted = "'$str'";
        return $quoted;
      }

      function filter_types_by_morph_property($axon_dendrite, $parcel_array, $id_field="Type_id") {
        global $morphology_properties_query;
        $quoted_parcels = array_map("quote_for_mysql", $parcel_array);
        $query = $morphology_properties_query . " AND status = 'active' AND subject = '$axon_dendrite'" . " AND object IN " . '(' . implode(', ', $quoted_parcels) . ')';
        //$query = "SELECT * from Type";
        //print "<br><br>TYPE FILTERING QUERY:<br>"; print_r($query);
        $result = mysql_query($query);
        $ids = result_set_to_array($result, $id_field);
        //$names = array_map("to_name", $records);
        return $ids;
      }

      // to build the base set of connections
      $morphology_properties_query =
        "SELECT DISTINCT t.name, t.subregion, t.nickname, p.subject, p.predicate, p.object, eptr.Type_id, eptr.Property_id
        FROM EvidencePropertyTypeRel eptr
        JOIN (Property p, Type t) ON (eptr.Property_id = p.id AND eptr.Type_id = t.id)
        WHERE predicate = 'in'";
      $one_type_query = $morphology_properties_query . " AND eptr.Type_id = '$id'";
      $axon_query = $one_type_query . " AND subject = 'axons'";
      $dendrite_query = $one_type_query . " AND subject = 'dendrites'";

      // to modify the connections
      $explicit_target_and_source_base_query =
        "SELECT
        t1.id as t1_id, t1.subregion as t1_subregion, t1.nickname as t1_nickname,
        t2.id as t2_id, t2.subregion as t2_subregion, t2.nickname as t2_nickname
        FROM TypeTypeRel ttr
        JOIN (Type t1, Type t2) ON ttr.Type1_id = t1.id AND ttr.Type2_id = t2.id";
      $explicit_target_query = $explicit_target_and_source_base_query . " WHERE Type1_id = '$id' AND connection_status = 'positive'";
      $explicit_nontarget_query = $explicit_target_and_source_base_query . " WHERE Type1_id = '$id' AND connection_status = 'negative'";
      $explicit_source_query = $explicit_target_and_source_base_query . " WHERE Type2_id = '$id' AND connection_status = 'positive'";
      $explicit_nonsource_query = $explicit_target_and_source_base_query . " WHERE Type2_id = '$id' AND connection_status = 'negative'";

      // potential targets of output
      $result = mysql_query($axon_query);
      $axon_parcels = result_set_to_array($result, 'object');
      //print "<br><br>AXON PARCELS<br>"; print_r($axon_parcels);

      $possible_targets = filter_types_by_morph_property('dendrites', $axon_parcels);
      //print "<br><br>POSSIBLE TARGETS:<br>"; print_r($possible_targets);

      $result = mysql_query($explicit_target_query);
      $explicit_targets = result_set_to_array($result, "t2_id");
      //print "<br><br>EXPLICIT TARGETS:<br>"; print_r($explicit_targets);

      $result = mysql_query($explicit_nontarget_query);
      $explicit_nontargets = result_set_to_array($result, "t2_id");
      //print "<br><br>EXPLICIT NONTARGETS:<br>"; print_r($explicit_nontargets);

      $net_targets = array_merge(array_diff($possible_targets, $explicit_nontargets), $explicit_targets);
      //print "<br><br>NET TARGETS:<br>"; print_r($net_targets);

      $net_targets = array_unique($net_targets);
      $net_targets = get_sorted_records($net_targets);
      //sort($net_targets);

      // potential sources of input
      $result = mysql_query($dendrite_query);
      $dendrite_parcels = result_set_to_array($result, 'object');
      //print "<br><br>DENDRITE PARCELS<br>"; print_r($dendrite_parcels);

      $possible_sources = filter_types_by_morph_property('axons', $dendrite_parcels);
      //print "<br><br>POSSIBLE SOURCES:<br>"; print_r($possible_sources);

      $result = mysql_query($explicit_source_query);
      $explicit_sources = result_set_to_array($result, "t1_id");
      //print "<br><br>EXPLICIT SOURCES:<br>"; print_r($explicit_sources);

      $result = mysql_query($explicit_nonsource_query);
      $explicit_nonsources = result_set_to_array($result, "t1_id");
      //print "<br><br>EXPLICIT NONSOURCES:<br>"; print_r($explicit_nonsources);

      $net_sources = array_merge(array_diff($possible_sources, $explicit_nonsources), $explicit_sources);
      //print "<br><br>NET SOURCES:<br>"; print_r($net_sources);

      $net_sources = array_unique($net_sources);
      $net_sources = get_sorted_records($net_sources);
      //sort($net_sources);

      // print it out
      print connection_table_head("Potential targets of output");
      foreach($net_targets as $target) { print name_row($target); }
      print connection_table_foot();

      print connection_table_head("Potential sources of input");
      foreach($net_sources as $source) { print name_row($source); }
      print connection_table_foot();
	
		?>
		</table>	

			<br />	<br /> <br />	<br />		

		</td>
	</tr>
</table>		
</div>		

</body>
</html>
