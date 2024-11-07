library verilog;
use verilog.vl_types.all;
entity alu_add_sub is
    port(
        i_add_sub_a     : in     vl_logic_vector(31 downto 0);
        i_add_sub_b     : in     vl_logic_vector(31 downto 0);
        i_carry_in      : in     vl_logic;
        o_add_sub_result: out    vl_logic_vector(31 downto 0);
        o_carry_out     : out    vl_logic
    );
end alu_add_sub;
