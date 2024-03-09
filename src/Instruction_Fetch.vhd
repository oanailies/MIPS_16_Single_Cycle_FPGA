----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/21/2023 07:17:49 PM
-- Design Name: 
-- Module Name: Instruction_Fetch - Behavioral
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
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


entity Instruction_Fetch is
 Port ( signal clk: in std_logic;
        signal jump: in std_logic;
        signal jump_adress: in std_logic_vector(15 downto 0);
        signal branch_adress:in std_logic_vector(15 downto 0);
        signal PC_SRC:in std_logic_vector(1 downto 0);
        signal rst:in std_logic;
        signal en:in std_logic;
        signal PC_NEXT:out std_logic_vector(15 downto 0);
        signal instruction: out std_logic_vector(15 downto 0)
);
end Instruction_Fetch;

architecture Behavioral of Instruction_Fetch is



type memorieROM is array(0 to 31) of std_logic_vector(15 downto 0);
signal memorie: memorieROM:= (
B"011_000_000_0000000", -- X"2080" -- ADDI $1, $0, 0 --1
B"011_000_001_0000000",
B"011_000_010_0000101",
B"011_000_011_0001010",

B"100_001_100_0000000",
B"100_010_101_0000000",
B"000_100_101_100_0_011",
B"000_000_100_000_0_001",
B"011_000_000_0000001",
B"011_000_001_0000001",
B"001_001_010_0001111",
B"111_0000000000101",

B"000_000_111_000_1_100",
B"110_000_000_0000000",

B"010_000_011_0000111",
B"001_000_000_0000000",
B"111_0000000010011",

B"001_000_000_0000001",

others => X"0000" );


signal buff_pc:std_logic_vector(15 downto 0);
signal mux1:std_logic_vector(15 downto 0);
signal mux2:std_Logic_vector(15 downto 0);
signal mux3:std_logic_Vector(15 downto 0);
begin


process(clk)
begin
if rising_edge(clk) then
 if rst='1' then
  buff_pc <= x"0000"; 
 else if en='1' then
  buff_pc<=mux2;
end if;
end if;
end if;
end process;

process(PC_SRC,buff_pc,branch_adress)
begin
  case PC_SRC is
  when "00" => mux1 <= buff_pc+1;
  when "01" => mux1 <= branch_adress;
  when "10" => mux1 <= branch_adress;
  when others=> mux1 <= buff_pc+1;
  end case;
end process;

process(jump,mux1,jump_adress)
begin 
case jump is
        when '0' => mux2 <= mux1;
        when others => mux2 <= jump_adress;
   end case;
end process;

PC_NEXT<=buff_pc+1;
instruction<=memorie(conv_integer(buff_pc(4 downto 0)));
end Behavioral;
    