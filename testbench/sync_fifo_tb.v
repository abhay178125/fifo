`timescale 1ns/1ps

module sync_fifo_tb;
    reg clk = 1'b0;
    reg rst_n = 1'b0;
    reg wr_en = 1'b0;
    reg rd_en = 1'b0;
    reg [7:0] din = 8'h00;

    wire [7:0] dout;
    wire full;
    wire empty;

    integer errors = 0;

    always #5 clk = ~clk;

    sync_fifo #(
        .DATA_WIDTH(8),
        .ADDR_WIDTH(2),
        .DEPTH(4)
    ) dut (
        .clk(clk),
        .rst_n(rst_n),
        .wr_en(wr_en),
        .rd_en(rd_en),
        .din(din),
        .dout(dout),
        .full(full),
        .empty(empty)
    );

    task write_byte;
        input [7:0] value;
        begin
            @(negedge clk);
            wr_en = 1'b1;
            rd_en = 1'b0;
            din = value;
            @(negedge clk);
            wr_en = 1'b0;
        end
    endtask

    task read_and_check;
        input [7:0] expected;
        begin
            @(negedge clk);
            rd_en = 1'b1;
            wr_en = 1'b0;
            @(negedge clk);
            #1;
            if (dout !== expected) begin
                $display("FAIL: dout=%h expected=%h", dout, expected);
                errors = errors + 1;
            end else begin
                $display("PASS: read %h", dout);
            end
            rd_en = 1'b0;
        end
    endtask

    initial begin
        $dumpfile("fifo_wave.vcd");
        $dumpvars(0, sync_fifo_tb);

        repeat (2) @(negedge clk);
        rst_n = 1'b1;
        @(negedge clk);
        if (!empty) begin
            $display("FAIL: FIFO should be empty after reset");
            errors = errors + 1;
        end

        write_byte(8'h11);
        write_byte(8'h22);
        write_byte(8'h33);

        if (empty) begin
            $display("FAIL: FIFO unexpectedly empty after writes");
            errors = errors + 1;
        end

        read_and_check(8'h11);
        read_and_check(8'h22);
        read_and_check(8'h33);

        @(negedge clk);
        if (!empty) begin
            $display("FAIL: FIFO should be empty after reads");
            errors = errors + 1;
        end

        if (errors == 0)
            $display("ALL FIFO TESTS PASSED");
        else
            $display("FIFO TESTS FAILED: %0d error(s)", errors);

        $finish;
    end
endmodule
