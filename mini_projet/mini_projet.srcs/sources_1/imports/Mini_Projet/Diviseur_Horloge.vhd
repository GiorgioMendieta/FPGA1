----------------------------------------------------------------------------------
-- Company: UPMC
-- Designed by: E.PIMOR S.HAMOUM, Spring 2017
-- Revision by: J.DENOULET, Summer 2017
--
-- Module Name: CLK_DIV - Behavioral
-- Project Name: Centrale DCC
-- Target Devices: NEXYS 4 DDR
--
--	Diviseur d'Horloge: 100 MH� --> 1 MHz
-- 
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity CLK_DIV is
  port
  (
    Reset   : in std_logic;   -- Reset Asynchrone
    Clk_In  : in std_logic;   -- Horloge 100 MHz de la carte Nexys
    Clk_Out : out std_logic); -- Horloge 1 MHz de sortie
end CLK_DIV;
architecture Behavioral of CLK_DIV is

  signal Div      : integer range 0 to 49; -- Compteur de cycles d'horloge
  signal Clk_Temp : std_logic;             -- Signal temporaire

begin

  Clk_Out <= Clk_Temp; -- Affectation du Port de Sortie

  process (Clk_In, Reset)
  begin
    -- Reset Asynchrone
    if Reset = '1' then
      Clk_Temp <= '0';
      -- A Chaque Front d'Horloge
    elsif rising_edge (Clk_In) then
      Div <= Div + 1;  -- Incr�mentation du Compteur
      if Div = 49 then -- Inversion du Signal d'Horloge Tous les 50 Cycles
        Div      <= 0;
        Clk_Temp <= not Clk_Temp;
      end if;
    end if;
  end process;

end Behavioral;