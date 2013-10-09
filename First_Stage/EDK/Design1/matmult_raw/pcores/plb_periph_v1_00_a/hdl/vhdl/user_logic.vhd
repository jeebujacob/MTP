------------------------------------------------------------------------------
-- user_logic.vhd - entity/architecture pair
------------------------------------------------------------------------------
--
-- ***************************************************************************
-- ** Copyright (c) 1995-2011 Xilinx, Inc.  All rights reserved.            **
-- **                                                                       **
-- ** Xilinx, Inc.                                                          **
-- ** XILINX IS PROVIDING THIS DESIGN, CODE, OR INFORMATION "AS IS"         **
-- ** AS A COURTESY TO YOU, SOLELY FOR USE IN DEVELOPING PROGRAMS AND       **
-- ** SOLUTIONS FOR XILINX DEVICES.  BY PROVIDING THIS DESIGN, CODE,        **
-- ** OR INFORMATION AS ONE POSSIBLE IMPLEMENTATION OF THIS FEATURE,        **
-- ** APPLICATION OR STANDARD, XILINX IS MAKING NO REPRESENTATION           **
-- ** THAT THIS IMPLEMENTATION IS FREE FROM ANY CLAIMS OF INFRINGEMENT,     **
-- ** AND YOU ARE RESPONSIBLE FOR OBTAINING ANY RIGHTS YOU MAY REQUIRE      **
-- ** FOR YOUR IMPLEMENTATION.  XILINX EXPRESSLY DISCLAIMS ANY              **
-- ** WARRANTY WHATSOEVER WITH RESPECT TO THE ADEQUACY OF THE               **
-- ** IMPLEMENTATION, INCLUDING BUT NOT LIMITED TO ANY WARRANTIES OR        **
-- ** REPRESENTATIONS THAT THIS IMPLEMENTATION IS FREE FROM CLAIMS OF       **
-- ** INFRINGEMENT, IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS       **
-- ** FOR A PARTICULAR PURPOSE.                                             **
-- **                                                                       **
-- ***************************************************************************
--
------------------------------------------------------------------------------
-- Filename:          user_logic.vhd
-- Version:           1.00.a
-- Description:       User logic.
-- Date:              Tue Sep 24 15:53:47 2013 (by Create and Import Peripheral Wizard)
-- VHDL Standard:     VHDL'93
------------------------------------------------------------------------------
-- Naming Conventions:
--   active low signals:                    "*_n"
--   clock signals:                         "clk", "clk_div#", "clk_#x"
--   reset signals:                         "rst", "rst_n"
--   generics:                              "C_*"
--   user defined types:                    "*_TYPE"
--   state machine next state:              "*_ns"
--   state machine current state:           "*_cs"
--   combinatorial signals:                 "*_com"
--   pipelined or register delay signals:   "*_d#"
--   counter signals:                       "*cnt*"
--   clock enable signals:                  "*_ce"
--   internal version of output port:       "*_i"
--   device pins:                           "*_pin"
--   ports:                                 "- Names begin with Uppercase"
--   processes:                             "*_PROCESS"
--   component instantiations:              "<ENTITY_>I_<#|FUNC>"
------------------------------------------------------------------------------

-- DO NOT EDIT BELOW THIS LINE --------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

library proc_common_v3_00_a;
use proc_common_v3_00_a.proc_common_pkg.all;

-- DO NOT EDIT ABOVE THIS LINE --------------------

--USER libraries added here

