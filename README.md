# Projet de compilation : Analyseur lexical avec FLEX

## Informations générales

- **Module :** Compilation
- **Niveau :** Licence 3 Informatique
- **Année universitaire :** 2025–2026
- **Réalisé par :** Mouhamed Sene et Makhmoud Ismaila Diop
- **Encadrant :** Dr. El Malick Ndoye

## Description du projet

Ce projet consiste à développer un analyseur lexical avec FLEX pour traiter un fichier texte contenant les informations des étudiants et leurs notes.

Le programme reconnaît les différents éléments du fichier, détecte les erreurs lexicales, calcule les moyennes des étudiants, attribue des mentions et génère un rapport au format CSV.

## Fonctionnalités

- Reconnaissance des mots-clés, des noms, des matricules et des matières.
- Reconnaissance et vérification des notes comprises entre 0 et 20.
- Détection des caractères interdits et des erreurs lexicales.
- Calcul des moyennes individuelles et de la moyenne générale.
- Attribution des mentions.
- Calcul de statistiques générales.
- Génération du fichier `rapport.csv`.

## Technologies utilisées

- FLEX
- Langage C
- GCC (MinGW)
- Windows 10/11

## Structure du projet

```text
projet-compilation-analyseur-lexical-flex/
├── notes.l
├── valide.txt
├── erreur.txt
├── plusieurs_etudiants.txt
├── README.md
├──notes.lexer.exe
├──lex.yy.c
├──RapportFinal.docx
└── rapport_CSV.csv
```

Les fichiers de test permettent de vérifier le comportement de l'analyseur. D'autres fichiers, comme le rapport du projet, peuvent être ajoutés au dépôt.

## Compilation

### 1. Générer le fichier C

```bash
flex notes.l
```

### 2. Compiler le programme

```bash
gcc lex.yy.c -o notes_lexer.exe
```

## Exécution

Pour tester un fichier valide :

```bash
notes_lexer.exe valide.txt
```

Pour tester un fichier contenant des erreurs :

```bash
notes_lexer.exe erreur.txt
```

Pour tester plusieurs étudiants :

```bash
notes_lexer.exe plusieurs_etudiants.txt
```

## Résultats

Le programme affiche les informations des étudiants, leurs notes, les moyennes, les mentions, les statistiques générales et les erreurs lexicales détectées.

Il génère également un fichier `rapport.csv` contenant les informations suivantes :

`Nom ; Matricule ; Nombre de notes ; Moyenne ; Mention`

## Améliorations possibles

- Ajouter un analyseur syntaxique avec Bison.
- Générer un rapport PDF.
- Développer une interface graphique.
- Ajouter d'autres statistiques.

## Remerciements

Nous remercions notre encadrant, Dr. El Malick Ndoye, pour ses conseils et son accompagnement durant la réalisation de ce projet.
