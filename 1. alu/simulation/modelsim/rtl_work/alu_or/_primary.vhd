library verilog;
use verilog.vl_types.all;
entity alu_or is
    port(
        i_or_a          : in     vl_logic_vector(31 downto 0);
        i_or_b          : in     vl_logic_vector(31 downto 0);
        o_or_result     : out    vl_logic_vector(31 downto 0)
    );
end alu_or;
