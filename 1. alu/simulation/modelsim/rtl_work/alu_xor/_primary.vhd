library verilog;
use verilog.vl_types.all;
entity alu_xor is
    port(
        i_xor_a         : in     vl_logic_vector(31 downto 0);
        i_xor_b         : in     vl_logic_vector(31 downto 0);
        o_xor_result    : out    vl_logic_vector(31 downto 0)
    );
end alu_xor;
