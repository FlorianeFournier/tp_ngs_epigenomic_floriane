#Creation de README

*Etape 1: Téléchargement des données 

Pour télécharger les fichiers brut : Utilisation de wget selon la forme : wget --user'' password'' adress

Pour télécharger les fichiers issues d'une publication : Utilisation de la fonction fastq-dump avec la commande fastq-dump --split-files Nom du fichier

Mettre ensuite les données dans le dossier Data (correspondant aux datas brutes): Pour cela on utilise la fonction mv tel que mv quelque chose Data/ On peut pour targeter le quelque chose utiliser *chaine de caractère en commun* 

Pour télécharger les valeurs standards pour A.thaliana: On utilise encore une fois wget lien  On le met ensuite dans Genome_information

Deziper les fastq: Enfin on peut deziper nos données fastq pour cela on utilise la fonction gunzip en mettant gunzip chemin du fichier.