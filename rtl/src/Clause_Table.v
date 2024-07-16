/*
Clause_Table.v
Author: Zeiler Randall-Reed

Description:
The clause table holds the information for all of the clauses in the current problem. The 
address and negation bit of a literal is sent to the address translation table which returns
an index and mask. The index is used to access this table by its row, which returns the 
addresses and negation bits of the other literals in every clause that the initial literal 
is in.

This table only has 2048 entries by default, despite there being 4096 address + negation 
bit pairs (12^2). This is because multiple clauses can be packed into the same row of the 
table, and must be to minimize space impact. The mask from the address translation table is
used as an enable bit for the subsequent clause evaluators so that only the two literals  
with negation bits associated with the initially requested literal and negation bit are 
checked.

Notes:
- [TODO] needs a way to write to the table for the initial loading of the problem data to 
    the FPGA

Testing:
- no testbench created yet, and it would be difficult to create an adequate testbench 
    without first solving the problem of loading data.
    
*/

module Clause_Table #(
    parameter MAX_CLAUSES_PER_VARIABLE = 20,             // Number of clauses in the clause table
    parameter NUM_ROWS = 2048,              // Number of rows in the clause table
    parameter LITERAL_ADDRESS_WIDTH = 11,    // Number of bits to address the clause table
    parameter NSAT = 3  // Number of SAT variables (3 for 3-SAT)
)
(
    input                               clk,        // Clock signal
    input                               reset,      // Reset signal
    input                               write_enable, //To write to the table ALSO once this value goes to 0.. we can kickstarrt the whole WSAT algorithm..
    input [LITERAL_ADDRESS_WIDTH-1:0]   address_i,    // n-bit number to address the clause 
    // clause[i][j] is the jth SAT variable w/ negation bit in the ith clause
    // negation bit is held in the MSB of the variable
    output reg [LITERAL_ADDRESS_WIDTH:0] clauses_o [MAX_CLAUSES_PER_VARIABLE-1:0][NSAT-2:0]    // clause output

    // load input at the beginning:
    
);

// Internal register to hold the clause table
// clause_table[i][j][k] is the kth SAT variable w/ negation bit in the jth clause in the ith row
// negation bit is held in the MSB of the variable
reg [LITERAL_ADDRESS_WIDTH:0] clause_table [NUM_ROWS-1:0][MAX_CLAUSES_PER_VARIABLE-1:0][NSAT-1:0];

integer i, j, k;

// Output the addressed 
// assuming synchronous read
always @(posedge clk) begin
    if (reset) begin
        for (i=0; i < NUM_ROWS; i = i + 1) begin
            for (j=0; j < MAX_CLAUSES_PER_VARIABLE; j = j + 1) begin
                for (k=0; k < NSAT; k = k + 1) begin
                    clause_table[i][j][k] <= 0;
                end
            end
        end
    end 
    else if (write_enable) begin
    // TODO write the write logic.
          
    end    
    else begin
        for (i = 0; i < MAX_CLAUSES_PER_VARIABLE; i = i + 1) begin
            for (j = 0; j < NSAT; j = j + 1) begin
                clauses_o[i][j] <= clause_table[address_i][i][j];
            end
        end
    end
end



endmodule