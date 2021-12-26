# README : projet Chromatin state of the organizing center of A. thaliana root meristem

Floriane FOURNIER



## Contexte biologique 

Le développement des organismes multicellulaire passe par une differentiation des cellules souches en fonction de contraintes spaciales et temporelles. Dans ce projet, nous avons étudié cela chez la racine Arabidopsis Thaliana.

La racine d'A.Thaliana présente 5 cellules quiescentes localisées dans le centre quiescent de la racine. C'est le pool de cellules indiférenciées de la racine qui peut possèder de ce fait un épigénome différent de celui de celui du reste des cellules de la racine.

Le projet porte sur la détermination et la comparaison de l'épigénome des cellules différenciées de la racine et des cellules quiescentes de la racine afin d'étudier la différence d'accessibilité de certains gènes selon le type cellulaire considéré.



## Protocole biologique

Le fait que les cellules quiescentes soient en petit nombre dans la racine rend son étude difficile. Cela a été possible avec le développement des outils permettant le single-cell sur les végétaux. 

Pour réaliser ces études, la méthode INTACT est utilisé ici. Cette méthode permet une extraction des noyaux des cellules d'intérêts qui seront dans notre cas GFP+ (car sous contrôle d'un promoteur WOX5).

Une fois extrait, les noyaux sont séquencés en utilisant la méthode de l'ATAC-seq. Cette méthode implique la présence d'une transposase qui vient cliver le génome dans les régions les plus accessibles. 

Ces données permettent d'avoir une représentation de l'accessibilité de l'ensemble du génomes. 



## Téléchargement des données de séquençage - Telechargement.sh

La première étape consiste a télécharger les données de séquençage: racines entières et centres quiescents non publiés mais également des données provenant d'une publication [Combining ATAC-seq with nuclei sorting for discovery of cis-regulatory regions in plant genomes](https://academic.oup.com/nar/article/45/6/e41/2605943). 

