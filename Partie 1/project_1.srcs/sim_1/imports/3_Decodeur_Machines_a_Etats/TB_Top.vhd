----------------------------------------------------------------------------------
-- Company: UPMC
-- Engineer: Julien Denoulet
-- 
-- Create Date:   	Juin 2017 
-- Module Name:    	TB_Top - Behavioral 
-- Project Name: 		TP1 - FPGA1
-- Target Devices: 	Nexys4 / Artix7

-- XDC File:			Aucun					
-- Description: Testbench du Top-Level
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity TB_Top is
--  Port ( );
end TB_Top;

architecture Behavioral of TB_Top is

signal Clk : STD_LOGIC:='0';				-- Horloge
signal Reset : STD_LOGIC:='0';				-- Reset Asynchrone
signal Button_L : STD_LOGIC:='0';			-- Bouton Left --> Incrémentation du Compteur
signal Button_C : STD_LOGIC:='0';			-- Bouton Center --> Décrémentation du Compteur 
signal Button_R : STD_LOGIC:='0';			-- Bouton Right --> Mise à Jour des LEDs
signal LED : STD_LOGIC_VECTOR (3 downto 0); -- LEDs


begin

-- Instanciation du Composant YOP
l0: entity work.top
port map(
    Clk => Clk,
    Reset => Reset,
    Button_L => Button_L,
    Button_R => Button_R,
    Button_C => Button_C,
    LED => LED);


-- Gestion de l'Horloge et du Reset Asynchrone
Clk <= not Clk after 5 ns;
Reset <= '1', '0' after 2 ns;

-- Déroulement de la Simulation
    -- 1 Appui sur le Bouton Center (Selection Mode 3 --> LED allumées)
    -- 1 Appui sur le Bouton Right (Validation du Mode 3)
    -- 4 Appuis sur le Bouton Left (Sélection Mode 1 --> LED clignotent)
    -- 1 Appui sur le Bouton Right (Validation du Mode 1)

-- Decrement count
Button_C <= '1' after 1 ms, '0' after 2 ms; -- F

-- Mode validation
Button_R <= '1' after 10 ms, '0' after 11 ms,   -- Count 0,  Sel 00, LED off
            '1' after 170 ms, '0' after 171 ms, -- Count 3,  Sel 01, LED blink 1x
            '1' after 250 ms, '0' after 251 ms, -- Count 7,  Sel 10, LED blink 3x
            '1' after 1000 ms, '0' after 1001 ms; -- Count 10, Sel 11, LED on

-- Increment count
Button_L <= '1' after 100 ms, '0' after 101 ms, -- 0
            '1' after 120 ms, '0' after 121 ms, -- 1
            '1' after 140 ms, '0' after 141 ms, -- 2 
            '1' after 160 ms, '0' after 161 ms, -- 3
            '1' after 180 ms, '0' after 181 ms, -- 4
            '1' after 200 ms, '0' after 201 ms, -- 5
            '1' after 220 ms, '0' after 221 ms, -- 6
            '1' after 240 ms, '0' after 241 ms, -- 7
            
            '1' after 260 ms, '0' after 261 ms, -- 8
            '1' after 280 ms, '0' after 281 ms, -- 9
            '1' after 300 ms, '0' after 301 ms, -- A
            '1' after 320 ms, '0' after 321 ms, -- B
            
            '1' after 340 ms, '0' after 341 ms, -- C
            '1' after 360 ms, '0' after 361 ms; -- D
            

end Behavioral;
