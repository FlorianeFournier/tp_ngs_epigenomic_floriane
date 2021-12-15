#README

*Etape 1: Téléchargement des données / Script téléchargement.R

Pour télécharger les fichiers brut : Utilisation de wget selon la forme : wget --user'' password'' adress

Pour télécharger les fichiers issues d'une publication : Utilisation de la fonction fastq-dump avec la commande fastq-dump --split-files Nom du fichier

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