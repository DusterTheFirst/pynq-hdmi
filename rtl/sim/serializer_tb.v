`timescale 1ns / 1ps

module serializer_tb();
    reg parallel_load, serial_clock;
    reg [9:0] parallel;

    wire serial;

    tenbit_par_to_ser SERIALIZER(
        .parallel_load(parallel_load),
        .serial_clock(serial_clock),
        .parallel(parallel),

        .serial(serial)
    );

    always begin
        parallel_load = 1; #50;
        parallel_load = 0; #50;
    end

    always begin
        serial_clock = 1; #5;
        serial_clock = 0; #5;
    end

    initial begin
        parallel = 10'b0000000000; #100;
        parallel = 10'b0000000000; #100;
        parallel = 10'b1111111111; #100;
        parallel = 10'b1010101010; #100;
        parallel = 10'b0101010101; #100;
        parallel = 10'b1111100000; #100;
        parallel = 10'b0000011111; #100;

        $finish;
    end

endmodule
