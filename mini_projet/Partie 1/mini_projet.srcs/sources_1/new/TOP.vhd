----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04.04.2023 10:48:52
-- Design Name: 
-- Module Name: TOP - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
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

entity TOP is
    Port (  Clk 		      : in std_logic;		-- Horloge 100 MHz
            Reset 		      : in std_logic;		-- Reset Asynchrone
            Interrupteur	   : in STD_LOGIC_VECTOR(7 downto 0);
            SORTIE_DCC        : out std_logic       -- Bit sent     
            );
end TOP;

architecture Behavioral of TOP is

signal Clk1M_s : std_logic;		-- Horloge 1 MHz
signal Reset_Tempo_s : std_logic;	
signal Start_Tempo_s : std_logic;		-- Commande de D�marrage de la Temporisation
signal Fin_Tempo_s : std_logic;		-- Drapeau de Fin de la Temporisation
signal Reset_DDC0_s : std_logic;
signal GO_0_s : std_logic;		-- Commande de D?marrage de la Temporisation
signal FIN_0_s : std_logic;		-- Drapeau de Fin de la Temporisation
signal Reset_DDC1_s : std_logic;
signal GO_1_s : std_logic;		-- Commande de D?marrage de la Temporisation
signal FIN_1_s : std_logic;		-- Drapeau de Fin de la Temporisation
signal Com_REG_s : std_logic_vector(1 downto 0);          -- Command for register
signal DCC_in_s : std_logic;  
signal Trame_DCC_s : std_logic_vector(50 downto 0);	    -- Trame DCC
signal DCC_0_s : std_logic;
signal DCC_1_s : std_logic;
begin

    -- Component MAE
    L0 : entity work.MAE
    port map (  Clk => Clk,
                Clk1M => Clk1M_s,
                Reset => Reset,
                Reset_Tempo => Reset_Tempo_s,
                Start_Tempo => Start_Tempo_s,
                Fin_Tempo => Fin_Tempo_s,
                Reset_DDC0 => Reset_DDC0_s,
                GO_0 => GO_0_s,
                FIN_0 => FIN_0_s,
                Reset_DDC1 => Reset_DDC1_s,
                GO_1 => GO_1_s,
                FIN_1 => FIN_1_s,
                Com_REG => Com_REG_s,
                DCC_in => DCC_in_s);
    
    -- Component REGISTRE_DCC
    L1 : entity work.REGISTRE_DCC
    port map (  Clk => Clk,
                Reset => Reset,
                Trame_DCC => Trame_DCC_s,
                Com_REG => Com_REG_s,
                Bit_out => DCC_in_s);
    
    -- Component COMPTEUR_TEMPO
    L2 : entity work.COMPTEUR_TEMPO
    port map (  Clk => Clk,
                Reset => Reset_Tempo_s,
                Clk1M => Clk1M_s,
                Start_Tempo => Start_Tempo_s,
                Fin_Tempo => Fin_Tempo_s);
    
    -- Component CLK_DIV
    L3 : entity work.CLK_DIV
    port map (  Reset => Reset,
                Clk_In => Clk,
                Clk_Out => Clk1M_s);
    
    -- Component DCC_FRAME_GENERATOR
    L4 : entity work.DCC_FRAME_GENERATOR
    port map (  Interrupteur => Interrupteur,
                Trame_DCC => Trame_DCC_s);
    
    -- Component DCC_FRAME_GENERATOR
    L5 : entity work.DCC_Bit0
    port map (  Clk => Clk,
                Reset => Reset_DDC0_s,
                Clk1M => Clk1M_s,
                GO_0 => GO_0_s,
                FIN_0 => FIN_0_s,
                DCC_0 =>DCC_0_s);
    
    -- Component DCC_FRAME_GENERATOR
    L6 : entity work.DCC_Bit1
    port map (  Clk => Clk,
                Reset => Reset_DDC1_s,
                Clk1M => Clk1M_s,
                GO_1 => GO_1_s,
                FIN_1 => FIN_1_s,
                DCC_1 =>DCC_1_s);
                
    SORTIE_DCC <= DCC_1_s or DCC_0_s;
    
    
end Behavioral;