Pour télécharger les fichiers brut non publiés, il nous avons utiliser [wget](https://doc.ubuntu-fr.org/wget) selon la forme : wget --user'' password'' adresse. Pour télécharger les fichiers issues de la publication, nous avons utiliser la fonction fastq-dump avec la commande fastq-dump --split-files Nom du fichier

Enfin les données sur le génome d'A.Thaliana sont télécharger à partir d'une [base de donnée](https://plants.ensembl.org/info/data/ftp/index.html) sous le format TAIR grâce à la fonction wget.

Mettre ensuite les données dans le dossier Data (correspondant aux datas brutes): Pour cela on utilise la fonction [mv](http://www.commandeslinux.fr/commande-mv/) tel que mv quelque chose Data/


Enfin on peut deziper nos données fastq pour cela on utilise la fonction [gunzip](https://linuxize.com/post/gunzip-command-in-linux/) qui prend en argument le chemin vers le fichier à deziper.



## Traitement des données

### Etude de la qualité des reads - analyse.qualite.sh

Nous avons commencé par analyser la qualité des données brutes. Les données brutes sont sous le format FastQ. Ainsi, la localisation de chaque nucléotide est traduit par une caractère représentant sa qualité. Meilleur la qualité du nucléotide est, plus sa nature est sur.

Pour cela, nous avons utiliser de la fonction [fastqc](https://hbctraining.github.io/Intro-to-rnaseq-hpc-O2/lessons/02_assessing_quality.html) en prenant en argument l'ensemble des données présente dans le fichier Data.

Les résultats de fastqc sont ensuite compilée. Pour cela, nous avons utilisé de la fonction [multiqc](https://multiqc.info/).

La fonction multiqc renvoie de multiple graphique traduisant la qualité des reads en présence. Ces graphiques traduisent: les statistiques générales, la proportion de reads unique, des histogram de qualité, les scores de qualité de la séquence, le composition en base des séquences, le pourcentage de CG dans la séquence ou encore le niveau de duplication des séquences.


### Ellagage des données - Trimming.sh et analyse de la qualité ensuite - analyse_qualite.sh

Le processus de trimming permet d'enlever des données les séquences de mauvaises qualités ainsi que les séquences des adaptateurs et les duplicats.

Pour faire cela, la fonction [Trimmomatic](http://www.usadellab.org/cms/?page=trimmomatic) est appeler. Attention l'utilisation de cette fonction nécessite de passer par la librairie java. 

A partir des données de fastq, nous avons bouclé sur l'ensemble des données afin de déterminer les fichiers unpair et les fichiers trimmed. Pour les expériences Atac le primer utilisé est Nextera.

On refait la même analyse qualité que à l'étape précédante mais cette fois ci à partir des données trimmer. 


### Aligement des reads sur le génome de référence - Mapping.sh

On réalise un mapping qui consiste à comparer les reads avec le genomes de référence pour regarder où sont localisé les reads.

Le mapping est réalisé avec différent outil de la fonction [bowtie2](http://gensoft.pasteur.fr/docs/bowtie2/2.1.0/)

Pour cela, on commence par créer l'index à l'aide de la fonction bowtie2-build en prenant en argument le genome de A.Thaliana.

On réalise ensuite le mapping des données en comparaison du génome de référence. Pour cela, on utilise une boucle avec comme fonction bowtie2. 

Bowtie mappe chacun des reads sur le génome de référence de A.thaliana. On a donc une ligne par read dans le fichier de sortie. 
En sorti on a un fichier sam que l'on va compresser ensuite en un fichier bam. Pour cela, on demande de sortir le fichier sam dans l'outil tools ce qui va permettre de prendre le fichier sam et d'en resortir un fichier bam. 

On considère qu'un aligement est de bonne qualité à partir de 80% de mapping. Ici nous sommes au dessus de 90%, ce qui nous permet de continuer notre traitement des données l'esprit tranquille quand à la qualité des reads.


### Filtration et selection des reads issues du mapping - Filtering.sh

Le filtering permet d'enlever le genome non chromosomique, les reads qui n'ont pas mapper, les reads de mauvaise qualité de mapping, les régions blacklistés et les reads dupliqués. C'est à dire que l'on enlève les reads qui n'ont pas mappés à l'étape précédente.

On commence par marquer les duplicats en utilisant [MarkDuplicates](https://gatk.broadinstitute.org/hc/en-us/articles/360037052812-MarkDuplicates-Picard-)
On exclue ensuite les régions du genome mitochondrial et chloroplastique pour cela on utilise [grep](https://www.linuxtricks.fr/wiki/grep-afficher-les-lignes-correspondant-a-un-motif-donne).
Ensuite on utilise [samtools](http://www.htslib.org/doc/samtools.html) qui permet d'enlever les reads non pairés, dupliqués, de mauvaise qualité, non mappés ou encore blacklistés.



## Contrôle de la qualité après les étapes de traitement - Qualite_post_filtering.sh

Pour réaliser le contrôle, nous avons utilisé le génome d'A.thaliana annoté, précédement utilisé, où est présenté les informations suivantes: chromosome, gene/transcrit/transposon, coordonnées, gene_id, role du gene.

Nous avons commencé par récupérer les différents TSS présent sur le génome à l'aide des fonctions [bedtools](https://bedtools.readthedocs.io/en/latest/) et [grep](https://www.linuxtricks.fr/wiki/grep-afficher-les-lignes-correspondant-a-un-motif-donne)

Nous avons fait l'étude uniquement sur les fragement de génome ayant passer les tests de traitement avec succés.

A partir des régions d'intéret que l'on a définit, nous avons étudier ces fragments et leur localisation par rapport aux différents TSS. Pour faire cela, nous avons utilisé la fonction bedtools. 

On détermine ensuite les coordonnées dans la séquence et les read qui match avec. 

Enfin, nous avons étudié la taille, la distrubiion et la périodicité des fragments à l'aide de la fonction samtools views. Ces paramètres dépendent de la localisation des nucléosomes sur le génome.



## Analyse des données

### Détermination des piques - peak_calling.sh

La première étape de l'analyse des données consiste en la détermination des piques présent représentant les régions où le nombre de reads est le plus important c'est à dire les régions ouvertes présentes dans le génome. On commence par indexer les sequences puis
on utilise la fonction [macs2](https://hbctraining.github.io/Intro-to-ChIPseq/lessons/05_peak_calling_macs.html) pour déterminer les différents piques en présence.


### Association des piques trouvés avec les gènes d'A.Thaliana - closest.sh

A partir des données brute sur le gènome entier d'A.Thaliana, nous avons filtré les informations afin d'extraire uniquement les données sur les gènes présent dans les noyaux des cellules.

Nous avons ensuite étudier la localisation des piques déterminé à l'étape précédante par rapport au génome d'A.Thaliana en utilisant la fonction bedtools closest. (attention à ne pas prendre io dans les arguments)
Utiliser la fonction [bedtools closest](https://bedtools.readthedocs.io/en/latest/content/tools/closest.html) en faisant attention à ne pas prendre io dans les arguments. 

A partir des informations, nous avons donc accès aux gènes et régions régulatrices du génomes qui sont fortement accessible aux polymérases et facteurs de transcription et donc aux gènes jouant potentiellement un rôle important dans l'identité cellulaire.


### Comparaison de la localisation des piques entre les cellules de racine et cellules quiescentes - comparaison_racine_celluule.sh

On compare où sont la piques entre les racines entière et les cellules quiescentes et donc les zones d'accessibilité
On prend en argument les données des cellules quescentes et celles des racines et on fait la différence entre les deux en utilisant la fonction [bedtools intersect](https://bedtools.readthedocs.io/en/latest/content/tools/intersect.html)
En données on a les picques qui sont uniquement présent chez les cellules quiescentes 

Nous avons ensuite créer un fichier avec tous les picques uniques aux cellules quiescentes et le nombre de peak en commun chez les 3 échantillons.
Pour faire cela, nous avons utiliser de la fonction [bedtools merge](https://bedtools.readthedocs.io/en/latest/content/tools/merge.html)


### Determiner les peaks en commun chez plus de deux échantillons - Commun_peak.R

On considère uniquement les données où les peaks sont présent au moins chez deux des trois échantillons de cellules quiescentes
Pour ce faire on utilise la fonction [write table](https://www.rdocumentation.org/packages/utils/versions/3.6.2/topics/write.table) en prenant comme contrainte le fait que V5 (c'est à dire la colonne 5) doit être sup ou égale à 2 (ici égale à 2 ou à 3). 

Cela permet de faire abstraction des piques uniquement présent dans un des échantillons et donc non signification d'un point de vu biologique.


### Annotations des gènes où il y a des piques commun - distance_zero.R

Pour cela on considère les gènes uniquement quand la distance du pique est de 0 par rapport à celle des gènes, cela permet d'exclure les piques des régions intergénique.

La fonction bedtools closest est utilisée pour déterminer la distance entre les gènes et les piques dans les données où il y a des peaks dans au moins 2 échantillons (données précédement créées). Puis on extraire UNIQUEMENT les peaks associés à des gènes avec une distance de zero en considérant une nouvelle fois la fonction write table et en prenant comme contrainte le fait que V11 (colonne 11) doit être égale à 0.


### Analyse des proportions de chaque type de localisation - analyse_proportion.R

On analyse les proportions de chaque type de localisation possible des piques: présent sur le TSS, overlap totale du gène, inclusion au sein d'un gène, présent sur le TES et pas d'overlap du gène. 

Pour cela au réalise une boucle if considerant la localisation possible des peaks en fonction du gène.

Une fois ces proportions établie; on réalise un graphique avec [ggplot2](https://juba.github.io/tidyverse/08-ggplot2.html).



## Conclusion biologique

Ce traitement informatique permet de mettre en avant un ensemble de gène accessible uniquement dans les cellules quiescentes de la racine et non accessible dans les cellules différenciées des racines. 

A partir de ces données, nous avons utilisé l'outil [IGV (Integrative Genomic Viewer)](https://igv.org/app/) afin de vérifier la présence des piques et leur localisation et l'orientation des gènes par rapport à cela. Cet outil permet juste un contrôle des informations fournies par l'étude informatique. 

A partir des gènes mis en évidence comme accessible uniquement chez les cellules quiescentes, nous avons utilisé le [Gene Ontology Resource database](http://geneontology.org/) qui groupe les gènes que nous avons trouvé en différentes fonction. Nous avons alors comparé les gènes des cellules quiescentes avec celles des racines. A partir de cette étude nous n'avons pas pu mettre en avant clairement une sélection de fonction beaucoup plus importante chez les cellules quiescentes. Cela peut s'expliquer par une multitude de gènes responsable d'un même type de fonction. Il faudrait affiner notre recherche gène par gène à la recherche de meilleures conclusions. 

Une autre partie du groupe de TP a réalisé une étude portant sur la comparaison de l'accessibilité du génome et a pu mettre en évidence que certains gènes sont plus exprimés chez les cellules différenciés tandis que d'autres le sont plus chez les cellules quiescentes. Ils ont pu prendre WOX5 comme exemple de gènes très exprimés chez les cellules quiescentes par rapport aux cellules de la racine.



## Pour aller plus loin

Comme dit précédement, il pourrait être intéressant d'étudier les différences entre les deux types celluaires gènes par gènes et non pas fonction par fonction afin de mettre en évidence des gènes largement plus accessible chez un type cellulaire par rapport à un autre. 

D'autre part, il pourrait être intéressant de faire des catégories de cellules au sein de la racine car le fait de pooler ensemble toutes les cellules pourrait masquer des différences à certains niveaux.


## Crédits et remerciement

Je remercie déjà mes partenaires de TP : Emilie, Lucie, Ewen et Jeremie pour leur patience et leur bonne humeur, ma machine virtuelle pour avoir si souvent décidé de planter et nos encadrants de TP Alice (<3), Marine, Carine et Romain. 