------------------------------------------------------------------------------
-- Entity section
------------------------------------------------------------------------------
-- Definition of Generics:
--   C_SLV_AWIDTH                 -- Slave interface address bus width
--   C_SLV_DWIDTH                 -- Slave interface data bus width
--   C_NUM_REG                    -- Number of software accessible registers
--   C_NUM_MEM                    -- Number of memory spaces
--
-- Definition of Ports:
--   Bus2IP_Clk                   -- Bus to IP clock
--   Bus2IP_Reset                 -- Bus to IP reset
--   Bus2IP_Addr                  -- Bus to IP address bus
--   Bus2IP_CS                    -- Bus to IP chip select for user logic memory selection
--   Bus2IP_RNW                   -- Bus to IP read/not write
--   Bus2IP_Data                  -- Bus to IP data bus
--   Bus2IP_BE                    -- Bus to IP byte enables
--   Bus2IP_RdCE                  -- Bus to IP read chip enable
--   Bus2IP_WrCE                  -- Bus to IP write chip enable
--   Bus2IP_Burst                 -- Bus to IP burst-mode qualifier
--   Bus2IP_BurstLength           -- Bus to IP burst length
--   Bus2IP_RdReq                 -- Bus to IP read request
--   Bus2IP_WrReq                 -- Bus to IP write request
--   IP2Bus_AddrAck               -- IP to Bus address acknowledgement
--   IP2Bus_Data                  -- IP to Bus data bus
--   IP2Bus_RdAck                 -- IP to Bus read transfer acknowledgement
--   IP2Bus_WrAck                 -- IP to Bus write transfer acknowledgement
--   IP2Bus_Error                 -- IP to Bus error response
------------------------------------------------------------------------------

entity user_logic is
  generic
  (
    -- ADD USER GENERICS BELOW THIS LINE ---------------
    --USER generics added here
    -- ADD USER GENERICS ABOVE THIS LINE ---------------

    -- DO NOT EDIT BELOW THIS LINE ---------------------
    -- Bus protocol parameters, do not add to or delete
    C_SLV_AWIDTH                   : integer              := 32;
    C_SLV_DWIDTH                   : integer              := 32;
    C_NUM_REG                      : integer              := 3;
    C_NUM_MEM                      : integer              := 2
    -- DO NOT EDIT ABOVE THIS LINE ---------------------
  );
  port
  (
    -- ADD USER PORTS BELOW THIS LINE ------------------
    --USER ports added here
    -- ADD USER PORTS ABOVE THIS LINE ------------------

    -- DO NOT EDIT BELOW THIS LINE ---------------------
    -- Bus protocol ports, do not add to or delete
    Bus2IP_Clk                     : in  std_logic;
    Bus2IP_Reset                   : in  std_logic;
    Bus2IP_Addr                    : in  std_logic_vector(0 to C_SLV_AWIDTH-1);
    Bus2IP_CS                      : in  std_logic_vector(0 to C_NUM_MEM-1);
    Bus2IP_RNW                     : in  std_logic;
    Bus2IP_Data                    : in  std_logic_vector(0 to C_SLV_DWIDTH-1);
    Bus2IP_BE                      : in  std_logic_vector(0 to C_SLV_DWIDTH/8-1);
    Bus2IP_RdCE                    : in  std_logic_vector(0 to C_NUM_REG-1);
    Bus2IP_WrCE                    : in  std_logic_vector(0 to C_NUM_REG-1);
    Bus2IP_Burst                   : in  std_logic;
    Bus2IP_BurstLength             : in  std_logic_vector(0 to 8);
    Bus2IP_RdReq                   : in  std_logic;
    Bus2IP_WrReq                   : in  std_logic;
    IP2Bus_AddrAck                 : out std_logic;
    IP2Bus_Data                    : out std_logic_vector(0 to C_SLV_DWIDTH-1);
    IP2Bus_RdAck                   : out std_logic;
    IP2Bus_WrAck                   : out std_logic;
    IP2Bus_Error                   : out std_logic
    -- DO NOT EDIT ABOVE THIS LINE ---------------------
  );

  attribute MAX_FANOUT : string;
  attribute SIGIS : string;

  attribute SIGIS of Bus2IP_Clk    : signal is "CLK";
  attribute SIGIS of Bus2IP_Reset  : signal is "RST";

end entity user_logic;

------------------------------------------------------------------------------
-- Architecture section
------------------------------------------------------------------------------

