`timescale 1ns / 1ps

module tenbit_par_to_ser(
    input parallel_load,
    input serial_clock,
    input [9:0] parallel,

    output serial
);
    reg previous_parallel_load;
    reg [9:0] parallel_reg;
    assign serial = parallel_reg[0];

    always @(posedge serial_clock) begin
        if (parallel_load && !previous_parallel_load) begin
            parallel_reg <= parallel[9:0];
        end else begin
            parallel_reg <= parallel_reg >> 1;
        end

        previous_parallel_load <= parallel_load;
    end
endmodule
