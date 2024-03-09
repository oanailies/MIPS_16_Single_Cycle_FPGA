library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use ieee.numeric_std.all;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Memorie is
Port ( 
signal clk:in std_logic;
signal MemWrite: in std_logic;
signal en: in std_logic;
signal rd2:in std_logic_vector(15 downto 0);
signal ALUResI:in std_logic_vector(15 downto 0);
signal MemData: out std_logic_vector(15 downto 0);
signal ALUResO: out std_logic_vector(15 downto 0)
);
end Memorie;

architecture Behavioral of Memorie is
type memorie is array(0 to 256) of std_logic_vector(15 downto 0);
signal MEM: memorie := (
                                X"0000",
                                X"0000",
                                X"0000",
                                X"0000",
                                X"0000",
                                X"0011",
                                X"0101",
                            others=>x"000"
                        );
signal address: std_logic_vector(4 downto 0);
signal wd: std_logic_vector(15 downto 0);
signal rd: std_logic_vector(15 downto 0);

begin

process(clk)
begin
if rising_edge(clk) then
 if en='1' and  MemWrite='1' then 
 MEM(conv_integer(address))<=wd;
end if;
end if;
end process;

rd<=MEM(conv_integer(address));

end Behavioral;
