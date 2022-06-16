# Bienvenue sur le site de MPPCPRO

Ce modèle est développé par [l'équipe criquet](https://locustcirad.wordpress.com/) du [CBGP](https://www6.montpellier.inrae.fr/cbgp) au [Cirad](https://www.cirad.fr/).

Le travail est principalement réalisé sous le financement de [l'Agence Française pour le Développement](https://www.afd.fr/fr) au travers d'une convention avec la [FAO-CLCPRO](https://www.fao.org/clcpro/fr/) dans le cadre du projet "Consolider les bases de la stratégie de lutte préventive et développer la recherche opérationnelle sur le Criquet pèlerin dans la Région Occidentale" ([voir ici](https://www.fao.org/clcpro/nouvelles/detail/fr/c/1505612/)).

Le modèle bénéficie d'avancées et matériels acquis grâce au projet [PEPPER](https://anrpepper.github.io/) financé par l'[Agence National de la Recherche](http://www.agence-nationale-recherche.fr/en/).

## Visualisation des prévisions du modèle

Sous ce [lien](https://pioucyril.github.io/mppcpro/forecast.html) vous pouvez voir l'actuel prévision du modèle. 

Les geotiffs à 1km de résolution sont téléchargeables [ici](https://github.com/pioucyril/mppcpro/tree/main/img).

## Utilisation du modèle

### Lecture des cartes

Les cartes interactives sur le [site](https://pioucyril.github.io/mppcpro/forecast.html) présentent les valeurs de probabilité de présence du criquet pèlerin pour la décade commençant par la date sélectionnée dans la légende à droite. C'est à dire que sur la période des 10 jours commençant à la date sélectionnée, la carte montre les endroits où il y a le plus de chances d'observer des criquets pèlerin.

Vous pouvez zoomer, vous déplacer et visualiser les valeurs qui sont présentées avec différentes couleurs: du vert au rouge équivalent à une gamme de probabilité de présence de 0.5 à 1.0 (ou 50% à 100%). Les zones où la probabilité de présence est inférieure à 0.5 ne sont pas colorées (carte transparente).

Vous pouvez changer le fond de carte (5 modalités dans la légende à droite), pour faciliter votre visualisation selon vos gouts (fond noir = Mapbox dark, fond clair = Mapbox light, imagerie satelitaire en couleurs naturelles = Mapbox satellite, informations de reliefs et zones d'exceptions= Mapbox outdoor, informations Open Street Map classiques = OSM).

Les boutons + et - en haut à gauche permettent de zoomer ou dézoomer (en plus de l'usage classique de votre interface (écran tactile ou souris)). Le bouton présentant un petit monde dessous permet de revenir au zoom original.

### Précautions à prendre

Lorsque vous visualisez une date de prévision, faites bien attention à ne pas sélectionner plusieurs dates (à droite): cela risque de vous donner une sur-évaluation.

Les sorties du modèle ne sont pas parfaites à 100%. Nous estimons que le taux d'erreur est environ 25%, c'est à dire qu'un site avec une probabilité < 0.5 (sans couleur), peut avoir des criquets avec une chance sur 4. Identiquement, un site noté avec une probabilité > 0.5 (couleurs vert à jaune), peut ne pas avoir de criquets avec une chance sur 4. Nous espérons qu'avec l'amélioration des algorithmes et des précisions des données collectées sur le terrain, nous arriverons à réduire ces taux d'erreurs dans des versions à venir du modèle.

Lorsque vous décidez d'envoyer une équipe de terrain dans un secteur de votre pays, vous pouvez télécharger le geotiff de la décade en cours (bientôt disponible!) et prioritiser les zones à prospecter en fonction de la carte présentant les zones les plus probables à avoir des criquets pèlerin. Néanmoins, les zones sans couleurs sur ces cartes ne sont pas des endroits où les criquets pèlerin ne peuvent pas être: comme dit plus haut, il peut y avoir des criquets tout de même dans ces endroits. Ces cartes ne doivent donc pas être une justification de ne pas prospecter le long des itinéraires entre zones observées comme "les plus favorables".

## Développement du modèle

### Introduction

(l'objectif du modèle.... et les étapes du code...)

### Etapes de préparation des données

(description de toutes les étapes de préparation des données)

### Approche statistique utilisée

(Explication des algorithmes utilisés pour l'ajustement du modèle statistique)

### Création des prévisions

(explication des étapes pour la préparation des cartes de prévisions)


