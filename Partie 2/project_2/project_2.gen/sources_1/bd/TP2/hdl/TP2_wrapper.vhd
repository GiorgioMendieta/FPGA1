--Copyright 1986-2020 Xilinx, Inc. All Rights Reserved.
----------------------------------------------------------------------------------
--Tool Version: Vivado v.2020.2 (win64) Build 3064766 Wed Nov 18 09:12:45 MST 2020
--Date        : Mon Feb  5 10:16:20 2024
--Host        : SE229-10 running 64-bit major release  (build 9200)
--Command     : generate_target TP2_wrapper.bd
--Design      : TP2_wrapper
--Purpose     : IP block netlist
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity TP2_wrapper is
  port (
    buttons_tri_i : in STD_LOGIC_VECTOR ( 2 downto 0 );
    led_tri_o : out STD_LOGIC_VECTOR ( 15 downto 0 );
    reset : in STD_LOGIC;
    reset_rtl : in STD_LOGIC;
    sw_tri_i : in STD_LOGIC_VECTOR ( 3 downto 0 );
    sys_clock : in STD_LOGIC
  );
end TP2_wrapper;

architecture STRUCTURE of TP2_wrapper is
  component TP2 is
  port (
    buttons_tri_i : in STD_LOGIC_VECTOR ( 2 downto 0 );
    sys_clock : in STD_LOGIC;
    reset : in STD_LOGIC;
    sw_tri_i : in STD_LOGIC_VECTOR ( 3 downto 0 );
    led_tri_o : out STD_LOGIC_VECTOR ( 15 downto 0 );
    reset_rtl : in STD_LOGIC
  );
  end component TP2;
begin
TP2_i: component TP2
     port map (
      buttons_tri_i(2 downto 0) => buttons_tri_i(2 downto 0),
      led_tri_o(15 downto 0) => led_tri_o(15 downto 0),
      reset => reset,
      reset_rtl => reset_rtl,
      sw_tri_i(3 downto 0) => sw_tri_i(3 downto 0),
      sys_clock => sys_clock
    );
end STRUCTURE;
