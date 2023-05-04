//Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
//--------------------------------------------------------------------------------
//Tool Version: Vivado v.2022.1 (lin64) Build 3526262 Mon Apr 18 15:47:01 MDT 2022
//Date        : Thu May  4 09:59:57 2023
//Host        : lenovo-fedora running 64-bit Ubuntu 20.04.6 LTS
//Command     : generate_target hdmi_pipeline_wrapper.bd
//Design      : hdmi_pipeline_wrapper
//Purpose     : IP block netlist
//--------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

module hdmi_pipeline_wrapper
   (btn,
    hdmi_tx_clk_n,
    hdmi_tx_clk_p,
    hdmi_tx_data_n,
    hdmi_tx_data_p,
    hdmi_tx_hpdn,
    led,
    sw,
    sysclk);
  input [3:0]btn;
  output [0:0]hdmi_tx_clk_n;
  output [0:0]hdmi_tx_clk_p;
  output [2:0]hdmi_tx_data_n;
  output [2:0]hdmi_tx_data_p;
  input [0:0]hdmi_tx_hpdn;
  output [3:0]led;
  input [1:0]sw;
  input sysclk;

  wire [3:0]btn;
  wire [0:0]hdmi_tx_clk_n;
  wire [0:0]hdmi_tx_clk_p;
  wire [2:0]hdmi_tx_data_n;
  wire [2:0]hdmi_tx_data_p;
  wire [0:0]hdmi_tx_hpdn;
  wire [3:0]led;
  wire [1:0]sw;
  wire sysclk;

  hdmi_pipeline hdmi_pipeline_i
       (.btn(btn),
        .hdmi_tx_clk_n(hdmi_tx_clk_n),
        .hdmi_tx_clk_p(hdmi_tx_clk_p),
        .hdmi_tx_data_n(hdmi_tx_data_n),
        .hdmi_tx_data_p(hdmi_tx_data_p),
        .hdmi_tx_hpdn(hdmi_tx_hpdn),
        .led(led),
        .sw(sw),
        .sysclk(sysclk));
endmodule