architecture IMP of user_logic is

  --USER signal declarations added here, as needed for user logic

  ------------------------------------------
  -- Signals for user logic slave model s/w accessible register example
  ------------------------------------------
  signal slv_reg0                       : std_logic_vector(0 to C_SLV_DWIDTH-1);
  signal slv_reg1                       : std_logic_vector(0 to C_SLV_DWIDTH-1);
  signal slv_reg2                       : std_logic_vector(0 to C_SLV_DWIDTH-1);
  signal slv_reg_write_sel              : std_logic_vector(0 to 2);
  signal slv_reg_read_sel               : std_logic_vector(0 to 2);
  signal slv_ip2bus_data                : std_logic_vector(0 to C_SLV_DWIDTH-1);
  signal slv_read_ack                   : std_logic;
  signal slv_write_ack                  : std_logic;

  ------------------------------------------
  -- Signals for user logic memory space example
  ------------------------------------------
  type BYTE_RAM_TYPE is array (0 to 255) of std_logic_vector(0 to 7);
  type DO_TYPE is array (0 to C_NUM_MEM-1) of std_logic_vector(0 to C_SLV_DWIDTH-1);
  signal mem_data_out                   : DO_TYPE;
  signal mem_address                    : std_logic_vector(0 to 7);
  signal mem_select                     : std_logic_vector(0 to 1);
  signal mem_read_enable                : std_logic;
  signal mem_ip2bus_data                : std_logic_vector(0 to C_SLV_DWIDTH-1);
  signal mem_read_ack_dly1              : std_logic;
  signal mem_read_ack                   : std_logic;
  signal mem_write_ack                  : std_logic;

   ---------------------signals for OA block and Transpose block----
  
  type states is (IDLE,TRANSPOSE,ACCUMULATE,RESULT);
  type ram is array (0 to 127) of std_logic_vector(0 to 31);
  signal mem0	: ram;
  signal mem1   : ram;
  signal mem0_write	: std_logic;
  signal mem1_write : std_logic;
  signal present_state,next_state : states;
  signal hw_count : integer := 0;
  signal memcount : integer := 0;
   
  signal s_o_out : std_logic_vector(0 to 31);
  signal sdata_in_sel,sen_data_in,s_b_in_f,s_RDY_o_out : std_logic;  
  signal srst_oa_n,srst_tran_n : std_logic;
  signal matdatain	: std_logic_vector(0 to C_SLV_DWIDTH-1); --32 bit  matrix data inputofcourse
  signal matdataout : std_logic_vector(0 to C_SLV_DWIDTH-1); --32 bit ofcourse
  signal read_address1 : std_logic_vector(0 to 7);
  signal read_address2 : std_logic_vector(0 to 7);
  
  
  component mkOA is 
	port(
			o_out         : out std_logic_vector(0 to 31);   
			RDY_o_out     : out std_logic;
			CLK           : in std_logic;
			RST_N         : in std_logic; -- Low Level
			data_in_x     : in std_logic_vector(0 to 31) ; 
			data_in_y     : in std_logic_vector(0 to 31);  
			data_in_sel   : in std_logic;
			EN_data_in    : in std_logic
		);
	end component;	
  
  component mkTranspose is 
	port(
			o_out         : out std_logic_vector(0 to 31);
			RDY_o_out     : out std_logic;
			CLK           : in std_logic;
			RST_N         : in std_logic;
			a_in_m        : in std_logic_vector(0 to 31);
			b_in_f        : in std_logic
		);
	end component;	
  
  
