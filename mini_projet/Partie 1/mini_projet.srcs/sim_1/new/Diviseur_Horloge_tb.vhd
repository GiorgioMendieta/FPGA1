----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 21.03.2024 10:46:51
-- Design Name: Diviseur_Horloge_tb.vhdl
-- Module Name: Diviseur_Horloge_tb - Behavioral
-- Project Name: Project_FPGA
-- Target Devices: Basys3
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
use IEEE.STD_LOGIC_1164.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Diviseur_Horloge_tb is
  --  Port ( );
end Diviseur_Horloge_tb;

architecture Behavioral of Diviseur_Horloge_tb is

  component CLK_DIV is
    port
    (
      Reset   : in std_logic; -- Reset Asynchrone
      Clk_In  : in std_logic; -- Horloge 100 MHz de la carte Nexys
      Clk_Out : out std_logic -- Horloge 1 MHz de sortie
    );
  end component;

  signal Reset_s   : std_logic := '1'; -- Reset Asynchrone signal
  signal Clk_in_s  : std_logic := '0'; -- Horloge input signal
  signal Clk_out_s : std_logic;        -- Horloge output signal

begin

  -- Component CLK_DIV 
  Clk_Div_1 : CLK_DIV
  port map
  (
    Reset   => Reset_s,
    Clk_in  => Clk_in_s,
    Clk_Out => Clk_Out_s);

  -- Inverse the signal of input horloge
  Clk_in_s <= not Clk_in_s after 1 ns;

  -- Reset off
  Reset_s <= '0' after 10 ns;

end Behavioral;
