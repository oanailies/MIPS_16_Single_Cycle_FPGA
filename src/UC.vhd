----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/22/2023 01:00:58 PM
-- Design Name: 
-- Module Name: UC - Behavioral
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
use ieee.numeric_std.all;

entity UC is
Port (    
           Instruction: in std_logic_vector(15 downto 0);
           RegDst : out STD_LOGIC;
           ExtOp : out STD_LOGIC;
           ALUSrc : out STD_LOGIC;
           Branch : out STD_LOGIC_VECTOR(1 downto 0);
           Jump : out STD_LOGIC;
           ALUOp : out STD_LOGIC_VECTOR (2 downto 0);
           MemWrite : out STD_LOGIC;
           MemToReg : out STD_LOGIC;
           RegWrite : out STD_LOGIC
           );
end UC;

architecture Behavioral of UC is


begin
process(Instruction)
begin
RegDst<='0';
ExtOp<='0';
ALUSrc<='0';
Branch<="00";
Jump<='0';
ALUOp<="000";
MemWrite<='0';
MemToReg<='0';
RegWrite<='0';
case Instruction (15 downto 13) is --opcode
when "000"=>regDst<='1'; regWrite<='1'; aluOp<="000";--R
when "001"=>ExtOp<='1';  Branch<="00";--beq
when "010"=>ExtOp<='1';  Branch<="01";--bgt
when "011"=>ExtOp<='1';  ALUSrc<='1'; regWrite<='1';--addi
when "100"=>ALUSrc<='1'; MemToReg<='1'; RegWrite<='1';--lw
when "110"=>ExtOp<='1';  ALUSrc<='1'; MemWrite<='1';--sw
when others=>Jump<='1'; --j
end case;
end process;




end Behavioral;
