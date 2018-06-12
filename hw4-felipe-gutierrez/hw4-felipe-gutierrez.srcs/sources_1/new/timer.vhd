----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 06/08/2018 02:54:13 PM
-- Design Name: 
-- Module Name: timer - Behavioral
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
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;
-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;
entity Timer is
  Port (   clk : in STD_LOGIC;
           sw : in STD_LOGIC_VECTOR (15 downto 0);
           btnC : in STD_LOGIC;
           an : out STD_LOGIC_VECTOR (3 downto 0);
           seg : out STD_LOGIC_VECTOR (6 downto 0);
           led : out STD_LOGIC_VECTOR (15 downto 0)
  );
end Timer;
architecture timer_arch of Timer is
   signal clk_divided : STD_LOGIC;
   signal sec0 : integer range 0 to 9;
   signal sec1 : integer range 0 to 5;
   signal min0 : integer range 0 to 9;
   signal min1 : integer range 0 to 5;
   signal sseg0, sseg1, sseg2, sseg3 : STD_LOGIC_VECTOR (7 downto 0);
   signal q : STD_LOGIC := '0';
   
   signal hex_1, hex_2, hex_3, hex_4 : STD_LOGIC_VECTOR (3 downto 0);
   signal outp : std_logic_vector (7 downto 0);
begin
      divider : entity work.clk_divider 
            generic map ( divisor => 100000000)
            port map ( in_clk => clk, 
                       out_clk => clk_divided, 
                       reset => btnC
                      );
            
       process (clk)
            begin
                if rising_edge(clk) then
                    if (btnC = '1') then
                        if (to_integer(unsigned(sw (3 downto 0))) > 9) then
                            sec0 <= 9;
                        else
                            sec0 <= to_integer(unsigned(sw (3 downto 0)));
                        end if;
                       
                        if (to_integer(unsigned(sw (7 downto 4))) > 5) then
                            sec1 <= 5;
                        else
                            sec1 <= to_integer(unsigned(sw (7 downto 4)));
                        end if;
                       
                        if (to_integer(unsigned(sw (11 downto 8))) > 9) then
                            min0 <= 9;
                        else
                            min0 <= to_integer(unsigned(sw (11 downto 8)));
                        end if;
            
                        if (to_integer(unsigned(sw (15 downto 12))) > 5) then
                            min1 <= 5;
                        else
                            min1 <= to_integer(unsigned(sw (15 downto 12)));
                        end if;
                        
                     elsif (clk_divided='1' and q='0') then
                        q<='1';
                        if (sec0 /= 0) then
                            sec0 <= sec0 - 1;
                        elsif (sec1 /= 0) then
                            sec1 <= sec1 - 1;
                            sec0 <= 9;
                        elsif (min0 /= 0) then
                            min0 <= min0 - 1;
                            sec1 <= 5;
                            sec0 <= 9;
                        elsif (min1 /= 0) then
                            min1 <= min1 - 1;
                            min0 <= 9;
                            sec1 <= 5;
                            sec0 <= 9;
                        end if;
                           
                     elsif (clk_divided='0' and q='1') then
                        q<='0';
                     end if;
                  end if;
           end process;
           
       process (sec0, sec1, min0, min1)
            begin
                if (sec0 = 0 and sec1 = 0 and min0 = 0 and min1 = 0) then
                    led <= (others => '1');
                else
                    led <= (others => '0');
                end if;
            end process;
            
            
        hex_1 <= STD_LOGIC_VECTOR(to_unsigned(sec0, 4));
        hex_2 <= STD_LOGIC_VECTOR(to_unsigned(sec1, 4));
        hex_3 <= STD_LOGIC_VECTOR(to_unsigned(min0, 4));
        hex_4 <= STD_LOGIC_VECTOR(to_unsigned(min1, 4));
        
        
        sseg_unit_1 : entity work.hex_to_sseg
            port map (hex => hex_1, 
                      dp => '1',
                      sseg => sseg0
                     );
                
        sseg_unit_2 : entity work.hex_to_sseg
           port map (hex => hex_2, 
                     dp => '1',
                     sseg => sseg1
                    );
            
        sseg_unit_3 : entity work.hex_to_sseg
           port map (hex => hex_3,
                     dp => '0', 
                     sseg => sseg2
                    );
            
        sseg_unit_4 : entity work.hex_to_sseg
           port map(hex => hex_4, 
                    dp => '1',
                    sseg => sseg3
                   );
                
        disp : entity work.disp_mux (arch)
           port map (clk => clk, 
                     an => an, 
                     in0 => sseg0, 
                     in1 => sseg1, 
                     in2 => sseg2, 
                     in3 => sseg3, 
                     reset => btnC,  
                     sseg => outp
                    );
                    
        seg <= outp (6 downto 0);
end timer_arch;
