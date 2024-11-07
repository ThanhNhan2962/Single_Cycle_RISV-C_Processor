library verilog;
use verilog.vl_types.all;
entity alu_slt is
    port(
        i_slt_a         : in     vl_logic_vector(31 downto 0);
        i_slt_b         : in     vl_logic_vector(31 downto 0);
        o_slt_result    : out    vl_logic
    );
end alu_slt;
