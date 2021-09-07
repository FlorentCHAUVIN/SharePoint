# Quelques astuces sur les vues

## Visualiser de manière dynamique les élements de l'année en cours, à venir ou précédentes

Il faut tout d'abord soit avoir une colonne de type texte avec l'année soit une colonne de type date faisant référence à la date sur laquelle vous souhaitez filtrer.
Ensuite il suffit de suivre le mode opératoire suivant 

* Créer deux colonnes calculées "Début d'année" et "Fin d'année" de type et de format Date uniquement avec les formules suivantes :
* Pour "Début d'année" : 
    * =DATE(YEAR([MaColonneDate]);1;1)
    * ou
    * =DATE([MaColonneAnneEnTexte];1;1)
* Pour "Fin d'année":
    * =DATE(YEAR([MaColonneDate]);12;31)
    * ou
    * =DATE([MaColonneAnneEnTexte];12;31)
* Créer ou modifier votre vue "Année en cours" avec le filtre suivant
    * "Fin d'année" est supérieure ou égale à [Aujourd'hui]
    * ET
    * "Début d'année" est inférieure ou égale à [Aujourd'hui]

Vous pouvez de la même manière créer deux vues supplémentaires:

* Créer ou modifier votre vue "Année à venir" avec le filtre suivant
    * "Fin d'année" est supérieure ou égale à [Aujourd'hui]
    * ET
    * "Début d'année" est supérieure ou égale à [Aujourd'hui]


* Créer ou modifier votre vue "Année précédente" avec le filtre suivant
    * "Fin d'année" est inférieure ou égale à [Aujourd'hui]
    * ET
    * "Début d'année" est inférieure ou égale à [Aujourd'hui]