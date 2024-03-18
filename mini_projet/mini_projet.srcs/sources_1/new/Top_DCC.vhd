----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 18.03.2024 09:04:25
-- Design Name: 
-- Module Name: Top_DCC - Behavioral
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

entity Top_DCC is
  port
  (
    clk          : in std_logic;
    reset        : in std_logic;
    Interrupteur : std_logic_vector(7 downto 0)
  );
end Top_DCC;

architecture Behavioral of Top_DCC is
  signal Trame_DCC                : std_logic_vector(50 downto 0);
  signal bit_out                  : std_logic;
  signal GO_0, GO_1, FIN_0, FIN_1 : std_logic;
  signal clk1M                    : std_logic;
  signal Start_Tempo, Fin_Tempo   : std_logic;
  signal DCC_0, DCC_1             : std_logic;
  signal load, shift              : std_logic;

begin

  l0 : entity work.DCC_FRAME_GENERATOR
    port map
    (
      Interrupteur => Interrupteur,
      Trame_DCC    => Trame_DCC
    );
  );

  l1 : entity work.REGISTRE_DCC
    port
    map(
    clk     => clk,
    reset   => reset,
    load    => load,
    shift   => shift,
    bit_out => bit_out,
    Trame   => Trame_DCC
    );

  l2 : entity work.MAE
    port
    map(
    Reset       => reset,
    Clk         => clk,
    Go_0        => GO_0,
    Go_1        => GO_1,
    Fin_0       => FIN_0,
    Fin_1       => FIN_1,
    Start_Tempo => Start_Tempo,
    Fin_Tempo   => Fin_Tempo,
    DCC_in      => bit_out,
    Load_DCC    => load,
    Shift_DCC   => shift
    );

  l3 : entity work.COMPTEUR_TEMPO
    port
    map(
    reset       => reset,
    Clk         => clk,
    Clk1M       => Clk1M,
    Start_Tempo => Start_Tempo,
    Fin_Tempo   => Fin_Tempo
    );

  l4 : entity work.DCC_bit_0
    port
    map(
    reset     => reset,
    Clk       => clk,
    Tempo_clk => Clk1M,
    Go        => GO_0,
    Fin       => FIN_0,
    DCC_Out   => DCC_0
    );

  l5 : entity work.DCC_bit_1
    port
    map(
    reset     => reset,
    Clk       => clk,
    Tempo_clk => Clk1M,
    Go        => GO_1,
    Fin       => FIN_1,
    DCC_Out   => DCC_1
    );

  l6 : entity work.CLK_DIV
    port
    map(
    reset   => reset,
    Clk_In  => clk,
    Clk_Out => clk1M
    );