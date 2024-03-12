----------------------------------------------------------------------------------
-- Company: SORBONNE UNIVERSITE
-- Designed by: J.DENOULET, Winter 2021
--
-- Module Name: DCC_FRAME_GENERATOR - Behavioral
-- Project Name: Centrale DCC
-- Target Devices: NEXYS 4 DDR
-- 
--	Générateur de Trames de Test pour la Centrale DCC
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity DCC_FRAME_GENERATOR is
    Port ( Interrupteur	: in STD_LOGIC_VECTOR(7 downto 0);	-- Interrupteurs de la Carte
           Trame_DCC 	: out STD_LOGIC_VECTOR(50 downto 0));					-- Trame DCC de Test					
end DCC_FRAME_GENERATOR;

architecture Behavioral of DCC_FRAME_GENERATOR is
Signal Preambule: std_logic_vector(13 downto 0) := "11111111111111";
Signal Start_Bit: std_logic :='0';
Signal Stop_Bit: std_logic :='1';
Signal Champ_Adresse: std_logic_vector(7 downto 0) := "00000001";
Signal Champ_Controle: std_logic_vector(7 downto 0);

begin

-- Génération d'une Trame selon l'Interrupteur Tiré vers le Haut
-- Si Plusieurs Interupteurs Sont Tirés, Celui de Gauche Est Prioritaire

-- Compléter les Trames pour Réaliser les Tests Voulus

process(Interrupteur)
begin
	
	-- Interrupteur 7 Activé
		--> Trame Marche Avant du Train d'Adresse i
if Interrupteur(7)='1' then
        Champ_Controle <= Champ_Adresse xor ("011" & Interrupteur(4 downto 0));
		Trame_DCC <= Preambule &
					 Start_Bit &
					 Champ_Adresse &
					 Start_Bit &
					 "011" & Interrupteur(4 downto 0) &
					 Start_Bit &
					 Champ_Controle &
					 Stop_Bit;

	-- Interrupteur 6 Activé
		--> Trame Marche Arrière du Train d'Adresse i
	elsif Interrupteur(6)='1' then
	    Champ_Controle <= Champ_Adresse xor "010" & Interrupteur(4 downto 0);
		Trame_DCC <= Preambule &
					 Start_Bit &
					 Champ_Adresse &
					 Start_Bit &
					 "010" & Interrupteur(4 downto 0) &
					 Start_Bit &
					 Champ_Controle &
					 Stop_Bit;


	-- Interrupteur 5 Activé
		--> Allumage des Phares du Train d'Adresse i
	elsif Interrupteur(5)='1' then
	   Champ_Controle <= Champ_Adresse xor "10010000";
	
		Trame_DCC <= Preambule &
					 Start_Bit &
					 Champ_Adresse &
					 Start_Bit &
					 "10010000" &
					 Start_Bit &
					 Champ_Controle &
					 Stop_Bit;

	-- Interrupteur 4 Activé
		--> Extinction des Phares du Train d'Adresse i
	elsif Interrupteur(4)='1' then
        Champ_Controle <= Champ_Adresse xor "10000000";
	
		Trame_DCC <= Preambule &
					 Start_Bit &
					 Champ_Adresse &
					 Start_Bit &
					 "10000000" &
					 Start_Bit &
					 Champ_Controle &
					 Stop_Bit;

	-- Interrupteur 3 Activé
		--> Activation du Klaxon (Fonction F11) du Train d'Adresse i
	elsif Interrupteur(3)='1' then
	    Champ_Controle <= Champ_Adresse xor "10100100";
	
		Trame_DCC <= Preambule &
					 Start_Bit &
					 Champ_Adresse &
					 Start_Bit &
					 "10100100" &
					 Start_Bit &
					 Champ_Controle &
					 Stop_Bit;

	-- Interrupteur 2 Activé
		--> Réamorçage du Klaxon (Fonction F11) du Train d'Adresse i
	elsif Interrupteur(2)='1' then
	    Champ_Controle <= Champ_Adresse xor "10100000";
	
		Trame_DCC <= Preambule &
					 Start_Bit &
					 Champ_Adresse &
					 Start_Bit &
					 "10100000" &
					 Start_Bit &
					 Champ_Controle &
					 Stop_Bit;

	-- Interrupteur 1 Activé
		--> Annonce SNCF (Fonction F13) du Train d'Adresse i
	elsif Interrupteur(1)='1' then
	    Champ_Controle <= Champ_Adresse xor "00000001";
	    
		Trame_DCC <= Preambule &
					 Start_Bit &
					 Champ_Adresse &
					 Start_Bit &
					 "11011110" &
					 Start_Bit &
					 "00000001" &
					 Start_Bit &
					 Champ_Controle &
					 Stop_Bit;

	-- Interrupteur 0 Activé
		--> Annonce SNCF (Fonction F13) du Train d'Adresse i
	elsif Interrupteur(0)='1' then
	   Champ_Controle <= (Champ_Adresse)  xor "11011110" xor "00000000";
	
		Trame_DCC <= Preambule &
					 Start_Bit &
					 Champ_Adresse &
					 Start_Bit &
					 "11011110" &
					 Start_Bit &
					 "00000000" &
					 Start_Bit &
					 Champ_Controle &
					 Stop_Bit;

	-- Aucun Interrupteur Activé
		--> Arrêt du Train d'Adresse i
	else 
	   Champ_Controle <= (Champ_Adresse) xor "01100000";
	
		Trame_DCC <= Preambule &
					 Start_Bit &
					 Champ_Adresse &
					 Start_Bit &
					 "01100000" &
					 Start_Bit &
					 Champ_Controle &
					 Stop_Bit;
	end if;
end process;

end Behavioral;

