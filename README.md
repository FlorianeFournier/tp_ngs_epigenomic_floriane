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

Pour télécharger les fichiers brut non publiés, il nous avons utiliser wget selon la forme : wget --user'' password'' adresse. Pour télécharger les fichiers issues de la publication, nous avons utiliser la fonction fastq-dump avec la commande fastq-dump --split-files Nom du fichier

Enfin les données sur le génome d'A.Thaliana sont télécharger à partir d'une base de donnée sous le format TAIR grâce à la fonction wget.

Mettre ensuite les données dans le dossier Data (correspondant aux datas brutes): Pour cela on utilise la fonction mv tel que mv quelque chose Data/ On peut pour targeter le quelque chose utiliser *chaine de caractère en commun* 

Pour télécharger les valeurs standards pour A.thaliana: On utilise encore une fois wget lien  On le met ensuite dans Genome_information

Deziper les fastq: Enfin on peut deziper nos données fastq pour cela on utilise la fonction gunzip en mettant gunzip chemin du fichier.



*Etape 2: Analyse qualité Script analyse_qualite.R

Analyse qualité des données brutes: Utilisation de la fonction fastqc avec cela on peut analyse toutes les datas tel que fastqc Data/*

Déplacer ensuite les données dans le dossier fastqc avec la fonction mv 

Compiler tous les résultats: Utilisation de la fonction multiqc tel que multiqc. permettant de tout analyser



*Etape 3: Trimming Script Triming.R

Appeler la fonction Trimmomatic: utilisation de la librairie java

Trimmer les données: A partir des données de fastq, boucler sur l'ensemble des données afin de déterminer les fichiers unpair et les fichiers trimmed. Pour les expériences Atac on utilise le primer Nextera,  SLIDINGWINDOW:4:15 et MINLEN:25


*Etape 4: Analyse qualité des fichiers Trimmed Script analyse_qualite.R

On refait la même chose que à l'étape 2 mais avec cette fois les données issues de l'étape 3. 


*Etape 5: Construction d'un index avec le génome de référence Script Mapping.R

Création de l'index: Utilisation de la fonction bowtie2-build en prenant en argument le genome de A.thaliana


*Etape 6: Mapping Script Mapping.R

Mapping des données en comparaison du génome de référence: Utilisation d'un boucle avec comme fonction bowtie2. Bowtie map chacun des reads sur le génome de référence de A.thaliana. On a donc une ligne par read dans le fichier de sortie. 
En sorti on a un fichier sam que l'on va compresser ensuite en un fichier bam. Pour cela, on demande de sortir le fichier sam dans l'outil tools ce qui va permettre de prendre le fichier sam et d'en resortir un fichier bam. 
On trie les reads.



*Etape 7: Filtering Script Filtering.R

Le filtering permet d'enlever le genome non chromosomique, les reads qui n'ont pas mapper, les reds de mauvaise qualité de mapping, les régions blacklistés et les reads dupliqués.
On commence par marquer les duplicats en utilisant MarkDuplicates
On exclue ensuite les régions du genome mitochondrial et chloroplastique pour cela on utilise grep -v pour dire que l'on garde tout sauf les régions (-E pour mettre 2 éléments)
Ensuite on utilise samtools view pour ouvrir les fichier bam et on utilise -L pour afficher les reads mapper que dans des régions que l'on a spécifié puis on filtre les flags dans les séquences avec F et f et q : F pour exclure 1024: duplicat de PCR et f : inclure 3: reads pairé  et q pour la qualité.



*Etape 8: Controle qualité après le filtering Script Qualite_post_filtering.sh


On commence à changer les valeurs des variables 
On définit ensuite les régions d'intérêt, pour cela, creation d'un fichier avec tous les intervals de 1000 autour de TSS, définition des TSS enlever mitochondrie + chroloplaste, garder les genes codant pour des proteines et extraire l'index du premier caractère et du dernier caractère du gene, une fois que l'on a extrait le nom, on regarde le sens du gène. on définit enfin les intersections entre les régions d'intérêt et les TSS

On détermine ensuite les coordonnées dans la séquence et les read qui match

On calcul la distance entre deux reads

On refais la même chose pour les jeux de données que l'on a 




*Etape 9: Determiner les peak Script peak_calling.sh

On commence par indexer les sequences
on utilise la fonction masc2 callpeak pour déterminer les peaks 



*Etape 10: Associer les peaks aux genes Script closest.sh

Utiliser la fonction bedtools closest en faisant attention à ne pas prendre io dans les arguments. 



*Etape 11: Comparer la localisation des peaks Script comparaison_racine_cellule.sh

On compare où sont la peak entre les racines entière et les cellules quiescentes et donc les zones d'accessibilité
On prend en argument les données des cellules quescentes et celles des racines et on fait la différence entre les deux en utilisant la fonction bedtools intersect
en donné on a les peaks qui sont uniquement présent chez les cellules quiescentes 

Création d'un fichier avec tous les peaks uniques aux cellules quiescentes et le nombre de peak en commun chez les 3 échantillons.
Utilisation de la fonction bedtools merge



*Etape 12: Déterminer les peaks en commun chez plus de deux échantillons Script Commun_peak.R

On considère uniquement les données où les peaks sont présent au moins chez deux des trois échantillons. 
Pour ce faire on utilise la fonction write table en prenant comme contrainte le fait que V5 doit être sup ou égale à 2



*Etape 13: Annotations des gènes où il y des peaks commun SCript distance_zero.R

Pour cela on considère les gènes uniquement quand la distance du peak est de 0 par rapport à celle des gènes pour exclure les peaks des régions intergénique
Pour cela on utilise bedtools closest pour déterminer la distance entre les gènes et les peaks dans les données où il y a des peaks dans au moins 2 échantillons. Puis on extraire UNIQUEMENT les peaks associés à des gènes avec une distance de zero en considerant write table et en prenant comme contrainte le fait que V11 doit être égale à 0


*Etape 14: Analyse des proportions de chaque type de localisation Script analyse_proportion.R

On analyse les proportions de chaque type: TSS, full overlap, inclusion, TES et no overlap. 
pour ça au réalise une boucle if considerant la localisation possible des peaks en fonction du gène $

Une fois ces proportions établie; on réalise un graphique avec ggplot
