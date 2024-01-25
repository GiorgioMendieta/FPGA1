----------------------------------------------------------------------------------
-- Company: UPMC
-- Engineer: Julien Denoulet
-- 
-- Create Date:   	Septembre 2016 
-- Module Name:    	Impulse_Count - Behavioral 
-- Project Name: 		TP1 - FPGA1
-- Target Devices: 	Nexys4 / Artix7

-- XDC File:			Impulse_Count.xdc					

-- Description: Compteur d'Impulsions - Version KO
--
--		Compteur d'Impulsions sur 4 bits
--			- Le Compteur s'Incr�mente si on Appuie sur le Bouton Left
--			- Le Compteur se'D�cr�mente si on Appuie sur le Bouton Center
--			- Sup Passe � 1 si le Compteur D�passe 9
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_unsigned.all;

entity IMPULSE_COUNT is
    Port ( Reset : in  STD_LOGIC;								-- Reset Asynchrone
           Button_L : in  STD_LOGIC;							-- Bouton Left
           Button_C : in  STD_LOGIC;							-- Bouton Center
           Clk : in STD_LOGIC;
           Count : out  STD_LOGIC_VECTOR (3 downto 0);	-- Compteur d'Impulsions
           Sup : out  STD_LOGIC);								-- Indicateur Valeur Seuil
end IMPULSE_COUNT;

architecture Behavioral of IMPULSE_COUNT is

signal cpt: std_logic_vector(3 downto 0);		
                                                 
begin                                            
                                                 
                                 
	Count <= cpt;	-- Affichage en Sortie du Compteur


	-------------------------
	-- Gestion du Compteur --
	-------------------------
	
    
    process(Reset, clk)
    variable tmp1, tmp2: std_logic;
	begin
	
		-- Reset Asynchrone
		if reset='1' then 
		  cpt<="0000";
		  tmp1 := '0';                                 
                  tmp2 := '0';
		else 
		  if rising_edge(clk) then
		  
--		      if (Button_L'event and Button_L= '1') then 
--                  cpt <= cpt + 1;            
--              end if;  
--              if (Button_C'event and Button_C= '1') then  
--                  cpt <= cpt - 1;
--              end if;   
		  
              if (Button_L = '1' and tmp1 = '0') then 
                  cpt <= cpt + 1;
                  tmp1 := '1';
              end if;  
              if (Button_C = '1' and tmp2 = '0') then 
                  cpt <= cpt - 1;
                  tmp2 := '1';
              end if;   
              if (Button_L = '0') then 
                  tmp1 := '0';
              end if;
              if (Button_C = '0') then 
                  tmp2 := '0';
              end if;   
		  
           end if;
         end if;
	end process;

	-------------------------
	-- Gestion du Flag Sup --
	-------------------------
	process(Cpt)

	begin
		-- Mise � 1 si CPT D�passe 9. A 0 Sinon...
		if (cpt > 9) then 			
			Sup<='1'; 									
		else 							
			Sup<='0'; 
		end if;
	end process;

end Behavioral;
