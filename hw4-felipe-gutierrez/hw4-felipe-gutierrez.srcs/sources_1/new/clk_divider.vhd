----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 06/08/2018 02:49:30 PM
-- Design Name: 
-- Module Name: clk_divider - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity clk_divider is
   Generic ( divisor: integer := 3000);
   Port ( reset : in STD_LOGIC;
          in_clk : in STD_LOGIC;
          out_clk : out STD_LOGIC);
end clk_divider;

architecture arch of clk_divider is
    Signal count : integer range 0 to divisor := 0;
    Signal temp : STD_LOGIC;
begin
 process (in_clk, reset)
   begin
       if (reset='1') then
           count <= 0;
           temp <= '0';
       elsif (in_clk'event and in_clk='1') then
           if (count = divisor) then
               temp <= not (temp);
               count <= 0;
           else
               count <= count + 1;
           end if;
       end if;
   end process;
   out_clk <= temp;
end arch;
