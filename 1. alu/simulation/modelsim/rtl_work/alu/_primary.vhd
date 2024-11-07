library verilog;
use verilog.vl_types.all;
entity alu is
    generic(
        ADD             : vl_logic_vector(3 downto 0) := (Hi0, Hi0, Hi0, Hi0);
        SUB             : vl_logic_vector(3 downto 0) := (Hi1, Hi0, Hi0, Hi0);
        \SLL\           : vl_logic_vector(3 downto 0) := (Hi0, Hi0, Hi0, Hi1);
        SLT             : vl_logic_vector(3 downto 0) := (Hi0, Hi0, Hi1, Hi0);
        SLTU            : vl_logic_vector(3 downto 0) := (Hi0, Hi0, Hi1, Hi1);
        \XOR\           : vl_logic_vector(3 downto 0) := (Hi0, Hi1, Hi0, Hi0);
        \SRL\           : vl_logic_vector(3 downto 0) := (Hi0, Hi1, Hi0, Hi1);
        \SRA\           : vl_logic_vector(3 downto 0) := (Hi1, Hi1, Hi0, Hi1);
        \OR\            : vl_logic_vector(3 downto 0) := (Hi0, Hi1, Hi1, Hi0);
        \AND\           : vl_logic_vector(3 downto 0) := (Hi0, Hi1, Hi1, Hi1);
        LUI             : vl_logic_vector(3 downto 0) := (Hi1, Hi1, Hi1, Hi1)
    );
    port(
        i_alu_op        : in     vl_logic_vector(3 downto 0);
        i_operand_a     : in     vl_logic_vector(31 downto 0);
        i_operand_b     : in     vl_logic_vector(31 downto 0);
        o_alu_data      : out    vl_logic_vector(31 downto 0)
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of ADD : constant is 2;
    attribute mti_svvh_generic_type of SUB : constant is 2;
    attribute mti_svvh_generic_type of \SLL\ : constant is 2;
    attribute mti_svvh_generic_type of SLT : constant is 2;
    attribute mti_svvh_generic_type of SLTU : constant is 2;
    attribute mti_svvh_generic_type of \XOR\ : constant is 2;
    attribute mti_svvh_generic_type of \SRL\ : constant is 2;
    attribute mti_svvh_generic_type of \SRA\ : constant is 2;
    attribute mti_svvh_generic_type of \OR\ : constant is 2;
    attribute mti_svvh_generic_type of \AND\ : constant is 2;
    attribute mti_svvh_generic_type of LUI : constant is 2;
end alu;
