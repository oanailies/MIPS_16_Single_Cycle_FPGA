library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity test_env is
 Port (
  signal clk :in STD_LOGIC;
  signal btn : in STD_LOGIC_VECTOR (4 downto 0);
  signal sw : in STD_LOGIC_VECTOR (15 downto 0);
  signal led : out STD_LOGIC_VECTOR (15 downto 0);
  signal an : out STD_LOGIC_VECTOR (3 downto 0);
  signal cat : out STD_LOGIC_VECTOR (6 downto 0)); 
  signal instruction:std_logic_vector(15 downto 0);
  signal PCnext:std_logic_vector(15 downto 0);
  
  signal branchAddress:std_logic_vector(15 downto 0):=x"0004";
  signal jumpAddress:std_logic_vector(15 downto 0):=x"0000";
end test_env;

architecture Behavioral of test_env is

signal rst:std_logic;
signal en:std_logic;
signal en_if:std_logic;
signal digit:std_logic_vector(15 downto 0);

signal func:std_logic_vector(2 downto 0);
signal sa:std_logic;
signal wd:std_logic_vector(15 downto 0);
signal rd1:std_logic_vector(15 downto 0);
signal rd2:std_logic_vector(15 downto 0);
signal Ext_Imm:std_logic_vector(15 downto 0);
signal PC_SRC:std_logic_vector(15 downto 0);
signal Mem_Data:std_logic_vector(15 downto 0);

signal MemWrite: std_logic;
signal MemtoReg: std_logic;
signal RegDst: std_logic;
signal ExtOp: std_logic;
signal ALUSrc: std_logic;
signal ALUOp: std_logic_vector(2 downto 0);
signal ALURes: std_logic_vector(15 downto 0);
signal Branch:std_logic_vector(1 downto 0);
signal Jump: std_logic;
signal RegWrite: std_logic;

signal counter: std_logic_vector(15 downto 0):=(others=>'0');
signal afisor: std_logic_vector(15 downto 0);

component MPG is
    Port ( en : out STD_LOGIC;
           input : in STD_LOGIC;
           clock : in STD_LOGIC);
end component;

component SSD is
Port ( digit : in STD_LOGIC_VECTOR (15 downto 0);
           clk : in STD_LOGIC;
           cat : out STD_LOGIC_VECTOR (6 downto 0);
           an : out STD_LOGIC_VECTOR (3 downto 0));
end component;

component Instruction_Fetch is
Port(
       signal clk: in std_logic;
       signal jump: in std_logic;
       signal jump_adress: in std_logic_vector(15 downto 0):="0000000000000000";
       signal branch_adress:in std_logic_vector(15 downto 0):=B"000_000_100_011_1_100";
       signal PC_SRC:in std_logic_vector(1 downto 0);
       signal rst:in std_logic;
       signal en:in std_logic;
       signal PC_NEXT:out std_logic_vector(15 downto 0);
       signal instruction: out std_logic_vector(15 downto 0));
end component;

component Instruction_Decode is
Port(
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
end component;

component Instruction_Execute is
Port(
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
end component;

component UC is
Port(
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
end component;

component Memorie is
port(
signal clk:in std_logic;
signal MemWrite: in std_logic;
signal en: in std_logic;
signal rd2:in std_logic_vector(15 downto 0);
signal ALUResI:in std_logic_vector(15 downto 0);
signal MemData: out std_logic_vector(15 downto 0);
signal ALUResO: out std_logic_vector(15 downto 0)
);
end component;
begin
mpg_2: MPG port map(en=>en, input=>btn(1),clock=>clk);
mpg_if: MPG port map(en=>en_if, input=>btn(0),clock=>clk);
afisor_cu_7_seg: SSD port map(digit=>digit ,clk=>clk, cat=>cat, an=>an);
if_unitate: Instruction_Fetch port map(clk=>clk, jump=>sw(0), jump_adress=>jumpAddress ,branch_adress=>branchAddress, PC_SRC=>sw(2 downto 1), rst=>rst, en=>en,PC_NEXT=> PCnext, instruction=>instruction);
id_unitate:Instruction_Decode port map(RegWrite=>RegWrite, Instr=>instruction, RegDst=>RegDst, ExtOp=>ExtOp, rd1=>rd1, rd2=>rd2, wd=>wd, ExtImm=>Ext_Imm, func=>func, sa=>sa, clk=>clk, en=>en_if);
ie_unitate:Instruction_Execute port map(ALUOp=>ALUOp, ALUSrc=>ALUSrc,ALURes=>ALURes,  PC=>PC_SRC, rd1=>rd1, rd2=>rd2, Ext_imm=>Ext_imm, sa=>sa, func=>func, branchAddress=>branchAddress);
main_control:UC port map(Instruction=>instruction,RegDst=>RegDst, ExtOp=>ExtOp, ALUSrc=>ALUSrc, Branch=>Branch, ALUOp=>ALUOp, MemWrite=>MemWrite, MemToReg=>MemToReg, RegWrite=>RegWrite);
mem:Memorie port map(clk=>clk, MemWrite=>MemWrite, en=>en,rd2=>rd2, ALUResI=>ALURes ,MemData=>Mem_Data, AluResO=>ALURes);
process(clk)
begin
    if clk'event and clk='1' then
        if en='1' then
            counter<=counter+1;
        end if;
    end if;
end process;

 process(sw)
    begin
        case sw(7 downto 5) is
        when "000"=> afisor<=instruction;
        when "001"=> afisor<=PC_SRC;
        when "010"=> afisor<=rd1;
        when "011"=> afisor<=rd2;
        when "100"=> afisor<=Ext_imm;
        when "101"=> afisor<=ALURes;
        when "110"=> afisor<=Mem_Data;
        when "111"=> afisor<=wd;
        end case;
     end process;
     
led(0)<=regWrite;
led(1)<=memToReg;
led(2)<=memWrite;
led(3)<=jump;
led(5 downto 4)<=branch;
led(6)<=aluSrc;
led(7)<=extOp;
led(8)<=regDst;
led(11 downto 9)<=aluOp;

end Behavioral;