begin

  --USER logic implementation added here

  ------------------------------------------
  -- Example code to read/write user logic slave model s/w accessible registers
  -- 
  -- Note:
  -- The example code presented here is to show you one way of reading/writing
  -- software accessible registers implemented in the user logic slave model.
  -- Each bit of the Bus2IP_WrCE/Bus2IP_RdCE signals is configured to correspond
  -- to one software accessible register by the top level template. For example,
  -- if you have four 32 bit software accessible registers in the user logic,
  -- you are basically operating on the following memory mapped registers:
  -- 
  --    Bus2IP_WrCE/Bus2IP_RdCE   Memory Mapped Register
  --                     "1000"   C_BASEADDR + 0x0
  --                     "0100"   C_BASEADDR + 0x4
  --                     "0010"   C_BASEADDR + 0x8
  --                     "0001"   C_BASEADDR + 0xC
  -- 
  ------------------------------------------
  slv_reg_write_sel <= Bus2IP_WrCE(0 to 2);
  slv_reg_read_sel  <= Bus2IP_RdCE(0 to 2);
  -- slv_write_ack     <= Bus2IP_WrCE(0) or Bus2IP_WrCE(1) or Bus2IP_WrCE(2);
  slv_write_ack     <= Bus2IP_WrCE(0) or Bus2IP_WrCE(1);
  slv_read_ack      <= Bus2IP_RdCE(0) or Bus2IP_RdCE(1) or Bus2IP_RdCE(2);

  -- implement slave model software accessible register(s)
  SLAVE_REG_WRITE_PROC : process( Bus2IP_Clk ) is
  begin

    if Bus2IP_Clk'event and Bus2IP_Clk = '1' then
      if Bus2IP_Reset = '1' then
        slv_reg0 <= (others => '0');
        slv_reg1 <= (others => '0');
        -- slv_reg2 <= (others => '0'); This is the hardware only register, not to be altered by the software API, hence commented out
      else
        case slv_reg_write_sel is 
          when "100" =>
            for byte_index in 0 to (C_SLV_DWIDTH/8)-1 loop
              if ( Bus2IP_BE(byte_index) = '1' ) then
                slv_reg0(byte_index*8 to byte_index*8+7) <= Bus2IP_Data(byte_index*8 to byte_index*8+7);
              end if;
            end loop;
          when "010" =>
            for byte_index in 0 to (C_SLV_DWIDTH/8)-1 loop
              if ( Bus2IP_BE(byte_index) = '1' ) then
                slv_reg1(byte_index*8 to byte_index*8+7) <= Bus2IP_Data(byte_index*8 to byte_index*8+7);
              end if;
            end loop;
          -- when "001" =>
            -- for byte_index in 0 to (C_SLV_DWIDTH/8)-1 loop
              -- if ( Bus2IP_BE(byte_index) = '1' ) then
                -- slv_reg2(byte_index*8 to byte_index*8+7) <= Bus2IP_Data(byte_index*8 to byte_index*8+7);
              -- end if;
            -- end loop;
          when others => null;
        end case;
      end if;
    end if;

  end process SLAVE_REG_WRITE_PROC;

  -- implement slave model software accessible register(s) read mux
  SLAVE_REG_READ_PROC : process( slv_reg_read_sel, slv_reg0, slv_reg1, slv_reg2 ) is
  begin

    case slv_reg_read_sel is
      when "100" => slv_ip2bus_data <= slv_reg0;
      when "010" => slv_ip2bus_data <= slv_reg1;
      when "001" => slv_ip2bus_data <= slv_reg2;
      when others => slv_ip2bus_data <= (others => '0');
    end case;

  end process SLAVE_REG_READ_PROC;

  ------------------------------------------
  -- Example code to access user logic memory region
  -- 
  -- Note:
  -- The example code presented here is to show you one way of using
  -- the user logic memory space features. The Bus2IP_Addr, Bus2IP_CS,
  -- and Bus2IP_RNW IPIC signals are dedicated to these user logic
  -- memory spaces. Each user logic memory space has its own address
  -- range and is allocated one bit on the Bus2IP_CS signal to indicated
  -- selection of that memory space. Typically these user logic memory
  -- spaces are used to implement memory controller type cores, but it
  -- can also be used in cores that need to access additional address space
  -- (non C_BASEADDR based), s.t. bridges. This code snippet infers
  -- 2 256x32-bit (byte accessible) single-port Block RAM by XST.
  ------------------------------------------
  
  mem_select      <= Bus2IP_CS;
  mem_read_enable <= ( Bus2IP_CS(0) or Bus2IP_CS(1) ) and Bus2IP_RdReq;
  mem_read_ack    <= mem_read_ack_dly1;
  mem_write_ack   <= ( Bus2IP_CS(0) or Bus2IP_CS(1) ) and Bus2IP_WrReq;
  mem_address     <= Bus2IP_Addr(C_SLV_AWIDTH-10 to C_SLV_AWIDTH-3);

  -- this process generates the read acknowledge 1 clock after read enable
  -- is presented to the BRAM block. The BRAM block has a 1 clock delay
  -- from read enable to data out.
  BRAM_RD_ACK_PROC : process( Bus2IP_Clk ) is
  begin

    if ( Bus2IP_Clk'event and Bus2IP_Clk = '1' ) then
      if ( Bus2IP_Reset = '1' ) then
        mem_read_ack_dly1 <= '0';
      else
        mem_read_ack_dly1 <= mem_read_enable;
      end if;
    end if;

  end process BRAM_RD_ACK_PROC;


  
  ---------------------------First Memory Generation Here... This is a memory to store the 2 input matrices-------
  mem0_write  		<=  not(Bus2IP_RNW) and Bus2IP_CS(0);
  mem1_write		<=  '1' when (present_state = RESULT) else '0';
  mem_data_out(0) 	<=  mem0((CONV_INTEGER(read_address1)));
  mem_data_out(1) 	<=  mem1((CONV_INTEGER(read_address2)));
  matdatain <= mem0(hw_count) when (hw_count<64 and  (present_state = TRANSPOSE or present_state = ACCUMULATE)) else (others=>'0');
  -- mem1(hw_count-64) <= matdataout when (present_state = RESULT); 
		INP_MEM: process(Bus2IP_Clk) is 
		begin
		if ( Bus2IP_Clk'event and Bus2IP_Clk = '1' ) then
			if(mem0_write = '1') then
				mem0(CONV_INTEGER(mem_address)) <= Bus2IP_Data;
			end if;
			read_address1 <= mem_address;
		end if;	
		end process INP_MEM;

	

		OUT_MEM: process(Bus2IP_Clk) is
		begin 
		if( Bus2IP_Clk'event and Bus2IP_Clk = '1') then
			if(mem1_write = '1') then
				mem1(hw_count-64) <= matdataout;
				-- mem1(CONV_INTEGER(mem_address)) <= Bus2IP_Data;
			end if;
			read_address2 <= mem_address;
		end if;	
		end process OUT_MEM;
	
	
----------Now the second memory generation---

	-- OUT_MEM : for byte_index in 0 to (C_SLV_DWIDTH+7)/8-1 generate
      -- signal ram2           : BYTE_RAM_TYPE;
      -- signal write_enable2  : std_logic;
      -- signal data_in2       : std_logic_vector(0 to 7);
      -- signal data_out2      : std_logic_vector(0 to 7);
      -- signal read_address2  : std_logic_vector(0 to 7);
    -- begin

      -- write_enable2 <=  '1' when  present_state = RESULT else '0';-- The data should be written from the logic during the RESULT State
                      
                    
      -- data_in2 <= matdataout(byte_index*8 to byte_index*8+7);-- This is the write data, which should come from the logic!
      -- mem_data_out(1)(byte_index*8 to byte_index*8+7) <= data_out2;  -- This is the read data. Shouldnt be tampered with

      -- BYTE_RAM_PROC2 : process( Bus2IP_Clk ) is
      -- begin

        -- if ( Bus2IP_Clk'event and Bus2IP_Clk = '1' ) then
          -- if ( write_enable2 = '1' ) then
           
            -- ram2(hw_count-64) <= data_in2;
          -- end if;
          -- read_address2 <= mem_address;
        -- end if;

      -- end process BYTE_RAM_PROC2;

      -- data_out2 <= ram2(CONV_INTEGER(read_address2));

    -- end generate OUT_MEM;


MATMULT_DATAPATH: process(Bus2IP_Clk,Bus2IP_Reset)
	begin
		if(Bus2IP_Reset = '1') then
			present_state <= IDLE;
			slv_reg2	  <= x"00000008";-- Default value of 8 given to output flag
			hw_count	  <= 0;
					
		else
			if(Bus2IP_Clk'event and Bus2IP_Clk = '1') then
				
			case present_state is 

				
				when IDLE =>
							if(slv_reg0 = x"00000001") then 
								-- hw_count 		<= hw_count + 1;
								present_state 	<= TRANSPOSE;
								srst_tran_n 	<= '1'; -- Transpose block activated
								srst_oa_n		<= '0'; -- Still in reset condition
								s_b_in_f 		<= '0'; -- Select line for Transpose block
								sen_data_in 	<= '0'; -- Data enable for OA block
								sdata_in_sel    <= '0'; --select line for OA
								
							else 
								present_state <= IDLE;
								srst_tran_n 	<= '0'; -- Reset Disabled
								srst_oa_n		<= '0'; -- Still in reset condition
								s_b_in_f 		<= '0';-- Select line for Transpose block
								sen_data_in 	<= '0';-- Data enable for OA block
								sdata_in_sel    <= '0';--select line for OA
									
							end if;	
									
				when TRANSPOSE =>
							if(hw_count = 31) then
								hw_count 		<= hw_count + 1;
								present_state 	<= ACCUMULATE;
								srst_tran_n 	<= '1'; -- transpose block activated
								srst_oa_n		<= '1'; -- OA block activated
								s_b_in_f 		<= '1'; -- select line of transpose set to shift out the transposed data
								sen_data_in 	<= '1'; -- Data enable for OA block
								sdata_in_sel    <= '0';--select line for OA
							else
								hw_count 		<= hw_count + 1;
								present_state 	<= TRANSPOSE;
								srst_tran_n 	<= '1'; -- Reset Disabled
								srst_oa_n		<= '0'; -- Still in reset condition
								s_b_in_f 		<= '0';-- Select line for Transpose block
								sen_data_in 	<= '0';	-- Data enable for OA block
								sdata_in_sel    <= '0';--select line for OA
							end if;
				
				when ACCUMULATE =>
							if(hw_count = 63 ) then
								
								present_state 	<= RESULT;
								hw_count 		<= hw_count + 1;
								srst_tran_n 	<= '1'; -- transpose block activated
								srst_oa_n		<= '1'; -- OA block activated
								s_b_in_f 		<= '1'; -- select line of transpose set to shift out the transposed data
								sen_data_in 	<= '1';
								sdata_in_sel    <= '1';--select line for OA
							else
								hw_count 		<= hw_count + 1;
								present_state 	<= ACCUMULATE;
								srst_tran_n 	<= '1'; -- Reset Disabled
								srst_oa_n		<= '1'; -- Still in reset condition
								s_b_in_f 		<= '1';
								sen_data_in 	<= '1';	
								sdata_in_sel    <= '0';--select line for OA
				
							end if;
				
				when RESULT	=>
				
							if(hw_count = 95) then
								present_state 	<= IDLE;
								hw_count 		<=  0;
								srst_tran_n 	<= '0'; -- Reset Disabled
								srst_oa_n		<= '0'; -- Still in reset condition
								s_b_in_f 		<= '0';
								sen_data_in 	<= '0';	
								sdata_in_sel    <= '0';--select line for OA
								-------------------------------------------
								slv_reg2		<= x"00000001"; -- Output Flag
								-------------------------------------------
							else
								hw_count 		<= hw_count + 1;
								present_state 	<= RESULT;
								srst_tran_n 	<= '1'; -- Reset Disabled
								srst_oa_n		<= '1'; -- Still in reset condition
								s_b_in_f 		<= '1';
								sen_data_in 	<= '1';	
								sdata_in_sel    <= '1';--select line for OA
							
							end if;
				
				
				when others =>
							null;
			end case;	
				
			end if;
			
		end if;
		
	end process;	
	
  -- implement Block RAM read mux
  MEM_IP2BUS_DATA_PROC : process( mem_data_out, mem_select ) is
  begin

    case mem_select is
      when "10" => mem_ip2bus_data <= mem_data_out(0);
      when "01" => mem_ip2bus_data <= mem_data_out(1);
      when others => mem_ip2bus_data <= (others => '0');
    end case;

  end process MEM_IP2BUS_DATA_PROC;

  ------------------------------------------
  -- Example code to drive IP to Bus signals
  ------------------------------------------
  IP2Bus_Data  <= slv_ip2bus_data when slv_read_ack = '1' else
                  mem_ip2bus_data when mem_read_ack = '1' else
                  (others => '0');

  IP2Bus_AddrAck <= slv_write_ack or slv_read_ack or mem_write_ack or mem_read_enable;
  IP2Bus_WrAck <= slv_write_ack or mem_write_ack;
  IP2Bus_RdAck <= slv_read_ack or mem_read_ack;
  IP2Bus_Error <= '0';
  
   OA1: mkOA port map(
						o_out        =>  matdataout,
						RDY_o_out    =>  open,
						CLK          =>  Bus2IP_Clk,
						RST_N        =>  srst_oa_n,
						data_in_x    =>  s_o_out,  
						data_in_y    =>  matdatain,   
						data_in_sel  =>  sdata_in_sel,
						EN_data_in   =>  sen_data_in
					);
	
 Tran1: mkTranspose port map(
			
							o_out        =>  s_o_out,
							RDY_o_out    =>  s_RDY_o_out,
							CLK          =>  Bus2IP_Clk,
							RST_N        =>  srst_tran_n,
							a_in_m       =>  matdatain,
							b_in_f       =>  s_b_in_f
							);



end IMP;
