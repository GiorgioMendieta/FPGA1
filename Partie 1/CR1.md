# Compte Rendu

## 2. Compteur d'impulsions

Quand le compteur est supérieur à 9, le LED au dessus du R2 doit s'allumer, néanmoins il y avait un erreur sur le fichier de constraint
Nous qvons donc chqngé le pin de R2 à L1 pour que la LED puisse s'allumer.

Ensuite, nous avons géneré le nouvel bitstream et programmé la carte et nous avons constaté que le programme fonctionnait correctement

## 3. Décodeur et Machine à Etats

La hiérarchie du système utilise le compteur impulsionel de la dernière partie, ainsi que deux nouvels fichiers source :

- Selector.vhd :

Génère en Sortie une Valeur "Limit"

- Cette Valeur Depend de Celle d'un Signal d'Entree sur 4 Bits (Count)
- Limit Est Remise à Jour A Chaque Appui sur le Bouton Right
- Limit Sera Utilisée par une Machine à Etats dans la Suite du TP...

- FSM.vhd :
Fixe le Comportement des LEDs (Allumées/Eteintes/Clignotement)

Ces trois fichiers fonctionnent ensemble grâce au fichier Top.vhd qui définit la hiérarchie des fichiers.

### Fonctionnement

En fonction de la valeur du compteur, si on appuie sur le bouton R il va selectioner un nouvel état de la FSM (LEDs allumées, éteints, clignotement)

Le fichier Selector avait un problème pour le switch car il nous manquait le when others. puisque les signal std_logic peuvent prendre des valeurs différents de 0-9, il faut donc couvrir tous les cas différents.

### Test sur la carte

Nous avons appuyé 3 fois sur le bouton L, puis une fois le bouton R. Les LEDs apparement restaient allumés au lieu de montrer un clignotement visible par les yeux.

Après un reset, les LEDs restaient encore allumés mais avec  une intensité plus base. Nous imaginons que c'était à cause de la nouvelle fréquence de clignotement qui était trop vite.

### Déroulement

case (Decode) is
    when "00" => Limit   <= (others => '0');
    when "01" => Limit   <= X"096E_3600";  -- 24 000 000 en D�cimal
    when "10" => Limit   <= X"087A_1200";  -- 8 000 000 en D�cimal
    when "11" => Limit   <= (others => '1');
    when others => Limit <= (others => '0');
end case;

Puisque la carte Basys 3 a un horloge à une fréquence de 100 MHz nous avons changé la valeur du compteur de 24M à 100M pour regler plus correctement la fréquence de clignotement des LEDs.

Nous avons donc obtenu 100M decimal en Hex = 0x05f5_e100, et 100M/3 = 33,333,333 en Hex = 0x01fc_a055 pour le compteur.
Ensuite, nous avons ajouté 0x2 au MSB car la signal codifie les deux bits les plus forts pour choisir l'état de la FSM grâce au selector "10".

case (Decode) is
    when "00" => Limit   <= (others => '0');
    when "01" => Limit   <= X"25F5_E100"; -- 100 000 000 en D�cimal
    when "10" => Limit   <= X"21FC_A055"; -- 33 333 333 en D�cimal
    when "11" => Limit   <= (others => '1');
    when others => Limit <= (others => '0');
end case;

Il a fallu également changer la taille du seuil pour un std_logic_vector de 28 bits afin de stocker correctement la valeur requise.

En plus, nous avons fait des changements dans le fonctionnement de la machine à états.

D'abord, dans la condition des fronts montants d'horloge, nous avons ajouté une condition (Cpt < Seuil). Si le compteur depassé le seuil, on le remetait à zéro.

En deuxième lieu, la machine à états originale manquait des transitions.

[VISUALISATION FSM ORIGINALE]

Nous avons donc corrigé les états en ajoutant des transitions supplémentaires.

[VISUALISATION FSM MODIFIÉ]

### Simulation

[CAPTURES D'ECRAN DES SIMULATIONS]
