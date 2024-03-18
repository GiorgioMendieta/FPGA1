----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11.03.2024 12:13:55
-- Design Name: 
-- Module Name: Generateur_Trames_TB - Behavioral
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
use IEEE.STD_LOGIC_1164.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Generateur_Trames_TB is
end Generateur_Trames_TB;

architecture Behavioral of Generateur_Trames_TB is
  signal Interrupteur   : std_logic_vector(7 downto 0);
  signal Trame_DCC      : std_logic_vector(50 downto 0);
  signal clk            : std_logic := '0';
  signal reset, Bit_out : std_logic;
  signal COM_REG        : std_logic_vector(1 downto 0);

begin

  l0 : entity work.DCC_FRAME_GENERATOR
    port map
    (
      Interrupteur => Interrupteur,
      Trame_DCC    => Trame_DCC);
  Trame_DCC    => Trame_DCC);

  l1 : entity work.REGISTRE_DCC
    port
    map(clk => clk,
    reset   => reset,
    COM_REG => COM_REG,
    Bit_out => Bit_out,
    Trame   => Trame_DCC);

  Clk          <= not Clk after 5 ns;
  Reset        <= '1', '0' after 2 ns;
  COM_REG      <= "10", "01" after 10 ns;
  Interrupteur <= X"00", X"01" after 500 ns;
