----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/22/2023 10:23:30 AM
-- Design Name: 
-- Module Name: Instruction_Execute - Behavioral
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

entity Instruction_Execute is
Port (   
       signal ALUOp : in STD_LOGIC_VECTOR (2 downto 0);
       signal ALUSrc : in STD_LOGIC;
       signal ALURes : out STD_LOGIC_VECTOR (15 downto 0);
       signal PC: in std_logic_vector(15 downto 0);
       signal rd1 : in STD_LOGIC_VECTOR (15 downto 0);
       signal rd2 : in STD_LOGIC_VECTOR (15 downto 0);
       signal Ext_imm : in STD_LOGIC_VECTOR (15 downto 0);
       signal sa : in STD_LOGIC;
       signal func : in STD_LOGIC_VECTOR (2 downto 0);
       signal branchAddress:out std_logic_vector(15 downto 0)
);
end Instruction_Execute;

architecture Behavioral of Instruction_Execute is
signal ALU_CONTROL:std_logic_vector(15 downto 0);
signal rez: std_logic_vector(15 downto 0);
signal op1: std_logic_vector(15 downto 0);
signal op2: std_logic_vector(15 downto 0);
signal imm:std_logic_vector(15 downto 0);

type memory_array is array (0 to 255) of std_logic_vector(15 downto 0);
signal memory: memory_array := (others => (others => '0'));

    
   
begin

op1<=rd1;
BranchAddress<=Ext_Imm+PC;

AluControl: process(ALUOp, func)
begin

end process;

mux:process(ALUSrc,rd2,Ext_Imm)
begin
  case ALUSrc is 
  when '0'=>op2<=rd2;
  when '1'=>op2<=Ext_Imm;
  when others=>op2<=X"0000";
  end case;
 end process;
 
 ALUContr: process(ALUOp, func)
 begin
 case ALUOp is
 when "000"=> --R 
   case func is
   when "001"=>ALU_CONTROL<="0000000000000000";--ADD
   when "010"=>ALU_CONTROL<="0000000000000001";--SUB
   when "011"=>ALU_CONTROL<="0000000000000010";--MUL
   when "100"=>ALU_CONTROL<="0000000000000011";--SRL
   when "101"=>ALU_CONTROL<="0000000000000100";--sll
   when "110"=>ALU_CONTROL<="0000000000000101";--and
   when others=>ALU_CONTROL<="0000000000000110";--or
   end case;
 when "001"=>ALU_CONTROL<="0000000000001000"; --BEQ
 when "010"=>ALU_CONTROL<="0000000000001001"; --BGT
 when "011"=>ALU_CONTROL<="0000000000001010";--ADDI
 when "100"=>ALU_CONTROL<="0000000000001011"; --lw
 when "101"=>ALU_CONTROL<="0000000000001100";--LA
 when "110"=>ALU_CONTROL<="0000000000001101";--sw
 when "111"=>ALU_CONTROL<="0000000000001110";--J
 end case;
 end process;
 
 AluOperation:process(op1, op2, ALU_CONTROL)
 begin
 case ALU_CONTROL is
 when "0000000000000000"=>rez<=op1+op2; --add
 when "0000000000000000"=>rez<=op1-op2; --sub
-- when "0000000000000010"=>rez<=op1*op2; --mul
 when "0000000000000000"=> --slr
        if sa='1' then 
        rez<='0'&op1(14 downto 0);
        else rez<=op1;
        end if;
 when "0000000000000000"=> --sll
       if sa='1'then
        rez<=op1(14 downto 0)&'0';
        else rez<=op1; 
        end if;
when "0000000000000000"=> rez<=op1 and op2; --and
when "0000000000000000"=> rez<=op1 or op2; --or
when "0000000000000000"=> rez<=op1 xor op2; --xor

when "0000000000000010"=> --beq
if op1 = op2 then
            rez <= std_logic_vector(to_signed(1, 16));
        else
            rez<= std_logic_vector(to_signed(0, 16));
            end if;
 when "0000000000000011"=> --bgt
 if op1 > op2 then
             rez <= std_logic_vector(to_signed(1, 16));
         else
             rez<= std_logic_vector(to_signed(0, 16));
             end if;
when "0000000000000001"=>rez <= op1 + imm; --adi
when "0000000000000001"=> --lw
when "0000000000000001"=> --la
when "0000000000000001"=> --sw
when "0000000000000001"=>
when others=>rez<="0000000000000000";
  end case;
 end process;
 
end Behavioral;
