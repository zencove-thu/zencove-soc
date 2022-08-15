// Generator : SpinalHDL v1.6.1    git head : 3bf789d53b1b5a36974196e2d591342e15ddf28c
// Component : confreg
// Git hash  : fc5be7ef417c16bc7db96a7eb9c1c464db172780

`timescale 1ns/1ps 

module confreg (
  input               aclk,
  input               aresetn,
  input               timer_clk,
  input               awvalid,
  output              awready,
  input      [31:0]   awaddr,
  input      [5:0]    awid,
  input      [7:0]    awlen,
  input      [2:0]    awsize,
  input      [1:0]    awburst,
  input      [0:0]    awlock,
  input      [3:0]    awcache,
  input      [2:0]    awprot,
  input               wvalid,
  output              wready,
  input      [31:0]   wdata,
  input      [3:0]    wstrb,
  input               wlast,
  output              bvalid,
  input               bready,
  output     [5:0]    bid,
  output     [1:0]    bresp,
  input               arvalid,
  output              arready,
  input      [31:0]   araddr,
  input      [5:0]    arid,
  input      [7:0]    arlen,
  input      [2:0]    arsize,
  input      [1:0]    arburst,
  input      [0:0]    arlock,
  input      [3:0]    arcache,
  input      [2:0]    arprot,
  output              rvalid,
  input               rready,
  output     [31:0]   rdata,
  output     [5:0]    rid,
  output     [1:0]    rresp,
  output              rlast,
  output     [15:0]   led,
  output     [1:0]    led_rg0,
  output     [1:0]    led_rg1,
  output     [7:0]    num_csn,
  output reg [7:0]    num_seg,
  input      [7:0]    switch,
  output reg [3:0]    btn_key_col,
  input      [3:0]    btn_key_row,
  input      [1:0]    btn_step,
  output     [7:0]    led_mat_row,
  output     [7:0]    led_mat_col,
  output     [31:0]   user_cr0,
  output     [31:0]   user_cr1
);
  localparam defaultDomain_btnKeyFsm_enumDef_BOOT = 3'd0;
  localparam defaultDomain_btnKeyFsm_enumDef_COL0 = 3'd1;
  localparam defaultDomain_btnKeyFsm_enumDef_COL1 = 3'd2;
  localparam defaultDomain_btnKeyFsm_enumDef_COL2 = 3'd3;
  localparam defaultDomain_btnKeyFsm_enumDef_COL3 = 3'd4;
  localparam defaultDomain_btnKeyFsm_enumDef_FINISH = 3'd5;

  wire                timerClkWriteTimerBegin_buffercc_io_dataOut;
  wire       [31:0]   timerClkTimer_buffercc_io_dataOut;
  wire                defaultDomain_writeTimerBegin_buffercc_io_dataOut;
  wire       [31:0]   defaultDomain_regWData_buffercc_io_dataOut;
  wire       [19:0]   _zz_defaultDomain_keyCount_valueNext;
  wire       [0:0]    _zz_defaultDomain_keyCount_valueNext_1;
  wire       [4:0]    _zz_defaultDomain_stateCount_valueNext;
  wire       [0:0]    _zz_defaultDomain_stateCount_valueNext_1;
  wire       [19:0]   _zz_defaultDomain_step0_stepCount_valueNext;
  wire       [0:0]    _zz_defaultDomain_step0_stepCount_valueNext_1;
  wire       [19:0]   _zz_defaultDomain_step1_stepCount_valueNext;
  wire       [0:0]    _zz_defaultDomain_step1_stepCount_valueNext_1;
  wire       [19:0]   _zz_defaultDomain_count_valueNext;
  wire       [0:0]    _zz_defaultDomain_count_valueNext_1;
  wire                ctrlRegs_askWrite;
  wire                ctrlRegs_askRead;
  wire                ctrlRegs_doWrite;
  wire                ctrlRegs_doRead;
  reg        [31:0]   ctrlRegs_readDataInit;
  wire       [31:0]   ctrlRegs_readData;
  wire       [31:0]   ctrlRegs_writeData;
  wire       [31:0]   ctrlRegs_readToWriteData;
  wire       [15:0]   ctrlRegs_readAddress;
  wire       [15:0]   ctrlRegs_writeAddress;
  wire                timerClkWriteTimerBegin;
  wire       [31:0]   timerClkTimer;
  reg                 defaultDomain_busy;
  reg                 defaultDomain_isR;
  wire                defaultDomain_arEnter;
  wire                r_fire;
  wire                defaultDomain_rRetire;
  wire                defaultDomain_awEnter;
  wire                w_fire;
  wire                defaultDomain_wEnter;
  wire                defaultDomain_bRetire;
  wire                when_Confreg_l103;
  wire                when_Confreg_l105;
  reg        [5:0]    defaultDomain_regId;
  reg        [31:0]   defaultDomain_regAddr;
  reg        [7:0]    defaultDomain_regLen;
  reg        [2:0]    defaultDomain_regSize;
  reg                 defaultDomain_regWReady;
  wire                when_Confreg_l126;
  reg        [31:0]   defaultDomain_regRData;
  reg                 defaultDomain_regRLast;
  reg                 defaultDomain_regRValid;
  reg                 defaultDomain_regBValid;
  reg        [31:0]   defaultDomain_cr_0;
  reg        [31:0]   defaultDomain_cr_1;
  reg        [31:0]   defaultDomain_cr_2;
  reg        [31:0]   defaultDomain_cr_3;
  reg        [31:0]   defaultDomain_cr_4;
  reg        [31:0]   defaultDomain_cr_5;
  reg        [31:0]   defaultDomain_cr_6;
  reg        [31:0]   defaultDomain_cr_7;
  reg                 defaultDomain_writeTimer;
  wire                defaultDomain_writeTimerEnd;
  reg                 defaultDomain_writeTimerBegin;
  reg        [31:0]   defaultDomain_regWData;
  wire       [31:0]   defaultDomain_timer;
  reg        [15:0]   defaultDomain_switchLed;
  reg        [15:0]   defaultDomain_ledData;
  reg        [15:0]   defaultDomain_swInter;
  reg        [15:0]   defaultDomain_btnKeyTmp;
  reg        [15:0]   defaultDomain_regBtnKey;
  wire                defaultDomain_btnKeyRowInactive;
  reg                 defaultDomain_keyFlag;
  reg                 defaultDomain_keyCount_willIncrement;
  reg                 defaultDomain_keyCount_willClear;
  reg        [19:0]   defaultDomain_keyCount_valueNext;
  reg        [19:0]   defaultDomain_keyCount_value;
  wire                defaultDomain_keyCount_willOverflowIfInc;
  wire                defaultDomain_keyCount_willOverflow;
  wire                when_Confreg_l200;
  wire                defaultDomain_keySample;
  reg                 defaultDomain_keyStart;
  reg                 defaultDomain_keyEnd;
  wire                when_Confreg_l203;
  wire                defaultDomain_stateCount_willIncrement;
  wire                defaultDomain_stateCount_willClear;
  reg        [4:0]    defaultDomain_stateCount_valueNext;
  reg        [4:0]    defaultDomain_stateCount_value;
  wire                defaultDomain_stateCount_willOverflowIfInc;
  wire                defaultDomain_stateCount_willOverflow;
  wire                defaultDomain_stateSample;
  wire                when_Confreg_l206;
  wire                defaultDomain_btnKeyFsm_wantExit;
  wire                defaultDomain_btnKeyFsm_wantStart;
  wire                defaultDomain_btnKeyFsm_wantKill;
  reg                 defaultDomain_step0_regBtnStep;
  reg                 defaultDomain_step0_stepCount_willIncrement;
  reg                 defaultDomain_step0_stepCount_willClear;
  reg        [19:0]   defaultDomain_step0_stepCount_valueNext;
  reg        [19:0]   defaultDomain_step0_stepCount_value;
  wire                defaultDomain_step0_stepCount_willOverflowIfInc;
  wire                defaultDomain_step0_stepCount_willOverflow;
  wire                defaultDomain_step0_stepSample;
  reg                 defaultDomain_step0_stepFlag;
  wire                when_Confreg_l260;
  wire                when_Confreg_l261;
  reg                 defaultDomain_step1_regBtnStep;
  reg                 defaultDomain_step1_stepCount_willIncrement;
  reg                 defaultDomain_step1_stepCount_willClear;
  reg        [19:0]   defaultDomain_step1_stepCount_valueNext;
  reg        [19:0]   defaultDomain_step1_stepCount_value;
  wire                defaultDomain_step1_stepCount_willOverflowIfInc;
  wire                defaultDomain_step1_stepCount_willOverflow;
  wire                defaultDomain_step1_stepSample;
  reg                 defaultDomain_step1_stepFlag;
  wire                when_Confreg_l260_1;
  wire                when_Confreg_l261_1;
  reg        [1:0]    defaultDomain_ledRg0;
  reg        [1:0]    defaultDomain_ledRg1;
  reg        [31:0]   defaultDomain_numData;
  reg                 defaultDomain_count_willIncrement;
  wire                defaultDomain_count_willClear;
  reg        [19:0]   defaultDomain_count_valueNext;
  reg        [19:0]   defaultDomain_count_value;
  wire                defaultDomain_count_willOverflowIfInc;
  wire                defaultDomain_count_willOverflow;
  reg        [3:0]    defaultDomain_scanData;
  reg        [7:0]    defaultDomain_numCSn;
  wire                when_Confreg_l283;
  wire                when_Confreg_l283_1;
  wire                when_Confreg_l283_2;
  wire                when_Confreg_l283_3;
  wire                when_Confreg_l283_4;
  wire                when_Confreg_l283_5;
  wire                when_Confreg_l283_6;
  wire                when_Confreg_l283_7;
  reg        [6:0]    defaultDomain_numSeg;
  reg        [6:0]    _zz_defaultDomain_numSeg;
  reg        [63:0]   defaultDomain_ledMatData;
  reg        [7:0]    defaultDomain_ledMatRow;
  reg        [7:0]    defaultDomain_ledMatCol;
  wire                when_Confreg_l318;
  wire                when_Confreg_l318_1;
  wire                when_Confreg_l318_2;
  wire                when_Confreg_l318_3;
  wire                when_Confreg_l318_4;
  wire                when_Confreg_l318_5;
  wire                when_Confreg_l318_6;
  wire                when_Confreg_l318_7;
  wire                timerDomain_writeTimerBegin;
  wire       [31:0]   timerDomain_regWData;
  reg        [31:0]   timerDomain_timer;
  reg                 timerDomain_writeTimerBegin_regNext;
  wire                when_Confreg_l339;
  reg        [2:0]    defaultDomain_btnKeyFsm_stateReg;
  reg        [2:0]    defaultDomain_btnKeyFsm_stateNext;
  reg        [2:0]    _zz_defaultDomain_btnKeyFsm_stateNext;
  wire       [2:0]    _zz_defaultDomain_btnKeyFsm_stateNext_1;
  wire                when_Confreg_l223;
  wire                when_Confreg_l223_1;
  wire                when_Confreg_l223_2;
  wire                when_Confreg_l223_3;
  wire                when_Confreg_l228;
  wire                when_Confreg_l228_1;
  wire                when_Confreg_l228_2;
  wire                when_Confreg_l228_3;
  wire                when_Confreg_l233;
  wire                when_Confreg_l233_1;
  wire                when_Confreg_l233_2;
  wire                when_Confreg_l233_3;
  wire                when_Confreg_l238;
  wire                when_Confreg_l238_1;
  wire                when_Confreg_l238_2;
  wire                when_Confreg_l238_3;
  wire                when_Confreg_l243;
  wire                when_Confreg_l217;
  wire                when_StateMachine_l235;
  `ifndef SYNTHESIS
  reg [47:0] defaultDomain_btnKeyFsm_stateReg_string;
  reg [47:0] defaultDomain_btnKeyFsm_stateNext_string;
  reg [47:0] _zz_defaultDomain_btnKeyFsm_stateNext_string;
  reg [47:0] _zz_defaultDomain_btnKeyFsm_stateNext_1_string;
  `endif

  wire                defaultDomain_keyCount_willIncrement_const;
  wire                defaultDomain_step0_stepCount_willIncrement_const;
  wire                defaultDomain_step1_stepCount_willIncrement_const;
  wire                defaultDomain_count_willIncrement_const;

  assign _zz_defaultDomain_keyCount_valueNext_1 = defaultDomain_keyCount_willIncrement;
  assign _zz_defaultDomain_keyCount_valueNext = {19'd0, _zz_defaultDomain_keyCount_valueNext_1};
  assign _zz_defaultDomain_stateCount_valueNext_1 = defaultDomain_stateCount_willIncrement;
  assign _zz_defaultDomain_stateCount_valueNext = {4'd0, _zz_defaultDomain_stateCount_valueNext_1};
  assign _zz_defaultDomain_step0_stepCount_valueNext_1 = defaultDomain_step0_stepCount_willIncrement;
  assign _zz_defaultDomain_step0_stepCount_valueNext = {19'd0, _zz_defaultDomain_step0_stepCount_valueNext_1};
  assign _zz_defaultDomain_step1_stepCount_valueNext_1 = defaultDomain_step1_stepCount_willIncrement;
  assign _zz_defaultDomain_step1_stepCount_valueNext = {19'd0, _zz_defaultDomain_step1_stepCount_valueNext_1};
  assign _zz_defaultDomain_count_valueNext_1 = defaultDomain_count_willIncrement;
  assign _zz_defaultDomain_count_valueNext = {19'd0, _zz_defaultDomain_count_valueNext_1};
  BufferCC timerClkWriteTimerBegin_buffercc (
    .io_dataIn     (timerClkWriteTimerBegin                      ), //i
    .io_dataOut    (timerClkWriteTimerBegin_buffercc_io_dataOut  ), //o
    .aclk          (aclk                                         ), //i
    .aresetn       (aresetn                                      )  //i
  );
  BufferCC_1 timerClkTimer_buffercc (
    .io_dataIn     (timerClkTimer[31:0]                      ), //i
    .io_dataOut    (timerClkTimer_buffercc_io_dataOut[31:0]  ), //o
    .aclk          (aclk                                     ), //i
    .aresetn       (aresetn                                  )  //i
  );
  BufferCC_2 defaultDomain_writeTimerBegin_buffercc (
    .io_dataIn     (defaultDomain_writeTimerBegin                      ), //i
    .io_dataOut    (defaultDomain_writeTimerBegin_buffercc_io_dataOut  ), //o
    .timer_clk     (timer_clk                                          ), //i
    .aresetn       (aresetn                                            )  //i
  );
  BufferCC_3 defaultDomain_regWData_buffercc (
    .io_dataIn     (defaultDomain_regWData[31:0]                      ), //i
    .io_dataOut    (defaultDomain_regWData_buffercc_io_dataOut[31:0]  ), //o
    .timer_clk     (timer_clk                                         ), //i
    .aresetn       (aresetn                                           )  //i
  );
  `ifndef SYNTHESIS
  always @(*) begin
    case(defaultDomain_btnKeyFsm_stateReg)
      defaultDomain_btnKeyFsm_enumDef_BOOT : defaultDomain_btnKeyFsm_stateReg_string = "BOOT  ";
      defaultDomain_btnKeyFsm_enumDef_COL0 : defaultDomain_btnKeyFsm_stateReg_string = "COL0  ";
      defaultDomain_btnKeyFsm_enumDef_COL1 : defaultDomain_btnKeyFsm_stateReg_string = "COL1  ";
      defaultDomain_btnKeyFsm_enumDef_COL2 : defaultDomain_btnKeyFsm_stateReg_string = "COL2  ";
      defaultDomain_btnKeyFsm_enumDef_COL3 : defaultDomain_btnKeyFsm_stateReg_string = "COL3  ";
      defaultDomain_btnKeyFsm_enumDef_FINISH : defaultDomain_btnKeyFsm_stateReg_string = "FINISH";
      default : defaultDomain_btnKeyFsm_stateReg_string = "??????";
    endcase
  end
  always @(*) begin
    case(defaultDomain_btnKeyFsm_stateNext)
      defaultDomain_btnKeyFsm_enumDef_BOOT : defaultDomain_btnKeyFsm_stateNext_string = "BOOT  ";
      defaultDomain_btnKeyFsm_enumDef_COL0 : defaultDomain_btnKeyFsm_stateNext_string = "COL0  ";
      defaultDomain_btnKeyFsm_enumDef_COL1 : defaultDomain_btnKeyFsm_stateNext_string = "COL1  ";
      defaultDomain_btnKeyFsm_enumDef_COL2 : defaultDomain_btnKeyFsm_stateNext_string = "COL2  ";
      defaultDomain_btnKeyFsm_enumDef_COL3 : defaultDomain_btnKeyFsm_stateNext_string = "COL3  ";
      defaultDomain_btnKeyFsm_enumDef_FINISH : defaultDomain_btnKeyFsm_stateNext_string = "FINISH";
      default : defaultDomain_btnKeyFsm_stateNext_string = "??????";
    endcase
  end
  always @(*) begin
    case(_zz_defaultDomain_btnKeyFsm_stateNext)
      defaultDomain_btnKeyFsm_enumDef_BOOT : _zz_defaultDomain_btnKeyFsm_stateNext_string = "BOOT  ";
      defaultDomain_btnKeyFsm_enumDef_COL0 : _zz_defaultDomain_btnKeyFsm_stateNext_string = "COL0  ";
      defaultDomain_btnKeyFsm_enumDef_COL1 : _zz_defaultDomain_btnKeyFsm_stateNext_string = "COL1  ";
      defaultDomain_btnKeyFsm_enumDef_COL2 : _zz_defaultDomain_btnKeyFsm_stateNext_string = "COL2  ";
      defaultDomain_btnKeyFsm_enumDef_COL3 : _zz_defaultDomain_btnKeyFsm_stateNext_string = "COL3  ";
      defaultDomain_btnKeyFsm_enumDef_FINISH : _zz_defaultDomain_btnKeyFsm_stateNext_string = "FINISH";
      default : _zz_defaultDomain_btnKeyFsm_stateNext_string = "??????";
    endcase
  end
  always @(*) begin
    case(_zz_defaultDomain_btnKeyFsm_stateNext_1)
      defaultDomain_btnKeyFsm_enumDef_BOOT : _zz_defaultDomain_btnKeyFsm_stateNext_1_string = "BOOT  ";
      defaultDomain_btnKeyFsm_enumDef_COL0 : _zz_defaultDomain_btnKeyFsm_stateNext_1_string = "COL0  ";
      defaultDomain_btnKeyFsm_enumDef_COL1 : _zz_defaultDomain_btnKeyFsm_stateNext_1_string = "COL1  ";
      defaultDomain_btnKeyFsm_enumDef_COL2 : _zz_defaultDomain_btnKeyFsm_stateNext_1_string = "COL2  ";
      defaultDomain_btnKeyFsm_enumDef_COL3 : _zz_defaultDomain_btnKeyFsm_stateNext_1_string = "COL3  ";
      defaultDomain_btnKeyFsm_enumDef_FINISH : _zz_defaultDomain_btnKeyFsm_stateNext_1_string = "FINISH";
      default : _zz_defaultDomain_btnKeyFsm_stateNext_1_string = "??????";
    endcase
  end
  `endif

  assign ctrlRegs_doWrite = ctrlRegs_askWrite;
  assign ctrlRegs_doRead = ctrlRegs_askRead;
  always @(*) begin
    ctrlRegs_readDataInit = 32'h0;
    case(ctrlRegs_readAddress)
      16'h8000 : begin
        ctrlRegs_readDataInit[31 : 0] = defaultDomain_cr_0;
      end
      16'h8004 : begin
        ctrlRegs_readDataInit[31 : 0] = defaultDomain_cr_1;
      end
      16'h8008 : begin
        ctrlRegs_readDataInit[31 : 0] = defaultDomain_cr_2;
      end
      16'h800c : begin
        ctrlRegs_readDataInit[31 : 0] = defaultDomain_cr_3;
      end
      16'h8010 : begin
        ctrlRegs_readDataInit[31 : 0] = defaultDomain_cr_4;
      end
      16'h8014 : begin
        ctrlRegs_readDataInit[31 : 0] = defaultDomain_cr_5;
      end
      16'h8018 : begin
        ctrlRegs_readDataInit[31 : 0] = defaultDomain_cr_6;
      end
      16'h801c : begin
        ctrlRegs_readDataInit[31 : 0] = defaultDomain_cr_7;
      end
      16'he000 : begin
        ctrlRegs_readDataInit[31 : 0] = defaultDomain_timer;
      end
      16'hf000 : begin
        ctrlRegs_readDataInit[15 : 0] = defaultDomain_ledData;
      end
      16'hf020 : begin
        ctrlRegs_readDataInit[7 : 0] = switch;
      end
      16'hf02c : begin
        ctrlRegs_readDataInit[15 : 0] = defaultDomain_swInter;
      end
      16'hf024 : begin
        ctrlRegs_readDataInit[15 : 0] = defaultDomain_regBtnKey;
      end
      16'hf028 : begin
        ctrlRegs_readDataInit[1 : 1] = (! defaultDomain_step0_regBtnStep);
        ctrlRegs_readDataInit[0 : 0] = (! defaultDomain_step1_regBtnStep);
      end
      16'hf004 : begin
        ctrlRegs_readDataInit[1 : 0] = defaultDomain_ledRg0;
      end
      16'hf008 : begin
        ctrlRegs_readDataInit[1 : 0] = defaultDomain_ledRg1;
      end
      16'hf010 : begin
        ctrlRegs_readDataInit[31 : 0] = defaultDomain_numData;
      end
      16'hf030 : begin
        ctrlRegs_readDataInit[31 : 0] = defaultDomain_ledMatData[31 : 0];
      end
      16'hf034 : begin
        ctrlRegs_readDataInit[31 : 0] = defaultDomain_ledMatData[63 : 32];
      end
      default : begin
      end
    endcase
  end

  assign ctrlRegs_readData = ctrlRegs_readDataInit;
  assign ctrlRegs_readToWriteData = ctrlRegs_readData;
  assign defaultDomain_arEnter = (arvalid && arready);
  assign r_fire = (rvalid && rready);
  assign defaultDomain_rRetire = (r_fire && rlast);
  assign defaultDomain_awEnter = (awvalid && awready);
  assign w_fire = (wvalid && wready);
  assign defaultDomain_wEnter = (w_fire && wlast);
  assign defaultDomain_bRetire = (bvalid && bready);
  assign arready = ((! defaultDomain_busy) && ((! defaultDomain_isR) || (! awvalid)));
  assign awready = ((! defaultDomain_busy) && (defaultDomain_isR || (! arvalid)));
  assign when_Confreg_l103 = (defaultDomain_arEnter || defaultDomain_awEnter);
  assign when_Confreg_l105 = (defaultDomain_rRetire || defaultDomain_bRetire);
  assign when_Confreg_l126 = (defaultDomain_wEnter && wlast);
  assign wready = defaultDomain_regWReady;
  assign ctrlRegs_readAddress = defaultDomain_regAddr[15 : 0];
  assign ctrlRegs_askRead = ((defaultDomain_busy && defaultDomain_isR) && (! defaultDomain_rRetire));
  assign rdata = defaultDomain_regRData;
  assign rvalid = defaultDomain_regRValid;
  assign rlast = defaultDomain_regRLast;
  assign ctrlRegs_askWrite = defaultDomain_wEnter;
  assign ctrlRegs_writeAddress = defaultDomain_regAddr[15 : 0];
  assign ctrlRegs_writeData = wdata;
  assign bvalid = defaultDomain_regBValid;
  assign rid = defaultDomain_regId;
  assign bid = defaultDomain_regId;
  assign bresp = 2'b00;
  assign rresp = 2'b00;
  assign user_cr0 = defaultDomain_cr_0;
  assign user_cr1 = defaultDomain_cr_1;
  always @(*) begin
    defaultDomain_writeTimer = 1'b0;
    case(ctrlRegs_writeAddress)
      16'he000 : begin
        if(ctrlRegs_doWrite) begin
          defaultDomain_writeTimer = 1'b1;
        end
      end
      default : begin
      end
    endcase
  end

  assign defaultDomain_writeTimerEnd = timerClkWriteTimerBegin_buffercc_io_dataOut;
  assign defaultDomain_timer = timerClkTimer_buffercc_io_dataOut;
  always @(*) begin
    defaultDomain_switchLed[0] = switch[0];
    defaultDomain_switchLed[1] = switch[0];
    defaultDomain_switchLed[2] = switch[1];
    defaultDomain_switchLed[3] = switch[1];
    defaultDomain_switchLed[4] = switch[2];
    defaultDomain_switchLed[5] = switch[2];
    defaultDomain_switchLed[6] = switch[3];
    defaultDomain_switchLed[7] = switch[3];
    defaultDomain_switchLed[8] = switch[4];
    defaultDomain_switchLed[9] = switch[4];
    defaultDomain_switchLed[10] = switch[5];
    defaultDomain_switchLed[11] = switch[5];
    defaultDomain_switchLed[12] = switch[6];
    defaultDomain_switchLed[13] = switch[6];
    defaultDomain_switchLed[14] = switch[7];
    defaultDomain_switchLed[15] = switch[7];
  end

  assign led = defaultDomain_ledData;
  always @(*) begin
    defaultDomain_swInter[0] = 1'b0;
    defaultDomain_swInter[1] = switch[0];
    defaultDomain_swInter[2] = 1'b0;
    defaultDomain_swInter[3] = switch[1];
    defaultDomain_swInter[4] = 1'b0;
    defaultDomain_swInter[5] = switch[2];
    defaultDomain_swInter[6] = 1'b0;
    defaultDomain_swInter[7] = switch[3];
    defaultDomain_swInter[8] = 1'b0;
    defaultDomain_swInter[9] = switch[4];
    defaultDomain_swInter[10] = 1'b0;
    defaultDomain_swInter[11] = switch[5];
    defaultDomain_swInter[12] = 1'b0;
    defaultDomain_swInter[13] = switch[6];
    defaultDomain_swInter[14] = 1'b0;
    defaultDomain_swInter[15] = switch[7];
  end

  always @(*) begin
    defaultDomain_btnKeyTmp = 16'h0;
    case(defaultDomain_btnKeyFsm_stateReg)
      defaultDomain_btnKeyFsm_enumDef_COL0 : begin
        if(when_Confreg_l223) begin
          defaultDomain_btnKeyTmp[0] = 1'b1;
        end
        if(when_Confreg_l223_1) begin
          defaultDomain_btnKeyTmp[4] = 1'b1;
        end
        if(when_Confreg_l223_2) begin
          defaultDomain_btnKeyTmp[8] = 1'b1;
        end
        if(when_Confreg_l223_3) begin
          defaultDomain_btnKeyTmp[12] = 1'b1;
        end
      end
      defaultDomain_btnKeyFsm_enumDef_COL1 : begin
        if(when_Confreg_l228) begin
          defaultDomain_btnKeyTmp[1] = 1'b1;
        end
        if(when_Confreg_l228_1) begin
          defaultDomain_btnKeyTmp[5] = 1'b1;
        end
        if(when_Confreg_l228_2) begin
          defaultDomain_btnKeyTmp[9] = 1'b1;
        end
        if(when_Confreg_l228_3) begin
          defaultDomain_btnKeyTmp[13] = 1'b1;
        end
      end
      defaultDomain_btnKeyFsm_enumDef_COL2 : begin
        if(when_Confreg_l233) begin
          defaultDomain_btnKeyTmp[2] = 1'b1;
        end
        if(when_Confreg_l233_1) begin
          defaultDomain_btnKeyTmp[6] = 1'b1;
        end
        if(when_Confreg_l233_2) begin
          defaultDomain_btnKeyTmp[10] = 1'b1;
        end
        if(when_Confreg_l233_3) begin
          defaultDomain_btnKeyTmp[14] = 1'b1;
        end
      end
      defaultDomain_btnKeyFsm_enumDef_COL3 : begin
        if(when_Confreg_l238) begin
          defaultDomain_btnKeyTmp[3] = 1'b1;
        end
        if(when_Confreg_l238_1) begin
          defaultDomain_btnKeyTmp[7] = 1'b1;
        end
        if(when_Confreg_l238_2) begin
          defaultDomain_btnKeyTmp[11] = 1'b1;
        end
        if(when_Confreg_l238_3) begin
          defaultDomain_btnKeyTmp[15] = 1'b1;
        end
      end
      defaultDomain_btnKeyFsm_enumDef_FINISH : begin
      end
      default : begin
      end
    endcase
  end

  assign defaultDomain_btnKeyRowInactive = (&btn_key_row);
  assign defaultDomain_keyCount_willIncrement_const = 1'b0;
  always @(*) begin
      defaultDomain_keyCount_willIncrement = defaultDomain_keyCount_willIncrement_const;
      defaultDomain_keyCount_willIncrement = 1'b1;
  end

  always @(*) begin
    defaultDomain_keyCount_willClear = 1'b0;
    if(when_Confreg_l200) begin
      defaultDomain_keyCount_willClear = 1'b1;
    end
  end

  assign defaultDomain_keyCount_willOverflowIfInc = (defaultDomain_keyCount_value == 20'hfffff);
  assign defaultDomain_keyCount_willOverflow = (defaultDomain_keyCount_willOverflowIfInc && defaultDomain_keyCount_willIncrement);
  always @(*) begin
    defaultDomain_keyCount_valueNext = (defaultDomain_keyCount_value + _zz_defaultDomain_keyCount_valueNext);
    if(defaultDomain_keyCount_willClear) begin
      defaultDomain_keyCount_valueNext = 20'h0;
    end
  end

  assign when_Confreg_l200 = (! defaultDomain_keyFlag);
  assign defaultDomain_keySample = defaultDomain_keyCount_value[19];
  always @(*) begin
    defaultDomain_keyStart = 1'b0;
    case(defaultDomain_btnKeyFsm_stateReg)
      defaultDomain_btnKeyFsm_enumDef_COL0 : begin
      end
      defaultDomain_btnKeyFsm_enumDef_COL1 : begin
      end
      defaultDomain_btnKeyFsm_enumDef_COL2 : begin
      end
      defaultDomain_btnKeyFsm_enumDef_COL3 : begin
      end
      defaultDomain_btnKeyFsm_enumDef_FINISH : begin
      end
      default : begin
        defaultDomain_keyStart = (! defaultDomain_btnKeyRowInactive);
      end
    endcase
  end

  always @(*) begin
    defaultDomain_keyEnd = 1'b0;
    case(defaultDomain_btnKeyFsm_stateReg)
      defaultDomain_btnKeyFsm_enumDef_COL0 : begin
      end
      defaultDomain_btnKeyFsm_enumDef_COL1 : begin
      end
      defaultDomain_btnKeyFsm_enumDef_COL2 : begin
      end
      defaultDomain_btnKeyFsm_enumDef_COL3 : begin
      end
      defaultDomain_btnKeyFsm_enumDef_FINISH : begin
        defaultDomain_keyEnd = defaultDomain_btnKeyRowInactive;
      end
      default : begin
      end
    endcase
  end

  assign when_Confreg_l203 = (defaultDomain_keyStart || defaultDomain_keyEnd);
  assign defaultDomain_stateCount_willClear = 1'b0;
  assign defaultDomain_stateCount_willOverflowIfInc = (defaultDomain_stateCount_value == 5'h10);
  assign defaultDomain_stateCount_willOverflow = (defaultDomain_stateCount_willOverflowIfInc && defaultDomain_stateCount_willIncrement);
  always @(*) begin
    if(defaultDomain_stateCount_willOverflow) begin
      defaultDomain_stateCount_valueNext = 5'h0;
    end else begin
      defaultDomain_stateCount_valueNext = (defaultDomain_stateCount_value + _zz_defaultDomain_stateCount_valueNext);
    end
    if(defaultDomain_stateCount_willClear) begin
      defaultDomain_stateCount_valueNext = 5'h0;
    end
  end

  assign defaultDomain_stateCount_willIncrement = 1'b1;
  assign defaultDomain_stateSample = defaultDomain_stateCount_value[4];
  assign when_Confreg_l206 = (defaultDomain_keySample && defaultDomain_stateSample);
  always @(*) begin
    btn_key_col = 4'b0000;
    case(defaultDomain_btnKeyFsm_stateReg)
      defaultDomain_btnKeyFsm_enumDef_COL0 : begin
        btn_key_col = 4'b1110;
      end
      defaultDomain_btnKeyFsm_enumDef_COL1 : begin
        btn_key_col = 4'b1101;
      end
      defaultDomain_btnKeyFsm_enumDef_COL2 : begin
        btn_key_col = 4'b1011;
      end
      defaultDomain_btnKeyFsm_enumDef_COL3 : begin
        btn_key_col = 4'b0111;
      end
      defaultDomain_btnKeyFsm_enumDef_FINISH : begin
      end
      default : begin
      end
    endcase
  end

  assign defaultDomain_btnKeyFsm_wantExit = 1'b0;
  assign defaultDomain_btnKeyFsm_wantStart = 1'b0;
  assign defaultDomain_btnKeyFsm_wantKill = 1'b0;
  assign defaultDomain_step0_stepCount_willIncrement_const = 1'b0;
  always @(*) begin
      defaultDomain_step0_stepCount_willIncrement = defaultDomain_step0_stepCount_willIncrement_const;
      defaultDomain_step0_stepCount_willIncrement = 1'b1;
  end

  always @(*) begin
    defaultDomain_step0_stepCount_willClear = 1'b0;
    if(when_Confreg_l261) begin
      defaultDomain_step0_stepCount_willClear = 1'b1;
    end
  end

  assign defaultDomain_step0_stepCount_willOverflowIfInc = (defaultDomain_step0_stepCount_value == 20'hfffff);
  assign defaultDomain_step0_stepCount_willOverflow = (defaultDomain_step0_stepCount_willOverflowIfInc && defaultDomain_step0_stepCount_willIncrement);
  always @(*) begin
    defaultDomain_step0_stepCount_valueNext = (defaultDomain_step0_stepCount_value + _zz_defaultDomain_step0_stepCount_valueNext);
    if(defaultDomain_step0_stepCount_willClear) begin
      defaultDomain_step0_stepCount_valueNext = 20'h0;
    end
  end

  assign defaultDomain_step0_stepSample = defaultDomain_step0_stepCount_value[19];
  assign when_Confreg_l260 = (btn_step[0] ^ defaultDomain_step0_regBtnStep);
  assign when_Confreg_l261 = (! defaultDomain_step0_stepFlag);
  assign defaultDomain_step1_stepCount_willIncrement_const = 1'b0;
  always @(*) begin
      defaultDomain_step1_stepCount_willIncrement = defaultDomain_step1_stepCount_willIncrement_const;
      defaultDomain_step1_stepCount_willIncrement = 1'b1;
  end

  always @(*) begin
    defaultDomain_step1_stepCount_willClear = 1'b0;
    if(when_Confreg_l261_1) begin
      defaultDomain_step1_stepCount_willClear = 1'b1;
    end
  end

  assign defaultDomain_step1_stepCount_willOverflowIfInc = (defaultDomain_step1_stepCount_value == 20'hfffff);
  assign defaultDomain_step1_stepCount_willOverflow = (defaultDomain_step1_stepCount_willOverflowIfInc && defaultDomain_step1_stepCount_willIncrement);
  always @(*) begin
    defaultDomain_step1_stepCount_valueNext = (defaultDomain_step1_stepCount_value + _zz_defaultDomain_step1_stepCount_valueNext);
    if(defaultDomain_step1_stepCount_willClear) begin
      defaultDomain_step1_stepCount_valueNext = 20'h0;
    end
  end

  assign defaultDomain_step1_stepSample = defaultDomain_step1_stepCount_value[19];
  assign when_Confreg_l260_1 = (btn_step[1] ^ defaultDomain_step1_regBtnStep);
  assign when_Confreg_l261_1 = (! defaultDomain_step1_stepFlag);
  assign led_rg0 = defaultDomain_ledRg0;
  assign led_rg1 = defaultDomain_ledRg1;
  assign defaultDomain_count_willIncrement_const = 1'b0;
  always @(*) begin
      defaultDomain_count_willIncrement = defaultDomain_count_willIncrement_const;
      defaultDomain_count_willIncrement = 1'b1;
  end

  assign defaultDomain_count_willClear = 1'b0;
  assign defaultDomain_count_willOverflowIfInc = (defaultDomain_count_value == 20'hfffff);
  assign defaultDomain_count_willOverflow = (defaultDomain_count_willOverflowIfInc && defaultDomain_count_willIncrement);
  always @(*) begin
    defaultDomain_count_valueNext = (defaultDomain_count_value + _zz_defaultDomain_count_valueNext);
    if(defaultDomain_count_willClear) begin
      defaultDomain_count_valueNext = 20'h0;
    end
  end

  assign when_Confreg_l283 = (defaultDomain_count_value[19 : 17] == 3'b111);
  assign when_Confreg_l283_1 = (defaultDomain_count_value[19 : 17] == 3'b110);
  assign when_Confreg_l283_2 = (defaultDomain_count_value[19 : 17] == 3'b101);
  assign when_Confreg_l283_3 = (defaultDomain_count_value[19 : 17] == 3'b100);
  assign when_Confreg_l283_4 = (defaultDomain_count_value[19 : 17] == 3'b011);
  assign when_Confreg_l283_5 = (defaultDomain_count_value[19 : 17] == 3'b010);
  assign when_Confreg_l283_6 = (defaultDomain_count_value[19 : 17] == 3'b001);
  assign when_Confreg_l283_7 = (defaultDomain_count_value[19 : 17] == 3'b000);
  always @(*) begin
    case(defaultDomain_scanData)
      4'b0000 : begin
        _zz_defaultDomain_numSeg = 7'h7e;
      end
      4'b0001 : begin
        _zz_defaultDomain_numSeg = 7'h30;
      end
      4'b0010 : begin
        _zz_defaultDomain_numSeg = 7'h6d;
      end
      4'b0011 : begin
        _zz_defaultDomain_numSeg = 7'h79;
      end
      4'b0100 : begin
        _zz_defaultDomain_numSeg = 7'h33;
      end
      4'b0101 : begin
        _zz_defaultDomain_numSeg = 7'h5b;
      end
      4'b0110 : begin
        _zz_defaultDomain_numSeg = 7'h5f;
      end
      4'b0111 : begin
        _zz_defaultDomain_numSeg = 7'h70;
      end
      4'b1000 : begin
        _zz_defaultDomain_numSeg = 7'h7f;
      end
      4'b1001 : begin
        _zz_defaultDomain_numSeg = 7'h7b;
      end
      4'b1010 : begin
        _zz_defaultDomain_numSeg = 7'h77;
      end
      4'b1011 : begin
        _zz_defaultDomain_numSeg = 7'h1f;
      end
      4'b1100 : begin
        _zz_defaultDomain_numSeg = 7'h4e;
      end
      4'b1101 : begin
        _zz_defaultDomain_numSeg = 7'h3d;
      end
      4'b1110 : begin
        _zz_defaultDomain_numSeg = 7'h4f;
      end
      default : begin
        _zz_defaultDomain_numSeg = 7'h47;
      end
    endcase
  end

  assign num_csn = defaultDomain_numCSn;
  always @(*) begin
    num_seg[6 : 0] = defaultDomain_numSeg;
    num_seg[7] = 1'b0;
  end

  assign when_Confreg_l318 = (defaultDomain_count_value[19 : 17] == 3'b000);
  assign when_Confreg_l318_1 = (defaultDomain_count_value[19 : 17] == 3'b001);
  assign when_Confreg_l318_2 = (defaultDomain_count_value[19 : 17] == 3'b010);
  assign when_Confreg_l318_3 = (defaultDomain_count_value[19 : 17] == 3'b011);
  assign when_Confreg_l318_4 = (defaultDomain_count_value[19 : 17] == 3'b100);
  assign when_Confreg_l318_5 = (defaultDomain_count_value[19 : 17] == 3'b101);
  assign when_Confreg_l318_6 = (defaultDomain_count_value[19 : 17] == 3'b110);
  assign when_Confreg_l318_7 = (defaultDomain_count_value[19 : 17] == 3'b111);
  assign led_mat_row = defaultDomain_ledMatRow;
  assign led_mat_col = defaultDomain_ledMatCol;
  assign timerDomain_writeTimerBegin = defaultDomain_writeTimerBegin_buffercc_io_dataOut;
  assign timerClkWriteTimerBegin = timerDomain_writeTimerBegin;
  assign timerDomain_regWData = defaultDomain_regWData_buffercc_io_dataOut;
  assign timerClkTimer = timerDomain_timer;
  assign when_Confreg_l339 = (timerDomain_writeTimerBegin && (! timerDomain_writeTimerBegin_regNext));
  always @(*) begin
    _zz_defaultDomain_btnKeyFsm_stateNext = defaultDomain_btnKeyFsm_stateReg;
    case(defaultDomain_btnKeyFsm_stateReg)
      defaultDomain_btnKeyFsm_enumDef_COL0 : begin
        if(defaultDomain_btnKeyRowInactive) begin
          _zz_defaultDomain_btnKeyFsm_stateNext = defaultDomain_btnKeyFsm_enumDef_COL1;
        end else begin
          _zz_defaultDomain_btnKeyFsm_stateNext = defaultDomain_btnKeyFsm_enumDef_FINISH;
        end
      end
      defaultDomain_btnKeyFsm_enumDef_COL1 : begin
        if(defaultDomain_btnKeyRowInactive) begin
          _zz_defaultDomain_btnKeyFsm_stateNext = defaultDomain_btnKeyFsm_enumDef_COL2;
        end else begin
          _zz_defaultDomain_btnKeyFsm_stateNext = defaultDomain_btnKeyFsm_enumDef_FINISH;
        end
      end
      defaultDomain_btnKeyFsm_enumDef_COL2 : begin
        if(defaultDomain_btnKeyRowInactive) begin
          _zz_defaultDomain_btnKeyFsm_stateNext = defaultDomain_btnKeyFsm_enumDef_COL3;
        end else begin
          _zz_defaultDomain_btnKeyFsm_stateNext = defaultDomain_btnKeyFsm_enumDef_FINISH;
        end
      end
      defaultDomain_btnKeyFsm_enumDef_COL3 : begin
        if(defaultDomain_btnKeyRowInactive) begin
          _zz_defaultDomain_btnKeyFsm_stateNext = defaultDomain_btnKeyFsm_enumDef_BOOT;
        end else begin
          _zz_defaultDomain_btnKeyFsm_stateNext = defaultDomain_btnKeyFsm_enumDef_FINISH;
        end
      end
      defaultDomain_btnKeyFsm_enumDef_FINISH : begin
        if(when_Confreg_l243) begin
          _zz_defaultDomain_btnKeyFsm_stateNext = defaultDomain_btnKeyFsm_enumDef_BOOT;
        end
      end
      default : begin
        if(when_Confreg_l217) begin
          _zz_defaultDomain_btnKeyFsm_stateNext = defaultDomain_btnKeyFsm_enumDef_COL0;
        end
      end
    endcase
  end

  assign _zz_defaultDomain_btnKeyFsm_stateNext_1 = (defaultDomain_stateSample ? _zz_defaultDomain_btnKeyFsm_stateNext : defaultDomain_btnKeyFsm_stateReg);
  always @(*) begin
    defaultDomain_btnKeyFsm_stateNext = _zz_defaultDomain_btnKeyFsm_stateNext_1;
    if(defaultDomain_btnKeyFsm_wantKill) begin
      defaultDomain_btnKeyFsm_stateNext = defaultDomain_btnKeyFsm_enumDef_BOOT;
    end
  end

  assign when_Confreg_l223 = (! btn_key_row[0]);
  assign when_Confreg_l223_1 = (! btn_key_row[1]);
  assign when_Confreg_l223_2 = (! btn_key_row[2]);
  assign when_Confreg_l223_3 = (! btn_key_row[3]);
  assign when_Confreg_l228 = (! btn_key_row[0]);
  assign when_Confreg_l228_1 = (! btn_key_row[1]);
  assign when_Confreg_l228_2 = (! btn_key_row[2]);
  assign when_Confreg_l228_3 = (! btn_key_row[3]);
  assign when_Confreg_l233 = (! btn_key_row[0]);
  assign when_Confreg_l233_1 = (! btn_key_row[1]);
  assign when_Confreg_l233_2 = (! btn_key_row[2]);
  assign when_Confreg_l233_3 = (! btn_key_row[3]);
  assign when_Confreg_l238 = (! btn_key_row[0]);
  assign when_Confreg_l238_1 = (! btn_key_row[1]);
  assign when_Confreg_l238_2 = (! btn_key_row[2]);
  assign when_Confreg_l238_3 = (! btn_key_row[3]);
  assign when_Confreg_l243 = (defaultDomain_keySample && defaultDomain_btnKeyRowInactive);
  assign when_Confreg_l217 = (defaultDomain_keySample && (! defaultDomain_btnKeyRowInactive));
  assign when_StateMachine_l235 = ((! (defaultDomain_btnKeyFsm_stateReg == defaultDomain_btnKeyFsm_enumDef_FINISH)) && (defaultDomain_btnKeyFsm_stateNext == defaultDomain_btnKeyFsm_enumDef_FINISH));
  always @(posedge aclk) begin
    if(!aresetn) begin
      defaultDomain_busy <= 1'b0;
      defaultDomain_isR <= 1'b0;
      defaultDomain_regId <= 6'h0;
      defaultDomain_regAddr <= 32'h0;
      defaultDomain_regLen <= 8'h0;
      defaultDomain_regSize <= 3'b000;
      defaultDomain_regWReady <= 1'b0;
      defaultDomain_regRData <= 32'h0;
      defaultDomain_regRLast <= 1'b0;
      defaultDomain_regRValid <= 1'b0;
      defaultDomain_regBValid <= 1'b0;
      defaultDomain_cr_0 <= 32'h0;
      defaultDomain_cr_1 <= 32'h0;
      defaultDomain_cr_2 <= 32'h0;
      defaultDomain_cr_3 <= 32'h0;
      defaultDomain_cr_4 <= 32'h0;
      defaultDomain_cr_5 <= 32'h0;
      defaultDomain_cr_6 <= 32'h0;
      defaultDomain_cr_7 <= 32'h0;
      defaultDomain_writeTimerBegin <= 1'b0;
      defaultDomain_ledData <= defaultDomain_switchLed;
      defaultDomain_regBtnKey <= 16'h0;
      defaultDomain_keyFlag <= 1'b0;
      defaultDomain_keyCount_value <= 20'h0;
      defaultDomain_stateCount_value <= 5'h0;
      defaultDomain_step0_regBtnStep <= 1'b1;
      defaultDomain_step0_stepCount_value <= 20'h0;
      defaultDomain_step0_stepFlag <= 1'b0;
      defaultDomain_step1_regBtnStep <= 1'b1;
      defaultDomain_step1_stepCount_value <= 20'h0;
      defaultDomain_step1_stepFlag <= 1'b0;
      defaultDomain_ledRg0 <= 2'b00;
      defaultDomain_ledRg1 <= 2'b00;
      defaultDomain_numData <= 32'h0;
      defaultDomain_count_value <= 20'h0;
      defaultDomain_scanData <= 4'b0000;
      defaultDomain_numCSn <= 8'hff;
      defaultDomain_numSeg <= 7'h0;
      defaultDomain_ledMatData <= 64'h0;
      defaultDomain_ledMatRow <= 8'h0;
      defaultDomain_btnKeyFsm_stateReg <= defaultDomain_btnKeyFsm_enumDef_BOOT;
    end else begin
      if(when_Confreg_l103) begin
        defaultDomain_busy <= 1'b1;
      end else begin
        if(when_Confreg_l105) begin
          defaultDomain_busy <= 1'b0;
        end
      end
      if(defaultDomain_awEnter) begin
        defaultDomain_isR <= 1'b0;
        defaultDomain_regId <= awid;
        defaultDomain_regAddr <= awaddr;
        defaultDomain_regLen <= awlen;
        defaultDomain_regSize <= awsize;
      end
      if(defaultDomain_arEnter) begin
        defaultDomain_isR <= 1'b1;
        defaultDomain_regId <= arid;
        defaultDomain_regAddr <= araddr;
        defaultDomain_regLen <= arlen;
        defaultDomain_regSize <= arsize;
      end
      if(when_Confreg_l126) begin
        defaultDomain_regWReady <= 1'b0;
      end
      if(defaultDomain_awEnter) begin
        defaultDomain_regWReady <= 1'b1;
      end
      if(ctrlRegs_doRead) begin
        defaultDomain_regRData <= ctrlRegs_readData;
      end
      if(ctrlRegs_doRead) begin
        defaultDomain_regRLast <= 1'b1;
      end
      if(defaultDomain_rRetire) begin
        defaultDomain_regRValid <= 1'b0;
      end
      if(ctrlRegs_doRead) begin
        defaultDomain_regRValid <= 1'b1;
      end
      if(defaultDomain_bRetire) begin
        defaultDomain_regBValid <= 1'b0;
      end
      if(defaultDomain_wEnter) begin
        defaultDomain_regBValid <= 1'b1;
      end
      if(defaultDomain_writeTimerEnd) begin
        defaultDomain_writeTimerBegin <= 1'b0;
      end
      if(defaultDomain_writeTimer) begin
        defaultDomain_writeTimerBegin <= 1'b1;
      end
      defaultDomain_keyCount_value <= defaultDomain_keyCount_valueNext;
      if(when_Confreg_l203) begin
        defaultDomain_keyFlag <= 1'b1;
      end
      defaultDomain_stateCount_value <= defaultDomain_stateCount_valueNext;
      if(when_Confreg_l206) begin
        defaultDomain_keyFlag <= 1'b0;
      end
      defaultDomain_step0_stepCount_value <= defaultDomain_step0_stepCount_valueNext;
      if(when_Confreg_l260) begin
        defaultDomain_step0_stepFlag <= 1'b1;
      end
      if(defaultDomain_step0_stepSample) begin
        defaultDomain_step0_stepFlag <= 1'b0;
      end
      if(defaultDomain_step0_stepSample) begin
        defaultDomain_step0_regBtnStep <= btn_step[0];
      end
      defaultDomain_step1_stepCount_value <= defaultDomain_step1_stepCount_valueNext;
      if(when_Confreg_l260_1) begin
        defaultDomain_step1_stepFlag <= 1'b1;
      end
      if(defaultDomain_step1_stepSample) begin
        defaultDomain_step1_stepFlag <= 1'b0;
      end
      if(defaultDomain_step1_stepSample) begin
        defaultDomain_step1_regBtnStep <= btn_step[1];
      end
      defaultDomain_count_value <= defaultDomain_count_valueNext;
      if(when_Confreg_l283) begin
        defaultDomain_scanData <= defaultDomain_numData[3 : 0];
        defaultDomain_numCSn <= 8'hfe;
      end
      if(when_Confreg_l283_1) begin
        defaultDomain_scanData <= defaultDomain_numData[7 : 4];
        defaultDomain_numCSn <= 8'hfd;
      end
      if(when_Confreg_l283_2) begin
        defaultDomain_scanData <= defaultDomain_numData[11 : 8];
        defaultDomain_numCSn <= 8'hfb;
      end
      if(when_Confreg_l283_3) begin
        defaultDomain_scanData <= defaultDomain_numData[15 : 12];
        defaultDomain_numCSn <= 8'hf7;
      end
      if(when_Confreg_l283_4) begin
        defaultDomain_scanData <= defaultDomain_numData[19 : 16];
        defaultDomain_numCSn <= 8'hef;
      end
      if(when_Confreg_l283_5) begin
        defaultDomain_scanData <= defaultDomain_numData[23 : 20];
        defaultDomain_numCSn <= 8'hdf;
      end
      if(when_Confreg_l283_6) begin
        defaultDomain_scanData <= defaultDomain_numData[27 : 24];
        defaultDomain_numCSn <= 8'hbf;
      end
      if(when_Confreg_l283_7) begin
        defaultDomain_scanData <= defaultDomain_numData[31 : 28];
        defaultDomain_numCSn <= 8'h7f;
      end
      defaultDomain_numSeg <= _zz_defaultDomain_numSeg;
      if(when_Confreg_l318) begin
        defaultDomain_ledMatRow <= 8'h01;
      end
      if(when_Confreg_l318_1) begin
        defaultDomain_ledMatRow <= 8'h02;
      end
      if(when_Confreg_l318_2) begin
        defaultDomain_ledMatRow <= 8'h04;
      end
      if(when_Confreg_l318_3) begin
        defaultDomain_ledMatRow <= 8'h08;
      end
      if(when_Confreg_l318_4) begin
        defaultDomain_ledMatRow <= 8'h10;
      end
      if(when_Confreg_l318_5) begin
        defaultDomain_ledMatRow <= 8'h20;
      end
      if(when_Confreg_l318_6) begin
        defaultDomain_ledMatRow <= 8'h40;
      end
      if(when_Confreg_l318_7) begin
        defaultDomain_ledMatRow <= 8'h80;
      end
      case(ctrlRegs_writeAddress)
        16'h8000 : begin
          if(ctrlRegs_doWrite) begin
            defaultDomain_cr_0 <= ctrlRegs_writeData[31 : 0];
          end
        end
        16'h8004 : begin
          if(ctrlRegs_doWrite) begin
            defaultDomain_cr_1 <= ctrlRegs_writeData[31 : 0];
          end
        end
        16'h8008 : begin
          if(ctrlRegs_doWrite) begin
            defaultDomain_cr_2 <= ctrlRegs_writeData[31 : 0];
          end
        end
        16'h800c : begin
          if(ctrlRegs_doWrite) begin
            defaultDomain_cr_3 <= ctrlRegs_writeData[31 : 0];
          end
        end
        16'h8010 : begin
          if(ctrlRegs_doWrite) begin
            defaultDomain_cr_4 <= ctrlRegs_writeData[31 : 0];
          end
        end
        16'h8014 : begin
          if(ctrlRegs_doWrite) begin
            defaultDomain_cr_5 <= ctrlRegs_writeData[31 : 0];
          end
        end
        16'h8018 : begin
          if(ctrlRegs_doWrite) begin
            defaultDomain_cr_6 <= ctrlRegs_writeData[31 : 0];
          end
        end
        16'h801c : begin
          if(ctrlRegs_doWrite) begin
            defaultDomain_cr_7 <= ctrlRegs_writeData[31 : 0];
          end
        end
        16'hf000 : begin
          if(ctrlRegs_doWrite) begin
            defaultDomain_ledData <= ctrlRegs_writeData[15 : 0];
          end
        end
        16'hf004 : begin
          if(ctrlRegs_doWrite) begin
            defaultDomain_ledRg0 <= ctrlRegs_writeData[1 : 0];
          end
        end
        16'hf008 : begin
          if(ctrlRegs_doWrite) begin
            defaultDomain_ledRg1 <= ctrlRegs_writeData[1 : 0];
          end
        end
        16'hf010 : begin
          if(ctrlRegs_doWrite) begin
            defaultDomain_numData <= ctrlRegs_writeData[31 : 0];
          end
        end
        16'hf030 : begin
          if(ctrlRegs_doWrite) begin
            defaultDomain_ledMatData[31 : 0] <= ctrlRegs_writeData[31 : 0];
          end
        end
        16'hf034 : begin
          if(ctrlRegs_doWrite) begin
            defaultDomain_ledMatData[63 : 32] <= ctrlRegs_writeData[31 : 0];
          end
        end
        default : begin
        end
      endcase
      defaultDomain_btnKeyFsm_stateReg <= defaultDomain_btnKeyFsm_stateNext;
      case(defaultDomain_btnKeyFsm_stateReg)
        defaultDomain_btnKeyFsm_enumDef_COL0 : begin
        end
        defaultDomain_btnKeyFsm_enumDef_COL1 : begin
        end
        defaultDomain_btnKeyFsm_enumDef_COL2 : begin
        end
        defaultDomain_btnKeyFsm_enumDef_COL3 : begin
        end
        defaultDomain_btnKeyFsm_enumDef_FINISH : begin
        end
        default : begin
          defaultDomain_regBtnKey <= 16'h0;
        end
      endcase
      if(when_StateMachine_l235) begin
        defaultDomain_regBtnKey <= defaultDomain_btnKeyTmp;
      end
    end
  end

  always @(posedge aclk) begin
    if(defaultDomain_writeTimer) begin
      defaultDomain_regWData <= ctrlRegs_writeData;
    end
    if(when_Confreg_l318) begin
      defaultDomain_ledMatCol <= (~ defaultDomain_ledMatData[7 : 0]);
    end
    if(when_Confreg_l318_1) begin
      defaultDomain_ledMatCol <= (~ defaultDomain_ledMatData[15 : 8]);
    end
    if(when_Confreg_l318_2) begin
      defaultDomain_ledMatCol <= (~ defaultDomain_ledMatData[23 : 16]);
    end
    if(when_Confreg_l318_3) begin
      defaultDomain_ledMatCol <= (~ defaultDomain_ledMatData[31 : 24]);
    end
    if(when_Confreg_l318_4) begin
      defaultDomain_ledMatCol <= (~ defaultDomain_ledMatData[39 : 32]);
    end
    if(when_Confreg_l318_5) begin
      defaultDomain_ledMatCol <= (~ defaultDomain_ledMatData[47 : 40]);
    end
    if(when_Confreg_l318_6) begin
      defaultDomain_ledMatCol <= (~ defaultDomain_ledMatData[55 : 48]);
    end
    if(when_Confreg_l318_7) begin
      defaultDomain_ledMatCol <= (~ defaultDomain_ledMatData[63 : 56]);
    end
  end

  always @(posedge timer_clk) begin
    if(!aresetn) begin
      timerDomain_timer <= 32'h0;
    end else begin
      if(when_Confreg_l339) begin
        timerDomain_timer <= timerDomain_regWData;
      end else begin
        timerDomain_timer <= (timerDomain_timer + 32'h00000001);
      end
    end
  end

  always @(posedge timer_clk) begin
    timerDomain_writeTimerBegin_regNext <= timerDomain_writeTimerBegin;
  end


endmodule

module BufferCC_3 (
  input      [31:0]   io_dataIn,
  output     [31:0]   io_dataOut,
  input               timer_clk,
  input               aresetn
);

  (* async_reg = "true" *) reg        [31:0]   buffers_0;
  (* async_reg = "true" *) reg        [31:0]   buffers_1;

  assign io_dataOut = buffers_1;
  always @(posedge timer_clk) begin
    buffers_0 <= io_dataIn;
    buffers_1 <= buffers_0;
  end


endmodule

module BufferCC_2 (
  input               io_dataIn,
  output              io_dataOut,
  input               timer_clk,
  input               aresetn
);

  (* async_reg = "true" *) reg                 buffers_0;
  (* async_reg = "true" *) reg                 buffers_1;

  assign io_dataOut = buffers_1;
  always @(posedge timer_clk) begin
    buffers_0 <= io_dataIn;
    buffers_1 <= buffers_0;
  end


endmodule

module BufferCC_1 (
  input      [31:0]   io_dataIn,
  output     [31:0]   io_dataOut,
  input               aclk,
  input               aresetn
);

  (* async_reg = "true" *) reg        [31:0]   buffers_0;
  (* async_reg = "true" *) reg        [31:0]   buffers_1;

  assign io_dataOut = buffers_1;
  always @(posedge aclk) begin
    buffers_0 <= io_dataIn;
    buffers_1 <= buffers_0;
  end


endmodule

module BufferCC (
  input               io_dataIn,
  output              io_dataOut,
  input               aclk,
  input               aresetn
);

  (* async_reg = "true" *) reg                 buffers_0;
  (* async_reg = "true" *) reg                 buffers_1;

  assign io_dataOut = buffers_1;
  always @(posedge aclk) begin
    buffers_0 <= io_dataIn;
    buffers_1 <= buffers_0;
  end


endmodule
