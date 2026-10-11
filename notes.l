%{
/*===================================================
     PROJET DE COMPILATION
     ANALYSEUR LEXICAL AVEC FLEX

     Module: Compilation
     Niveau: Licence 3 Informatique
     Annee:  2025 - 2026
  
              Membres:
         - Mouhamed Sene
         - Makhmoud I Diop
 
     Encadrant: Dr.El Malick Ndoye

     Description:
     Analyse lexicale d'un fichier cotenant les notes 
     des etudiants. Calcule des moyennes, statistique 
     globale et export des resultats dans un fichier CSV.
=========================================================*/

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

// Declaration des variables

/*==========================
     Statistiques
===========================*/
int nbEtudiants = 0;
int nbNotesTotal = 0;
int nbErreurs = 0;

/*==========================
     Calcules
===========================*/
float sommeNotesEtudiant = 0;
int nbNotesEtudiant = 0;
float sommeGenerale = 0;

/*==========================
     Info etudiant
===========================*/
char nomEtudiant[100];
char matriculeEtudiant[20];
char mention[20];

/*==========================
     Fichier CSV
===========================*/
FILE *rapportCSV;
%}

%option noyywrap
%option yylineno

/*Declaration des expression reguliere*/
DIGIT        [0-9]
LETTRE       [A-Za-z]
MATRICULE_VAL    L3GI{DIGIT}{3}
NOTEVAL      {DIGIT}{1,2}(\.{DIGIT})?
MATIERE      [A-Z]{3,12}
NOM          \"[^\"\n]*\"

%%

"ETUDIANT" {
      nbEtudiants++;
      nbNotesEtudiant = 0;
      sommeNotesEtudiant = 0;

             printf("\n================================================\n");
      printf("Nouvel etudiant\n");
}

"MATRICULE" {
      /* mot-cle reconnu */
}

"NOTE" {
      /* mot-cle reconnu */
}

"FIN_ETUDIANT" {
      printf("\n====================================\n");
      printf("FICHE DE L'ETUDIANT\n");
      printf("\n====================================\n");
      printf("Nom         : %s\n", nomEtudiant);
      printf("Matricule   : %s\n", matriculeEtudiant);
      printf("Nombre de notes   : %d\n", nbNotesEtudiant);
      if(nbNotesEtudiant > 0)
      {
         float moyenne = sommeNotesEtudiant / nbNotesEtudiant;
          
         printf("Moyenne : %.2f\n", moyenne);

          if(moyenne >= 16)
              strcpy(mention, "Tres Bien\n");
          else if(moyenne >= 14)
              strcpy(mention, "Bien\n");
          else if(moyenne >= 12)
              strcpy(mention, "Assez Bien\n");
          else if(moyenne >= 10)
              strcpy(mention, "Passable\n");
          else
          strcpy(mention, "Ajourne\n");
          printf("Mention : %s\n", mention);
         fprintf(
              rapportCSV,
              "%s;%s;%d;%.2f;%s\n",
              nomEtudiant,
              matriculeEtudiant,
              nbNotesEtudiant,
              moyenne,
              mention
         );
       }
       else {
         printf("Aucune note enregistree.\n");
      }
      printf("=====================================\n\n");
}

{MATRICULE_VAL} {
      strcpy(matriculeEtudiant, yytext);
}

{NOM} {
    yytext[strlen(yytext)-1] = '\0';
    strcpy(nomEtudiant, yytext+1);
    printf("Nom : %s\n", nomEtudiant);
}

{MATIERE} {
    /* mot-cle reconnu */
}

{NOTEVAL} {
    float val = atof(yytext);

    if(val < 0 || val > 20) {
      printf("[Erreur lexicale] ligne %d : la note est hors l'intervalle %s\n", yylineno, yytext);
      nbErreurs++;
    }
    else {
       sommeNotesEtudiant += val;
       sommeGenerale += val;
       nbNotesEtudiant++;
       nbNotesTotal++;

       printf("Note enregistree: %.2f\n", val);
    }
}

"#".*   {/* ignore les commentaires */ }

[ \t\r]+ { /* ignore espaces*/ }

\n     { /* gerer ligne */ }

. {
       printf("[Erreur lexical] ligne %d : caractere inattendu '%s'\n", yylineno, yytext);
       nbErreurs++;
}

%%

int main(int argc, char *argv[])
{ 
  /* 1) On verifie si l'utilusateur a bien fournie un fichier*/
  if(argc > 1)
  {
    /* 2) Tantative d'ouverture du fichier*/
    yyin = fopen(argv[1], "r");

    /* 3) Gestion d'erreur si le fichier est introuvable*/
    if(yyin == NULL)
    {
      printf("C'est impossible d'ouvrire le fichier.\n");
      return 1;
    }
  }
   rapportCSV = fopen("rapport_CSV.csv", "w");
   if(rapportCSV == NULL)
   {
     printf("Erreur lors de la creation de rapport.csv\n");
     return EXIT_FAILURE;
   }
    
   fprintf(rapportCSV,
 "===================================================\n");
   fprintf(rapportCSV,
 "         RAPPORT AUTOMATIQUE - PROJET FLEX\n");
   fprintf(rapportCSV,
 "         lICENCE3 INFO - COMPILATION\n");
   fprintf(rapportCSV,
 "===================================================\n");
   fprintf(rapportCSV,
 "Nom;Matricule;NombreNotes;Moyenne;Mention\n");
   
   /* 4) Lancement de l'analyseur lexical*/
   yylex();

   /* 5) les statistiques globales*/
   printf("\n======== STATISTIQUES GLOBALES ========\n");
   printf("Nombre d'etudiants: %d\n", nbEtudiants);
   printf("Nombre total de notes: %d\n", nbNotesTotal);
   if(nbNotesTotal > 0)
   {
     printf("Moyenne generale: %.2f\n", sommeGenerale / nbNotesTotal);
   }
   printf("Nombre d'erreurs: %d\n", nbErreurs);

   printf("\n==========================================\n");
   printf("Analyse lexicale terminee avec succes.\n");
   printf("Merci d'avoir utilise notre analyseur.\n");
   printf("\n==========================================\n");

   fclose(yyin);
   fprintf(rapportCSV, "\n");
   fprintf(rapportCSV, "========================================\n");
   fprintf(rapportCSV, "STATISTIQUE GENERALE\n");
   fprintf(rapportCSV, "Nombre d'etudiant;%d\n", nbEtudiants);
   fprintf(rapportCSV, "Nombre total de notes;%d\n", nbNotesTotal);
    if(nbNotesTotal > 0)
    {
      fprintf(rapportCSV, "Moyenne Generale;%.2f\n", sommeGenerale / nbNotesTotal);
    }
    fprintf(rapportCSV, "Nombre d'erreurs;%d\n", nbErreurs);
   fclose(rapportCSV);


   return EXIT_SUCCESS;
}