# Bienvenue sur le site du MPPCPRO

Le Modèle de Prévision de Présence de Criquet Pèlerin en Région Occidentale (MPPCPRO) est développé par [l'équipe criquet](https://locustcirad.wordpress.com/) du [CBGP](https://www6.montpellier.inrae.fr/cbgp) au [Cirad](https://www.cirad.fr/) pour la [FAO-CLCPRO](https://www.fao.org/clcpro/fr/).

## Visualisation des prévisions du modèle

[Les prévisions actuelles du modèle sont visible en suivant ce lien](https://pioucyril.github.io/mppcpro/forecast.html). 

Les geotiffs à 1km de résolution sont téléchargeables [ici](https://github.com/pioucyril/mppcpro/tree/main/img).

## Utilisation du modèle

### Lecture des cartes

Les cartes interactives sur le [site](https://pioucyril.github.io/mppcpro/forecast.html) présentent les valeurs de probabilité de présence du criquet pèlerin pour la décade commençant par la date sélectionnée dans la légende à droite. C'est à dire que sur la période des 10 jours commençant à la date sélectionnée, la carte montre les endroits où il y a le plus de chances d'observer des criquets pèlerin.

Vous pouvez zoomer, vous déplacer et visualiser les valeurs qui sont présentées avec différentes couleurs: du bleu foncé au jaune équivalent à une gamme de probabilité de présence de 0.5 à 1.0 (ou 50% à 100%); et du rouge clair au rouge foncé pour la probabilité d'observation de transiens de 0.5 à 1.0 (ou 50% à 100%). Les zones où la probabilité de présence est inférieure à 0.5 ne sont pas colorées (carte transparente).

Vous pouvez changer le fond de carte (3 modalités dans la légende à droite), pour faciliter votre visualisation selon vos gouts (fond de carte google map = Google Map, imagerie satellitaire de google map = Satellite, informations Open Street Map classiques = OSM).

Les boutons + et - en haut à gauche permettent de zoomer ou dézoomer (en plus de l'usage classique de votre interface (écran tactile ou souris)). Le bouton présentant un petit monde dessous permet de revenir au zoom original.

### Précautions à prendre

Lorsque vous visualisez une date de prévision, faites bien attention à ne pas sélectionner plusieurs dates (à droite): cela risque de vous donner une surévaluation.

Les sorties du modèle ne sont pas parfaites à 100%. Nous estimons que le taux d'erreur est environ 25%, c'est à dire qu'un site avec une probabilité < 0.5 (sans couleur), peut toujours avoir des criquets, et même un site avec une probabilité = 0 peut en théorie encore en avoir avec 1 chance sur 4. Identiquement, un site noté avec une probabilité = 1 (couleur jaune), peut ne pas avoir de criquets avec une chance sur 4. Nous espérons qu'avec l'amélioration des algorithmes et des précisions des données collectées sur le terrain, nous arriverons à réduire ces taux d'erreurs dans des versions à venir du modèle.

Lorsque vous décidez d'envoyer une équipe de terrain dans un secteur de votre pays, vous pouvez télécharger le geotiff de la décade en cours ([ici](https://github.com/pioucyril/mppcpro/tree/main/img)) et prioritiser les zones à prospecter en fonction de la carte présentant les zones les plus probables à avoir des criquets pèlerin. Néanmoins, les zones sans couleurs sur ces cartes ne sont pas des endroits où les criquets pèlerin ne peuvent pas être: comme dit plus haut, il peut y avoir des criquets tout de même dans ces endroits. Ces cartes ne doivent donc pas être une justification de ne pas prospecter le long des itinéraires entre zones observées comme "les plus favorables".

## Développement du modèle

### Objectifs

L'objectif du modèle est de fournir des cartes tous les 10 jours à une résolution de 1km des zones propices aux développement de populations du criquet pèlerin afin d'orienter les équipes de prospections dans le cadre de la gestion préventive en début de campagne. Les cartes doivent indiquer la probabilité de présence de criquet en fonction de certaines variables environnementales (végétation, température et humidité). Ces probabilités de présence doivent être données pour les 30 jours à venir et idéalement nous devrions pouvoir différencier les probabilités de présence des solitaires et des grégaires (mais le modèle pour la phase n'est pas encore possible à fournir en opérationnel).

### Etapes de préparation du modèle

Il y a 9 grandes étapes dans la préparation du modèle:
 1. Le téléchargement des données acridiennes
 2. La préparation et le filtrage des données pour avoir une base d'observations sur la CLCPRO entre 2000 et 2020 hors périodes d’invasion et en excluant les essaims
 3. Le téléchargement des données satellitaires comme indicatrices des variables environnementales 
 4. La création d’une grille de référence (1km de résolution sur l’ensemble de la CLCPRO)
 5. La standardisation des données satellitaires sur la grille de référence
 6. L’agrégation des données acridiennes sur la grille de référence et par périodes de 10j (3 décades/mois)
 7. L'ajustement des modèles statistiques reliant les données acridiennes aux données environnementales
 8. La préparation de cartes de données environnementales pour faire des projections du modèle
 9. La projection ou prévision du modèle et comparaison aux données observées pour validation

### Etapes de création des prévisions

Une fois le modèle statistique préparé, évalué et validé, la phase d'opérationnalisation comprends 3 grands étapes:
1. Le téléchargement automatisé de nouvelles cartes satellitaire des données environnementales
2. La création automatisé de cartes de prévision en utilisant le modèle statistique et les nouvelles cartes de données environnementales
3. La mise en ligne d'une visualisation (utilisant leaflet, voir [ici le résultat](https://pioucyril.github.io/mppcpro/forecast.html))

### Plus de précisions?

Un rapport détaillant le développement statistique du modèle a été remis à la [FAO-CLCPRO](https://www.fao.org/clcpro/fr/). Si vous vous intéressez aux algorithmes utilisés pour ce développement, contactez le secrétariat de la CLCPRO.


## Financements

Le développement du modèle a été réalisé sous le financement de [l'Agence Française pour le Développement](https://www.afd.fr/fr) au travers d'une convention avec la [FAO-CLCPRO](https://www.fao.org/clcpro/fr/) dans le cadre du projet "Consolider les bases de la stratégie de lutte préventive et développer la recherche opérationnelle sur le Criquet pèlerin dans la Région Occidentale" ([voir ici](https://www.fao.org/clcpro/nouvelles/detail/fr/c/1505612/)).

Le modèle a bénéficié d'avancées scientifiques et matériels acquis grâce au projet [PEPPER](https://anrpepper.github.io/) financé par l'[Agence National de la Recherche](http://www.agence-nationale-recherche.fr/en/) et des avancées sur la télédétection de l'humidité du sol des projets [SMELLS](http://smells.isardsat.com/) financé par l'[ESA](https://www.esa.int/) et [ACCWA](https://accwa.isardsat.space/) financé par l'[Union Européenne](https://marie-sklodowska-curie-actions.ec.europa.eu/).

