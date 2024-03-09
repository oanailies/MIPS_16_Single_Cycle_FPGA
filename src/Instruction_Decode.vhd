----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/21/2023 08:32:52 PM
-- Design Name: 
-- Module Name: Instruction_Decode - Behavioral
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

entity Instruction_Decode is
 Port ( 
 signal RegWrite:in std_logic;
 signal Instr:in std_logic_vector(15 downto 0 );
 signal RegDst :in std_logic;
 signal ExtOp:in std_logic;
 signal rd1:out std_logic_vector(15 downto 0);
 signal rd2:out std_logic_vector(15 downto 0);
 signal wd:in std_logic_vector(15 downto 0);
 signal ExtImm:out std_logic_vector(15 downto 0);
 signal func:out std_logic_vector(2 downto 0);
 signal sa :out std_logic;
 signal clk:in std_logic;
 signal en:in std_logic);
 
end Instruction_Decode;

architecture Behavioral of Instruction_Decode is

type register_file is array(0 to 7) of std_logic_vector(15 downto 0);
signal reg: register_file:=(
                                X"0000",
                                X"0000",
                                X"0000",
                                X"0000",
                                X"0011",
                                X"0101",
                                others =>X"0000");
 
signal Rs:std_logic_vector(2 downto 0);
signal Rt:std_logic_vector(2 downto 0);
signal Rd:std_logic_vector(2 downto 0);


signal wa:std_logic_vector(2 downto 0);

begin

Rs<= instr(12 downto 10);
Rt<=instr(9 downto 7);
Rd<=instr(6 downto 4);
sa<=instr(3);
func<=instr(2 downto 0);

rd1<=reg(conv_integer(Rs));
rd2<=reg(conv_integer(Rt));

process(clk)
begin
if rising_edge(clk) then
if RegWrite = '1' and en='1' then
reg(conv_integer(wa)) <= wd;
end if;
end if;
end process;

process(ExtOp,instr(6 downto 0))
begin
case ExtOp is 
when '1'=>extImm<=instr(6)&instr(6)&instr(6)&instr(6)&instr(6)&instr(6)&instr(6)&instr(6)&instr(6)&instr(6 downto 0);
when others=>extImm<="000000000"&instr(6 downto 0);
end case;
end process;

process(Rt,Rd,regDst)
    begin
    case regDst is
    when '0'=> wa<=Rd;
    when others=> wa<=Rt;
    end case;
    end process;

end Behavioral;
