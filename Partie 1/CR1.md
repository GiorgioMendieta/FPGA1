# Compte Rendu 

## Compteur d'impulsions

Quand le compteur est supérieur à 9, le LED au dessus du R2 doit s'allumer, néanmoins il y avait un erreur sur le fichier de constraint
Nous qvons donc chqngé le pin de R2 à L1 pour que la LED puisse s'allumer.

Ensuite, nous avons géneré le nouvel bitstream et programmé la carte et nous avons constaté que le programme fonctionnait correctement

## Décodeur et Machine à Etats

La hiérarchie du système utilise le compteur impulsionel de la dernière partie, ainsi que deux nouvels fichiers source :

- Selector.vhd : 

Génère en Sortie une Valeur "Limit"
--			- Cette Valeur Depend de Celle d'un Signal d'Entree sur 4 Bits (Count)
--			- Limit Est Remise à Jour A Chaque Appui sur le Bouton Right
--			- Limit Sera Utilisée par une Machine à Etats dans la Suite du TP...

- FSM.vhd : 
Fixe le Comportement des LEDs (Allumées/Eteintes/Clignotement)

Ces trois fichiers fonctionnent ensemble grâce au fichier Top.vhd qui définit la hiérarchie des fichiers.

### Fonctionnement

En fonction de la valeur du compteur, si on appuie sur le bouton R il va selectioner un nouvel état de la FSM (LEDs allumées, éteints, clignotement)

Le fichier Selector avait un problème pour le switch car il nous manquait le when others. puisque les signal std_logic peuvent prendre des valeurs différents de 0-9, il faut donc couvrir tous les cas différents.

### Test 
Nous avons appuyé 3 fois sur le bouton L, puis une fois le bouton R. Les LEDs apparement restaient allumés au lieu de montrer un clignotement visible par les yeux.

Après un reset, les LEDs restaient encore allumés mais avec  une intensité plus base. Nous imaginons que c'était à cause de la nouvelle fréquence de clignotement qui était trop vite.

