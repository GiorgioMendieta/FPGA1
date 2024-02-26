--Copyright 1986-2020 Xilinx, Inc. All Rights Reserved.
----------------------------------------------------------------------------------
--Tool Version: Vivado v.2020.2 (win64) Build 3064766 Wed Nov 18 09:12:45 MST 2020
--Date        : Mon Feb 26 09:37:33 2024
--Host        : SE229-10 running 64-bit major release  (build 9200)
--Command     : generate_target TP3_wrapper.bd
--Design      : TP3_wrapper
--Purpose     : IP block netlist
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity TP3_wrapper is
  port (
    led_tri_o : out STD_LOGIC_VECTOR ( 15 downto 0 );
    reset : in STD_LOGIC;
    reset_rtl : in STD_LOGIC;
    sw_tri_i : in STD_LOGIC_VECTOR ( 3 downto 0 );
    sys_clock : in STD_LOGIC
  );
end TP3_wrapper;

architecture STRUCTURE of TP3_wrapper is
  component TP3 is
  port (
    sys_clock : in STD_LOGIC;
    reset : in STD_LOGIC;
    reset_rtl : in STD_LOGIC;
    sw_tri_i : in STD_LOGIC_VECTOR ( 3 downto 0 );
    led_tri_o : out STD_LOGIC_VECTOR ( 15 downto 0 )
  );
  end component TP3;
begin
TP3_i: component TP3
     port map (
      led_tri_o(15 downto 0) => led_tri_o(15 downto 0),
      reset => reset,
      reset_rtl => reset_rtl,
      sw_tri_i(3 downto 0) => sw_tri_i(3 downto 0),
      sys_clock => sys_clock
    );
end STRUCTURE;
