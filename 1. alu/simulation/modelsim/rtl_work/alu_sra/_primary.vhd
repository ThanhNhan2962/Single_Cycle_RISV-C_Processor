library verilog;
use verilog.vl_types.all;
entity alu_sra is
    port(
        i_sra_data      : in     vl_logic_vector(31 downto 0);
        i_sra_shift     : in     vl_logic_vector(4 downto 0);
        o_sra_result    : out    vl_logic_vector(31 downto 0)
    );
end alu_sra;
