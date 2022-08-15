// Generator : SpinalHDL v1.6.1    git head : 3bf789d53b1b5a36974196e2d591342e15ddf28c
// Component : USBHost
// Git hash  : 736e295ce13c9251b009fb464f69ba20b45827bd

`timescale 1ns/1ps 

module USBHost (
  input               cfg_awvalid,
  output              cfg_awready,
  input      [31:0]   cfg_awaddr,
  input      [2:0]    cfg_awprot,
  input               cfg_wvalid,
  output              cfg_wready,
  input      [31:0]   cfg_wdata,
  input      [3:0]    cfg_wstrb,
  output              cfg_bvalid,
  input               cfg_bready,
  output     [1:0]    cfg_bresp,
  input               cfg_arvalid,
  output              cfg_arready,
  input      [31:0]   cfg_araddr,
  input      [2:0]    cfg_arprot,
  output              cfg_rvalid,
  input               cfg_rready,
  output     [31:0]   cfg_rdata,
  output     [1:0]    cfg_rresp,
  output              utmi_reset,
  output              utmi_suspend_n,
  output              utmi_chrgvbus,
  output              utmi_dischrgvbus,
  input               utmi_vbusvalid,
  output              utmi_idpullup,
  output              utmi_dppulldown,
  output              utmi_dmpulldown,
  input               utmi_iddig,
  input               utmi_hostdisc,
  output     [1:0]    utmi_opmode,
  input      [1:0]    utmi_linestate,
  output     [1:0]    utmi_xcvrsel,
  output              utmi_termsel,
  input               utmi_sessend,
  output reg          utmi_txvalid,
  input               utmi_txready,
  input               utmi_rxvalid,
  input               utmi_rxactive,
  input               utmi_rxerror,
  input      [7:0]    utmi_data_i,
  output reg [7:0]    utmi_data_o,
  output              utmi_data_t,
  output              intr,
  input               clk,
  input               resetn
);
  localparam USBLineState_SE0 = 2'd0;
  localparam USBLineState_J = 2'd1;
  localparam USBLineState_K = 2'd2;
  localparam USBLineState_SE1 = 2'd3;
  localparam fsm_enumDef_BOOT = 4'd0;
  localparam fsm_enumDef_RX_DATA = 4'd1;
  localparam fsm_enumDef_TX_PID = 4'd2;
  localparam fsm_enumDef_TX_DATA = 4'd3;
  localparam fsm_enumDef_TX_CRC1 = 4'd4;
  localparam fsm_enumDef_TX_CRC2 = 4'd5;
  localparam fsm_enumDef_TX_TOKEN1 = 4'd6;
  localparam fsm_enumDef_TX_TOKEN2 = 4'd7;
  localparam fsm_enumDef_TX_TOKEN3 = 4'd8;
  localparam fsm_enumDef_TX_ACKNAK = 4'd9;
  localparam fsm_enumDef_TX_WAIT = 4'd10;
  localparam fsm_enumDef_RX_WAIT = 4'd11;
  localparam fsm_enumDef_TX_IFS = 4'd12;

  wire       [7:0]    txFifo_io_push_payload;
  reg                 txFifo_io_pop_ready;
  wire                rxFifo_io_push_valid;
  reg                 rxFifo_io_pop_ready;
  wire       [10:0]   crc5_1_io_data;
  reg        [7:0]    crc16_1_io_data;
  wire                txFifo_io_push_ready;
  wire                txFifo_io_pop_valid;
  wire       [7:0]    txFifo_io_pop_payload;
  wire       [6:0]    txFifo_io_occupancy;
  wire       [6:0]    txFifo_io_availability;
  wire                rxFifo_io_push_ready;
  wire                rxFifo_io_pop_valid;
  wire       [7:0]    rxFifo_io_pop_payload;
  wire       [6:0]    rxFifo_io_occupancy;
  wire       [6:0]    rxFifo_io_availability;
  wire       [4:0]    crc5_1_io_crcOut;
  wire       [15:0]   crc16_1_io_crcOut;
  wire       [2:0]    _zz_regDataValid;
  wire                _zz_tokenRev;
  wire       [0:0]    _zz_tokenRev_1;
  wire       [4:0]    _zz_tokenRev_2;
  wire       [8:0]    _zz_lastTxTime_valueNext;
  wire       [0:0]    _zz_lastTxTime_valueNext_1;
  wire                ctrlRegs_askWrite;
  wire                ctrlRegs_askRead;
  wire                ctrlRegs_doWrite;
  wire                ctrlRegs_doRead;
  reg        [31:0]   ctrlRegs_readDataInit;
  wire       [31:0]   ctrlRegs_readData;
  wire       [31:0]   ctrlRegs_writeData;
  wire       [31:0]   ctrlRegs_readToWriteData;
  wire       [7:0]    ctrlRegs_readAddress;
  wire       [7:0]    ctrlRegs_writeAddress;
  reg                 regAwValid;
  reg                 regWValid;
  wire                cfg_aw_fire;
  wire                wrCmdAccepted;
  wire                cfg_w_fire;
  wire                wrDataAccepted;
  wire                cfg_aw_fire_1;
  wire                when_USBHost_l128;
  wire                cfg_w_fire_1;
  wire                when_USBHost_l129;
  wire                cfg_aw_fire_2;
  reg        [7:0]    regWrAddr;
  wire       [7:0]    wrAddr;
  wire                cfg_w_fire_2;
  reg        [31:0]   regWrData;
  wire                readEn;
  wire                writeEn;
  reg                 regUsbCtrlWr;
  reg                 txFlush;
  reg                 dmPulldown;
  reg                 dpPulldown;
  reg                 termSelect;
  reg                 enableSof;
  reg        [1:0]    xcvrSelect;
  reg        [1:0]    opMode;
  reg                 irqAck_sof;
  reg                 irqAck_done;
  reg                 irqAck_err;
  reg                 irqAck_deviceDetect;
  reg                 irqMask_sof;
  reg                 irqMask_done;
  reg                 irqMask_err;
  reg                 irqMask_deviceDetect;
  reg        [15:0]   txLen;
  wire                tokenStartAckIn;
  reg                 tokenStart;
  reg                 tokenIn;
  reg                 tokenAck;
  reg                 tokenPidDatax;
  reg        [7:0]    tokenPidBits;
  reg        [6:0]    tokenDevAddr;
  reg        [3:0]    tokenEpAddr;
  reg                 regRWDataWr;
  reg                 phyReset;
  reg                 regRValid;
  wire                cfg_r_isFree;
  reg        [31:0]   regRData;
  reg                 regBValid;
  reg                 rwDataRd;
  reg                 sieIdle;
  reg        [15:0]   sofTime;
  reg                 sofTransfer;
  wire                sendSof;
  reg        [10:0]   sofValue;
  reg                 sofIrq;
  wire                sofGuardBand;
  wire                clearToSend;
  wire       [7:0]    tokenPid;
  wire       [6:0]    _zz_tokenDev;
  wire       [6:0]    tokenDev;
  wire       [3:0]    _zz_tokenEp;
  wire       [3:0]    tokenEp;
  reg                 startAck;
  reg                 fifoFlush;
  reg                 transferStart;
  reg                 transferReqAck;
  reg                 inTransfer;
  reg                 respExpected;
  wire                when_USBHost_l327;
  reg                 usbErr;
  reg                 regIntrs_sof;
  reg                 regIntrs_done;
  reg                 regIntrs_err;
  reg                 regIntrs_deviceDetect;
  reg                 regIntrValid;
  wire                when_USBHost_l344;
  wire                shiftEn;
  reg        [7:0]    utmi_data_i_delay_1;
  reg        [7:0]    utmi_data_i_delay_2;
  reg        [7:0]    utmi_data_i_delay_3;
  reg        [7:0]    rxData;
  reg        [3:0]    regDataValid;
  wire                dataReady;
  reg                 _zz_crcByte;
  reg                 crcByte;
  reg                 utmi_rxactive_delay_1;
  reg                 utmi_rxactive_delay_2;
  reg                 utmi_rxactive_delay_3;
  reg                 rxActive;
  reg                 utmi_rxactive_regNext;
  wire                rxActiveRise;
  reg        [15:0]   txToken;
  wire       [15:0]   tokenRev;
  wire       [4:0]    crc5Next;
  reg                 waitEop;
  reg        [1:0]    regLineState;
  reg                 se0Detect;
  wire                eopDetected;
  reg        [15:0]   byteCount;
  reg                 sieInTransfer;
  reg                 sendAck;
  reg                 sendData1;
  reg                 sieSendSof;
  reg                 waitResp;
  reg        [7:0]    response;
  reg                 timeout;
  reg                 rxDone;
  reg                 txDone;
  reg                 crcErr;
  reg                 lastTxTime_willIncrement;
  reg                 lastTxTime_willClear;
  reg        [8:0]    lastTxTime_valueNext;
  reg        [8:0]    lastTxTime_value;
  wire                lastTxTime_willOverflowIfInc;
  wire                lastTxTime_willOverflow;
  wire                utmi_tx_fire;
  wire                when_USBHost_l419;
  wire                rxRespTimeout;
  reg        [15:0]   crcSum;
  reg                 crcError;
  wire                fsm_wantExit;
  wire                fsm_wantStart;
  wire                fsm_wantKill;
  wire                when_USBHost_l637;
  reg        [3:0]    txIfs;
  wire                when_USBHost_l646;
  wire                when_USBHost_l649;
  wire                ifsBusy;
  wire                irqSts_sof;
  wire                irqSts_done;
  wire                irqSts_err;
  reg                 irqSts_deviceDetect;
  wire       [3:0]    _zz_irqAck_sof;
  wire       [3:0]    _zz_irqMask_sof;
  reg        [3:0]    fsm_stateReg;
  reg        [3:0]    fsm_stateNext;
  wire                when_USBHost_l599;
  wire                when_USBHost_l603;
  wire                when_USBHost_l608;
  wire                when_USBHost_l610;
  wire                when_USBHost_l613;
  wire                when_USBHost_l523;
  wire                when_USBHost_l541;
  wire                when_USBHost_l624;
  wire                when_USBHost_l505;
  wire                when_USBHost_l463;
  wire                when_StateMachine_l219;
  wire                when_StateMachine_l219_1;
  wire                when_StateMachine_l219_2;
  `ifndef SYNTHESIS
  reg [23:0] utmi_linestate_string;
  reg [23:0] regLineState_string;
  reg [71:0] fsm_stateReg_string;
  reg [71:0] fsm_stateNext_string;
  `endif


  assign _zz_regDataValid = (regDataValid >>> 1);
  assign _zz_lastTxTime_valueNext_1 = lastTxTime_willIncrement;
  assign _zz_lastTxTime_valueNext = {8'd0, _zz_lastTxTime_valueNext_1};
  assign _zz_tokenRev = txToken[9];
  assign _zz_tokenRev_1 = txToken[10];
  assign _zz_tokenRev_2 = {txToken[11],{txToken[12],{txToken[13],{txToken[14],txToken[15]}}}};
  StreamFifo txFifo (
    .io_push_valid      (regRWDataWr                  ), //i
    .io_push_ready      (txFifo_io_push_ready         ), //o
    .io_push_payload    (txFifo_io_push_payload[7:0]  ), //i
    .io_pop_valid       (txFifo_io_pop_valid          ), //o
    .io_pop_ready       (txFifo_io_pop_ready          ), //i
    .io_pop_payload     (txFifo_io_pop_payload[7:0]   ), //o
    .io_flush           (txFlush                      ), //i
    .io_occupancy       (txFifo_io_occupancy[6:0]     ), //o
    .io_availability    (txFifo_io_availability[6:0]  ), //o
    .clk                (clk                          ), //i
    .resetn             (resetn                       )  //i
  );
  StreamFifo rxFifo (
    .io_push_valid      (rxFifo_io_push_valid         ), //i
    .io_push_ready      (rxFifo_io_push_ready         ), //o
    .io_push_payload    (rxData[7:0]                  ), //i
    .io_pop_valid       (rxFifo_io_pop_valid          ), //o
    .io_pop_ready       (rxFifo_io_pop_ready          ), //i
    .io_pop_payload     (rxFifo_io_pop_payload[7:0]   ), //o
    .io_flush           (fifoFlush                    ), //i
    .io_occupancy       (rxFifo_io_occupancy[6:0]     ), //o
    .io_availability    (rxFifo_io_availability[6:0]  ), //o
    .clk                (clk                          ), //i
    .resetn             (resetn                       )  //i
  );
  CRC5 crc5_1 (
    .io_crcIn     (5'h1f                  ), //i
    .io_data      (crc5_1_io_data[10:0]   ), //i
    .io_crcOut    (crc5_1_io_crcOut[4:0]  )  //o
  );
  CRC16 crc16_1 (
    .io_crcIn     (crcSum[15:0]             ), //i
    .io_data      (crc16_1_io_data[7:0]     ), //i
    .io_crcOut    (crc16_1_io_crcOut[15:0]  )  //o
  );
  `ifndef SYNTHESIS
  always @(*) begin
    case(utmi_linestate)
      USBLineState_SE0 : utmi_linestate_string = "SE0";
      USBLineState_J : utmi_linestate_string = "J  ";
      USBLineState_K : utmi_linestate_string = "K  ";
      USBLineState_SE1 : utmi_linestate_string = "SE1";
      default : utmi_linestate_string = "???";
    endcase
  end
  always @(*) begin
    case(regLineState)
      USBLineState_SE0 : regLineState_string = "SE0";
      USBLineState_J : regLineState_string = "J  ";
      USBLineState_K : regLineState_string = "K  ";
      USBLineState_SE1 : regLineState_string = "SE1";
      default : regLineState_string = "???";
    endcase
  end
  always @(*) begin
    case(fsm_stateReg)
      fsm_enumDef_BOOT : fsm_stateReg_string = "BOOT     ";
      fsm_enumDef_RX_DATA : fsm_stateReg_string = "RX_DATA  ";
      fsm_enumDef_TX_PID : fsm_stateReg_string = "TX_PID   ";
      fsm_enumDef_TX_DATA : fsm_stateReg_string = "TX_DATA  ";
      fsm_enumDef_TX_CRC1 : fsm_stateReg_string = "TX_CRC1  ";
      fsm_enumDef_TX_CRC2 : fsm_stateReg_string = "TX_CRC2  ";
      fsm_enumDef_TX_TOKEN1 : fsm_stateReg_string = "TX_TOKEN1";
      fsm_enumDef_TX_TOKEN2 : fsm_stateReg_string = "TX_TOKEN2";
      fsm_enumDef_TX_TOKEN3 : fsm_stateReg_string = "TX_TOKEN3";
      fsm_enumDef_TX_ACKNAK : fsm_stateReg_string = "TX_ACKNAK";
      fsm_enumDef_TX_WAIT : fsm_stateReg_string = "TX_WAIT  ";
      fsm_enumDef_RX_WAIT : fsm_stateReg_string = "RX_WAIT  ";
      fsm_enumDef_TX_IFS : fsm_stateReg_string = "TX_IFS   ";
      default : fsm_stateReg_string = "?????????";
    endcase
  end
  always @(*) begin
    case(fsm_stateNext)
      fsm_enumDef_BOOT : fsm_stateNext_string = "BOOT     ";
      fsm_enumDef_RX_DATA : fsm_stateNext_string = "RX_DATA  ";
      fsm_enumDef_TX_PID : fsm_stateNext_string = "TX_PID   ";
      fsm_enumDef_TX_DATA : fsm_stateNext_string = "TX_DATA  ";
      fsm_enumDef_TX_CRC1 : fsm_stateNext_string = "TX_CRC1  ";
      fsm_enumDef_TX_CRC2 : fsm_stateNext_string = "TX_CRC2  ";
      fsm_enumDef_TX_TOKEN1 : fsm_stateNext_string = "TX_TOKEN1";
      fsm_enumDef_TX_TOKEN2 : fsm_stateNext_string = "TX_TOKEN2";
      fsm_enumDef_TX_TOKEN3 : fsm_stateNext_string = "TX_TOKEN3";
      fsm_enumDef_TX_ACKNAK : fsm_stateNext_string = "TX_ACKNAK";
      fsm_enumDef_TX_WAIT : fsm_stateNext_string = "TX_WAIT  ";
      fsm_enumDef_RX_WAIT : fsm_stateNext_string = "RX_WAIT  ";
      fsm_enumDef_TX_IFS : fsm_stateNext_string = "TX_IFS   ";
      default : fsm_stateNext_string = "?????????";
    endcase
  end
  `endif

  assign ctrlRegs_doWrite = ctrlRegs_askWrite;
  assign ctrlRegs_doRead = ctrlRegs_askRead;
  always @(*) begin
    ctrlRegs_readDataInit = 32'h0;
    case(ctrlRegs_readAddress)
      8'h0 : begin
        ctrlRegs_readDataInit[7 : 7] = dmPulldown;
        ctrlRegs_readDataInit[6 : 6] = dpPulldown;
        ctrlRegs_readDataInit[5 : 5] = termSelect;
        ctrlRegs_readDataInit[4 : 3] = xcvrSelect;
        ctrlRegs_readDataInit[2 : 1] = opMode;
        ctrlRegs_readDataInit[0 : 0] = enableSof;
      end
      8'h10 : begin
        ctrlRegs_readDataInit[3 : 0] = {irqMask_deviceDetect,{irqMask_err,{irqMask_done,irqMask_sof}}};
      end
      8'h14 : begin
        ctrlRegs_readDataInit[15 : 0] = txLen;
      end
      8'h18 : begin
        ctrlRegs_readDataInit[30 : 30] = tokenIn;
        ctrlRegs_readDataInit[29 : 29] = tokenAck;
        ctrlRegs_readDataInit[28 : 28] = tokenPidDatax;
        ctrlRegs_readDataInit[23 : 16] = tokenPidBits;
        ctrlRegs_readDataInit[15 : 9] = tokenDevAddr;
        ctrlRegs_readDataInit[8 : 5] = tokenEpAddr;
      end
      8'h20 : begin
        ctrlRegs_readDataInit[7 : 0] = rxFifo_io_pop_payload;
      end
      8'h04 : begin
        ctrlRegs_readDataInit[31 : 16] = sofTime;
        ctrlRegs_readDataInit[2 : 2] = usbErr;
        ctrlRegs_readDataInit[1 : 0] = utmi_linestate;
      end
      8'h0c : begin
        ctrlRegs_readDataInit[3 : 0] = {irqSts_deviceDetect,{irqSts_err,{irqSts_done,irqSts_sof}}};
      end
      8'h1c : begin
        ctrlRegs_readDataInit[31 : 31] = tokenStart;
        ctrlRegs_readDataInit[30 : 30] = crcErr;
        ctrlRegs_readDataInit[29 : 29] = timeout;
        ctrlRegs_readDataInit[28 : 28] = sieIdle;
        ctrlRegs_readDataInit[23 : 16] = response;
        ctrlRegs_readDataInit[15 : 0] = byteCount;
      end
      default : begin
      end
    endcase
  end

  assign ctrlRegs_readData = ctrlRegs_readDataInit;
  assign ctrlRegs_readToWriteData = ctrlRegs_readData;
  assign utmi_idpullup = 1'b0;
  assign utmi_chrgvbus = 1'b0;
  assign utmi_dischrgvbus = 1'b0;
  assign utmi_suspend_n = 1'b1;
  assign cfg_aw_fire = (cfg_awvalid && cfg_awready);
  assign wrCmdAccepted = (cfg_aw_fire || regAwValid);
  assign cfg_w_fire = (cfg_wvalid && cfg_wready);
  assign wrDataAccepted = (cfg_w_fire || regWValid);
  assign cfg_aw_fire_1 = (cfg_awvalid && cfg_awready);
  assign when_USBHost_l128 = (cfg_aw_fire_1 && (! wrDataAccepted));
  assign cfg_w_fire_1 = (cfg_wvalid && cfg_wready);
  assign when_USBHost_l129 = (cfg_w_fire_1 && (! wrCmdAccepted));
  assign cfg_aw_fire_2 = (cfg_awvalid && cfg_awready);
  assign wrAddr = (regAwValid ? regWrAddr : cfg_awaddr[7 : 0]);
  assign cfg_w_fire_2 = (cfg_wvalid && cfg_wready);
  assign readEn = (cfg_arvalid && cfg_arready);
  assign writeEn = (wrCmdAccepted && wrDataAccepted);
  assign cfg_arready = (! cfg_rvalid);
  assign cfg_awready = (((! cfg_bvalid) && (! cfg_arvalid)) && (! regAwValid));
  assign cfg_wready = (((! cfg_bvalid) && (! cfg_arvalid)) && (! regWValid));
  assign ctrlRegs_writeAddress = wrAddr;
  assign ctrlRegs_askWrite = writeEn;
  assign ctrlRegs_writeData = cfg_wdata;
  assign utmi_opmode = opMode;
  assign utmi_xcvrsel = xcvrSelect;
  assign utmi_termsel = termSelect;
  assign utmi_dppulldown = dpPulldown;
  assign utmi_dmpulldown = dmPulldown;
  assign txFifo_io_push_payload = regWrData[7 : 0];
  assign utmi_reset = phyReset;
  assign cfg_rvalid = regRValid;
  assign cfg_r_isFree = ((! cfg_rvalid) || cfg_rready);
  assign cfg_rdata = regRData;
  assign cfg_rresp = 2'b00;
  assign cfg_bvalid = regBValid;
  assign cfg_bresp = 2'b00;
  always @(*) begin
    rwDataRd = 1'b0;
    case(ctrlRegs_readAddress)
      8'h20 : begin
        if(ctrlRegs_doRead) begin
          rwDataRd = 1'b1;
        end
      end
      default : begin
      end
    endcase
  end

  always @(*) begin
    sieIdle = 1'b0;
    case(fsm_stateReg)
      fsm_enumDef_RX_DATA : begin
      end
      fsm_enumDef_TX_PID : begin
      end
      fsm_enumDef_TX_DATA : begin
      end
      fsm_enumDef_TX_CRC1 : begin
      end
      fsm_enumDef_TX_CRC2 : begin
      end
      fsm_enumDef_TX_TOKEN1 : begin
      end
      fsm_enumDef_TX_TOKEN2 : begin
      end
      fsm_enumDef_TX_TOKEN3 : begin
      end
      fsm_enumDef_TX_ACKNAK : begin
      end
      fsm_enumDef_TX_WAIT : begin
      end
      fsm_enumDef_RX_WAIT : begin
      end
      fsm_enumDef_TX_IFS : begin
      end
      default : begin
        sieIdle = 1'b1;
      end
    endcase
  end

  assign sendSof = (((sofTime == 16'hea5f) && enableSof) && sieIdle);
  assign sofGuardBand = ((sofTime <= 16'h0064) || (16'hdbb9 <= sofTime));
  assign clearToSend = (((! sofGuardBand) || (! enableSof)) && sieIdle);
  assign tokenPid = (sofTransfer ? 8'ha5 : tokenPidBits);
  assign _zz_tokenDev = (sofTransfer ? sofValue[6 : 0] : tokenDevAddr);
  assign tokenDev = {_zz_tokenDev[0],{_zz_tokenDev[1],{_zz_tokenDev[2],{_zz_tokenDev[3],{_zz_tokenDev[4],{_zz_tokenDev[5],_zz_tokenDev[6]}}}}}};
  assign _zz_tokenEp = (sofTransfer ? sofValue[10 : 7] : tokenEpAddr);
  assign tokenEp = {_zz_tokenEp[0],{_zz_tokenEp[1],{_zz_tokenEp[2],_zz_tokenEp[3]}}};
  assign tokenStartAckIn = transferReqAck;
  assign when_USBHost_l327 = (sofTime != 16'hea5f);
  assign when_USBHost_l344 = (utmi_linestate != USBLineState_SE0);
  assign intr = regIntrValid;
  assign shiftEn = (utmi_rxvalid || (! utmi_rxactive));
  assign dataReady = regDataValid[0];
  assign rxActiveRise = (utmi_rxactive && (! utmi_rxactive_regNext));
  assign tokenRev = {txToken[0],{txToken[1],{txToken[2],{txToken[3],{txToken[4],{txToken[5],{txToken[6],{txToken[7],{txToken[8],{_zz_tokenRev,{_zz_tokenRev_1,_zz_tokenRev_2}}}}}}}}}}};
  assign crc5_1_io_data = txToken[15 : 5];
  assign crc5Next = (~ crc5_1_io_crcOut);
  always @(*) begin
    crc16_1_io_data = txFifo_io_pop_payload;
    case(fsm_stateReg)
      fsm_enumDef_RX_DATA : begin
        crc16_1_io_data = rxData;
      end
      fsm_enumDef_TX_PID : begin
      end
      fsm_enumDef_TX_DATA : begin
      end
      fsm_enumDef_TX_CRC1 : begin
      end
      fsm_enumDef_TX_CRC2 : begin
      end
      fsm_enumDef_TX_TOKEN1 : begin
      end
      fsm_enumDef_TX_TOKEN2 : begin
      end
      fsm_enumDef_TX_TOKEN3 : begin
      end
      fsm_enumDef_TX_ACKNAK : begin
      end
      fsm_enumDef_TX_WAIT : begin
      end
      fsm_enumDef_RX_WAIT : begin
      end
      fsm_enumDef_TX_IFS : begin
      end
      default : begin
      end
    endcase
  end

  assign eopDetected = (se0Detect && (utmi_linestate != USBLineState_SE0));
  always @(*) begin
    lastTxTime_willIncrement = 1'b0;
    if(!utmi_tx_fire) begin
      if(when_USBHost_l419) begin
        lastTxTime_willIncrement = 1'b1;
      end
    end
  end

  always @(*) begin
    lastTxTime_willClear = 1'b0;
    if(utmi_tx_fire) begin
      lastTxTime_willClear = 1'b1;
    end
    case(fsm_stateReg)
      fsm_enumDef_RX_DATA : begin
      end
      fsm_enumDef_TX_PID : begin
      end
      fsm_enumDef_TX_DATA : begin
      end
      fsm_enumDef_TX_CRC1 : begin
      end
      fsm_enumDef_TX_CRC2 : begin
      end
      fsm_enumDef_TX_TOKEN1 : begin
      end
      fsm_enumDef_TX_TOKEN2 : begin
      end
      fsm_enumDef_TX_TOKEN3 : begin
      end
      fsm_enumDef_TX_ACKNAK : begin
      end
      fsm_enumDef_TX_WAIT : begin
      end
      fsm_enumDef_RX_WAIT : begin
      end
      fsm_enumDef_TX_IFS : begin
      end
      default : begin
        lastTxTime_willClear = 1'b1;
      end
    endcase
  end

  assign lastTxTime_willOverflowIfInc = (lastTxTime_value == 9'h1ff);
  assign lastTxTime_willOverflow = (lastTxTime_willOverflowIfInc && lastTxTime_willIncrement);
  always @(*) begin
    lastTxTime_valueNext = (lastTxTime_value + _zz_lastTxTime_valueNext);
    if(lastTxTime_willClear) begin
      lastTxTime_valueNext = 9'h0;
    end
  end

  assign utmi_tx_fire = (utmi_txvalid && utmi_txready);
  assign when_USBHost_l419 = (! lastTxTime_willOverflowIfInc);
  assign rxRespTimeout = (lastTxTime_willOverflowIfInc && waitResp);
  always @(*) begin
    crcError = 1'b0;
    case(fsm_stateReg)
      fsm_enumDef_RX_DATA : begin
        crcError = ((((! rxActive) && sieInTransfer) && ((response == 8'hc3) || (response == 8'h4b))) && (crcSum != 16'hb001));
      end
      fsm_enumDef_TX_PID : begin
      end
      fsm_enumDef_TX_DATA : begin
      end
      fsm_enumDef_TX_CRC1 : begin
      end
      fsm_enumDef_TX_CRC2 : begin
      end
      fsm_enumDef_TX_TOKEN1 : begin
      end
      fsm_enumDef_TX_TOKEN2 : begin
      end
      fsm_enumDef_TX_TOKEN3 : begin
      end
      fsm_enumDef_TX_ACKNAK : begin
      end
      fsm_enumDef_TX_WAIT : begin
      end
      fsm_enumDef_RX_WAIT : begin
      end
      fsm_enumDef_TX_IFS : begin
      end
      default : begin
      end
    endcase
  end

  always @(*) begin
    utmi_txvalid = 1'b0;
    case(fsm_stateReg)
      fsm_enumDef_RX_DATA : begin
      end
      fsm_enumDef_TX_PID : begin
        utmi_txvalid = 1'b1;
      end
      fsm_enumDef_TX_DATA : begin
        utmi_txvalid = 1'b1;
      end
      fsm_enumDef_TX_CRC1 : begin
        utmi_txvalid = 1'b1;
      end
      fsm_enumDef_TX_CRC2 : begin
        utmi_txvalid = 1'b1;
      end
      fsm_enumDef_TX_TOKEN1 : begin
        utmi_txvalid = 1'b1;
      end
      fsm_enumDef_TX_TOKEN2 : begin
        utmi_txvalid = 1'b1;
      end
      fsm_enumDef_TX_TOKEN3 : begin
        utmi_txvalid = 1'b1;
      end
      fsm_enumDef_TX_ACKNAK : begin
        utmi_txvalid = 1'b1;
      end
      fsm_enumDef_TX_WAIT : begin
      end
      fsm_enumDef_RX_WAIT : begin
      end
      fsm_enumDef_TX_IFS : begin
      end
      default : begin
      end
    endcase
  end

  always @(*) begin
    utmi_data_o = 8'h0;
    case(fsm_stateReg)
      fsm_enumDef_RX_DATA : begin
      end
      fsm_enumDef_TX_PID : begin
        utmi_data_o = (sendData1 ? 8'h4b : 8'hc3);
      end
      fsm_enumDef_TX_DATA : begin
        utmi_data_o = txFifo_io_pop_payload;
      end
      fsm_enumDef_TX_CRC1 : begin
        utmi_data_o = (~ crcSum[7 : 0]);
      end
      fsm_enumDef_TX_CRC2 : begin
        utmi_data_o = (~ crcSum[15 : 8]);
      end
      fsm_enumDef_TX_TOKEN1 : begin
        utmi_data_o = tokenPid;
      end
      fsm_enumDef_TX_TOKEN2 : begin
        utmi_data_o = tokenRev[7 : 0];
      end
      fsm_enumDef_TX_TOKEN3 : begin
        utmi_data_o = tokenRev[15 : 8];
      end
      fsm_enumDef_TX_ACKNAK : begin
        utmi_data_o = 8'hd2;
      end
      fsm_enumDef_TX_WAIT : begin
      end
      fsm_enumDef_RX_WAIT : begin
      end
      fsm_enumDef_TX_IFS : begin
      end
      default : begin
      end
    endcase
  end

  assign utmi_data_t = (! utmi_txvalid);
  always @(*) begin
    txFifo_io_pop_ready = 1'b0;
    case(fsm_stateReg)
      fsm_enumDef_RX_DATA : begin
      end
      fsm_enumDef_TX_PID : begin
      end
      fsm_enumDef_TX_DATA : begin
        if(utmi_txready) begin
          txFifo_io_pop_ready = 1'b1;
        end
      end
      fsm_enumDef_TX_CRC1 : begin
      end
      fsm_enumDef_TX_CRC2 : begin
      end
      fsm_enumDef_TX_TOKEN1 : begin
      end
      fsm_enumDef_TX_TOKEN2 : begin
      end
      fsm_enumDef_TX_TOKEN3 : begin
      end
      fsm_enumDef_TX_ACKNAK : begin
      end
      fsm_enumDef_TX_WAIT : begin
      end
      fsm_enumDef_RX_WAIT : begin
      end
      fsm_enumDef_TX_IFS : begin
      end
      default : begin
      end
    endcase
  end

  assign fsm_wantExit = 1'b0;
  assign fsm_wantStart = 1'b0;
  assign fsm_wantKill = 1'b0;
  assign when_USBHost_l637 = (! ({(fsm_stateReg == fsm_enumDef_TX_CRC2),{(fsm_stateReg == fsm_enumDef_RX_DATA),{(fsm_stateReg == fsm_enumDef_RX_WAIT),(fsm_stateReg == fsm_enumDef_BOOT)}}} != 4'b0000));
  assign when_USBHost_l646 = (waitEop || eopDetected);
  assign when_USBHost_l649 = (txIfs != 4'b0000);
  assign ifsBusy = (waitEop || (txIfs != 4'b0000));
  assign rxFifo_io_push_valid = ((((! (fsm_stateReg == fsm_enumDef_BOOT)) && (! (fsm_stateReg == fsm_enumDef_RX_WAIT))) && dataReady) && (! crcByte));
  assign ctrlRegs_askRead = readEn;
  assign ctrlRegs_readAddress = cfg_araddr[7 : 0];
  assign irqSts_sof = regIntrs_sof;
  assign irqSts_done = regIntrs_done;
  assign irqSts_err = regIntrs_err;
  always @(*) begin
    irqSts_deviceDetect = regIntrs_deviceDetect;
    irqSts_deviceDetect = 1'b0;
  end

  always @(*) begin
    rxFifo_io_pop_ready = 1'b0;
    case(ctrlRegs_readAddress)
      8'h20 : begin
        if(ctrlRegs_doRead) begin
          rxFifo_io_pop_ready = 1'b1;
        end
      end
      default : begin
      end
    endcase
  end

  assign _zz_irqAck_sof = ctrlRegs_writeData[3 : 0];
  assign _zz_irqMask_sof = ctrlRegs_writeData[3 : 0];
  always @(*) begin
    fsm_stateNext = fsm_stateReg;
    case(fsm_stateReg)
      fsm_enumDef_RX_DATA : begin
        if(when_USBHost_l608) begin
          if(when_USBHost_l610) begin
            fsm_stateNext = fsm_enumDef_BOOT;
          end else begin
            if(when_USBHost_l613) begin
              fsm_stateNext = fsm_enumDef_TX_WAIT;
            end else begin
              fsm_stateNext = fsm_enumDef_BOOT;
            end
          end
        end
      end
      fsm_enumDef_TX_PID : begin
        if(utmi_txready) begin
          if(when_USBHost_l523) begin
            fsm_stateNext = fsm_enumDef_TX_DATA;
          end else begin
            fsm_stateNext = fsm_enumDef_TX_CRC1;
          end
        end
      end
      fsm_enumDef_TX_DATA : begin
        if(utmi_txready) begin
          if(!when_USBHost_l541) begin
            fsm_stateNext = fsm_enumDef_TX_CRC1;
          end
        end
      end
      fsm_enumDef_TX_CRC1 : begin
        if(utmi_txready) begin
          fsm_stateNext = fsm_enumDef_TX_CRC2;
        end
      end
      fsm_enumDef_TX_CRC2 : begin
        if(utmi_txready) begin
          if(waitResp) begin
            fsm_stateNext = fsm_enumDef_RX_WAIT;
          end else begin
            fsm_stateNext = fsm_enumDef_BOOT;
          end
        end
      end
      fsm_enumDef_TX_TOKEN1 : begin
        if(utmi_txready) begin
          fsm_stateNext = fsm_enumDef_TX_TOKEN2;
        end
      end
      fsm_enumDef_TX_TOKEN2 : begin
        if(utmi_txready) begin
          fsm_stateNext = fsm_enumDef_TX_TOKEN3;
        end
      end
      fsm_enumDef_TX_TOKEN3 : begin
        if(utmi_txready) begin
          if(sieSendSof) begin
            fsm_stateNext = fsm_enumDef_TX_IFS;
          end else begin
            if(sieInTransfer) begin
              fsm_stateNext = fsm_enumDef_RX_WAIT;
            end else begin
              fsm_stateNext = fsm_enumDef_TX_IFS;
            end
          end
        end
      end
      fsm_enumDef_TX_ACKNAK : begin
        if(utmi_txready) begin
          fsm_stateNext = fsm_enumDef_BOOT;
        end
      end
      fsm_enumDef_TX_WAIT : begin
        if(when_USBHost_l624) begin
          fsm_stateNext = fsm_enumDef_TX_ACKNAK;
        end
      end
      fsm_enumDef_RX_WAIT : begin
        if(dataReady) begin
          fsm_stateNext = fsm_enumDef_RX_DATA;
        end else begin
          if(rxRespTimeout) begin
            fsm_stateNext = fsm_enumDef_BOOT;
          end
        end
      end
      fsm_enumDef_TX_IFS : begin
        if(when_USBHost_l505) begin
          if(sieSendSof) begin
            fsm_stateNext = fsm_enumDef_BOOT;
          end else begin
            fsm_stateNext = fsm_enumDef_TX_PID;
          end
        end
      end
      default : begin
        if(transferStart) begin
          fsm_stateNext = fsm_enumDef_TX_TOKEN1;
        end
      end
    endcase
    if(fsm_wantKill) begin
      fsm_stateNext = fsm_enumDef_BOOT;
    end
  end

  assign when_USBHost_l599 = (! crcByte);
  assign when_USBHost_l603 = (! rxActive);
  assign when_USBHost_l608 = (! rxActive);
  assign when_USBHost_l610 = (sendAck && crcError);
  assign when_USBHost_l613 = (sendAck && ((response == 8'hc3) || (response == 8'h4b)));
  assign when_USBHost_l523 = (byteCount != 16'h0);
  assign when_USBHost_l541 = (byteCount != 16'h0);
  assign when_USBHost_l624 = (! ifsBusy);
  assign when_USBHost_l505 = (! ifsBusy);
  assign when_USBHost_l463 = (! sofTransfer);
  assign when_StateMachine_l219 = ((fsm_stateReg == fsm_enumDef_TX_CRC2) && (! (fsm_stateNext == fsm_enumDef_TX_CRC2)));
  assign when_StateMachine_l219_1 = ((fsm_stateReg == fsm_enumDef_TX_TOKEN3) && (! (fsm_stateNext == fsm_enumDef_TX_TOKEN3)));
  assign when_StateMachine_l219_2 = ((fsm_stateReg == fsm_enumDef_TX_ACKNAK) && (! (fsm_stateNext == fsm_enumDef_TX_ACKNAK)));
  always @(posedge clk or negedge resetn) begin
    if(!resetn) begin
      regAwValid <= 1'b0;
      regWValid <= 1'b0;
      regWrAddr <= 8'h0;
      regWrData <= 32'h0;
      regUsbCtrlWr <= 1'b0;
      txFlush <= 1'b0;
      dmPulldown <= 1'b0;
      dpPulldown <= 1'b0;
      termSelect <= 1'b0;
      enableSof <= 1'b0;
      xcvrSelect <= 2'b00;
      opMode <= 2'b00;
      irqAck_sof <= 1'b0;
      irqAck_done <= 1'b0;
      irqAck_err <= 1'b0;
      irqAck_deviceDetect <= 1'b0;
      irqMask_sof <= 1'b0;
      irqMask_done <= 1'b0;
      irqMask_err <= 1'b0;
      irqMask_deviceDetect <= 1'b0;
      txLen <= 16'h0;
      tokenStart <= 1'b0;
      tokenIn <= 1'b0;
      tokenAck <= 1'b0;
      tokenPidDatax <= 1'b0;
      tokenPidBits <= 8'h0;
      tokenDevAddr <= 7'h0;
      tokenEpAddr <= 4'b0000;
      regRWDataWr <= 1'b0;
      phyReset <= 1'b0;
      regRValid <= 1'b0;
      regRData <= 32'h0;
      regBValid <= 1'b0;
      sofTime <= 16'h0;
      sofTransfer <= 1'b0;
      sofValue <= 11'h0;
      sofIrq <= 1'b0;
      startAck <= 1'b0;
      fifoFlush <= 1'b0;
      transferStart <= 1'b0;
      transferReqAck <= 1'b0;
      inTransfer <= 1'b0;
      respExpected <= 1'b0;
      usbErr <= 1'b0;
      regIntrs_sof <= 1'b0;
      regIntrs_done <= 1'b0;
      regIntrs_err <= 1'b0;
      regIntrs_deviceDetect <= 1'b0;
      regIntrValid <= 1'b0;
      utmi_data_i_delay_1 <= 8'h0;
      utmi_data_i_delay_2 <= 8'h0;
      utmi_data_i_delay_3 <= 8'h0;
      rxData <= 8'h0;
      regDataValid <= 4'b0000;
      _zz_crcByte <= 1'b0;
      crcByte <= 1'b0;
      utmi_rxactive_delay_1 <= 1'b0;
      utmi_rxactive_delay_2 <= 1'b0;
      utmi_rxactive_delay_3 <= 1'b0;
      rxActive <= 1'b0;
      utmi_rxactive_regNext <= 1'b0;
      txToken <= 16'h0;
      waitEop <= 1'b0;
      regLineState <= USBLineState_SE0;
      se0Detect <= 1'b0;
      byteCount <= 16'h0;
      sieInTransfer <= 1'b0;
      sendAck <= 1'b0;
      sendData1 <= 1'b0;
      sieSendSof <= 1'b0;
      waitResp <= 1'b0;
      response <= 8'h0;
      timeout <= 1'b0;
      rxDone <= 1'b0;
      txDone <= 1'b0;
      crcErr <= 1'b0;
      lastTxTime_value <= 9'h0;
      crcSum <= 16'hffff;
      txIfs <= 4'b0000;
      fsm_stateReg <= fsm_enumDef_BOOT;
    end else begin
      if(wrDataAccepted) begin
        regAwValid <= 1'b0;
      end
      if(when_USBHost_l128) begin
        regAwValid <= 1'b1;
      end
      if(wrCmdAccepted) begin
        regWValid <= 1'b0;
      end
      if(when_USBHost_l129) begin
        regWValid <= 1'b1;
      end
      if(cfg_aw_fire_2) begin
        regWrAddr <= cfg_awaddr[7 : 0];
      end
      if(cfg_w_fire_2) begin
        regWrData <= cfg_wdata;
      end
      regUsbCtrlWr <= 1'b0;
      txFlush <= 1'b0;
      irqAck_sof <= 1'b0;
      irqAck_done <= 1'b0;
      irqAck_err <= 1'b0;
      irqAck_deviceDetect <= 1'b0;
      if(tokenStartAckIn) begin
        tokenStart <= 1'b0;
      end
      regRWDataWr <= 1'b0;
      if(cfg_rready) begin
        regRValid <= 1'b0;
      end
      if(readEn) begin
        regRValid <= 1'b1;
      end
      if(cfg_r_isFree) begin
        regRData <= ctrlRegs_readData;
      end
      if(cfg_bready) begin
        regBValid <= 1'b0;
      end
      if(writeEn) begin
        regBValid <= 1'b1;
      end
      startAck <= 1'b0;
      if(transferStart) begin
        if(startAck) begin
          transferStart <= 1'b0;
        end
        fifoFlush <= 1'b0;
        transferReqAck <= 1'b0;
      end else begin
        if(sendSof) begin
          inTransfer <= 1'b0;
          respExpected <= 1'b0;
          transferStart <= 1'b1;
          sofTransfer <= 1'b1;
        end else begin
          if(clearToSend) begin
            if(tokenStart) begin
              fifoFlush <= 1'b1;
              inTransfer <= tokenIn;
              respExpected <= tokenAck;
              transferStart <= 1'b1;
              sofTransfer <= 1'b0;
              transferReqAck <= 1'b1;
            end
          end
        end
      end
      if(sendSof) begin
        sofTime <= 16'h0;
        sofValue <= (sofValue + 11'h001);
        sofIrq <= 1'b1;
      end else begin
        if(when_USBHost_l327) begin
          sofTime <= (sofTime + 16'h0001);
        end
        sofIrq <= 1'b0;
      end
      if(utmi_rxerror) begin
        usbErr <= 1'b1;
      end
      if(regUsbCtrlWr) begin
        usbErr <= 1'b0;
      end
      regIntrValid <= (|({regIntrs_deviceDetect,{regIntrs_err,{regIntrs_done,regIntrs_sof}}} & {irqMask_deviceDetect,{irqMask_err,{irqMask_done,irqMask_sof}}}));
      if(irqAck_done) begin
        regIntrs_done <= 1'b0;
      end
      if(irqAck_sof) begin
        regIntrs_sof <= 1'b0;
      end
      if(sofIrq) begin
        regIntrs_sof <= 1'b1;
      end
      if(irqAck_err) begin
        regIntrs_err <= 1'b0;
      end
      if(irqAck_deviceDetect) begin
        regIntrs_deviceDetect <= 1'b0;
      end
      if(when_USBHost_l344) begin
        regIntrs_deviceDetect <= 1'b1;
      end
      if(shiftEn) begin
        utmi_data_i_delay_1 <= utmi_data_i;
      end
      if(shiftEn) begin
        utmi_data_i_delay_2 <= utmi_data_i_delay_1;
      end
      if(shiftEn) begin
        utmi_data_i_delay_3 <= utmi_data_i_delay_2;
      end
      if(shiftEn) begin
        rxData <= utmi_data_i_delay_3;
      end
      if(shiftEn) begin
        regDataValid <= {(utmi_rxvalid && utmi_rxactive),_zz_regDataValid};
      end else begin
        regDataValid[0] <= 1'b0;
      end
      if(shiftEn) begin
        _zz_crcByte <= (! utmi_rxactive);
      end
      if(shiftEn) begin
        crcByte <= _zz_crcByte;
      end
      utmi_rxactive_delay_1 <= utmi_rxactive;
      utmi_rxactive_delay_2 <= utmi_rxactive_delay_1;
      utmi_rxactive_delay_3 <= utmi_rxactive_delay_2;
      rxActive <= utmi_rxactive_delay_3;
      utmi_rxactive_regNext <= utmi_rxactive;
      regLineState <= utmi_linestate;
      se0Detect <= ((utmi_linestate == USBLineState_SE0) && (regLineState == USBLineState_SE0));
      lastTxTime_value <= lastTxTime_valueNext;
      if(when_USBHost_l637) begin
        rxDone <= 1'b0;
        txDone <= 1'b0;
      end
      if(rxActiveRise) begin
        waitEop <= 1'b1;
      end
      if(eopDetected) begin
        waitEop <= 1'b0;
      end
      if(when_USBHost_l646) begin
        txIfs <= 4'b1010;
      end else begin
        if(when_USBHost_l649) begin
          txIfs <= (txIfs - 4'b0001);
        end
      end
      case(ctrlRegs_writeAddress)
        8'h0 : begin
          if(ctrlRegs_doWrite) begin
            regUsbCtrlWr <= 1'b1;
          end
          if(ctrlRegs_doWrite) begin
            txFlush <= ctrlRegs_writeData[8];
          end
          if(ctrlRegs_doWrite) begin
            dmPulldown <= ctrlRegs_writeData[7];
          end
          if(ctrlRegs_doWrite) begin
            dpPulldown <= ctrlRegs_writeData[6];
          end
          if(ctrlRegs_doWrite) begin
            termSelect <= ctrlRegs_writeData[5];
          end
          if(ctrlRegs_doWrite) begin
            xcvrSelect <= ctrlRegs_writeData[4 : 3];
          end
          if(ctrlRegs_doWrite) begin
            opMode <= ctrlRegs_writeData[2 : 1];
          end
          if(ctrlRegs_doWrite) begin
            enableSof <= ctrlRegs_writeData[0];
          end
        end
        8'h08 : begin
          if(ctrlRegs_doWrite) begin
            irqAck_sof <= _zz_irqAck_sof[0];
            irqAck_done <= _zz_irqAck_sof[1];
            irqAck_err <= _zz_irqAck_sof[2];
            irqAck_deviceDetect <= _zz_irqAck_sof[3];
          end
        end
        8'h10 : begin
          if(ctrlRegs_doWrite) begin
            irqMask_sof <= _zz_irqMask_sof[0];
            irqMask_done <= _zz_irqMask_sof[1];
            irqMask_err <= _zz_irqMask_sof[2];
            irqMask_deviceDetect <= _zz_irqMask_sof[3];
          end
        end
        8'h14 : begin
          if(ctrlRegs_doWrite) begin
            txLen <= ctrlRegs_writeData[15 : 0];
          end
        end
        8'h18 : begin
          if(ctrlRegs_doWrite) begin
            tokenStart <= ctrlRegs_writeData[31];
          end
          if(ctrlRegs_doWrite) begin
            tokenIn <= ctrlRegs_writeData[30];
          end
          if(ctrlRegs_doWrite) begin
            tokenAck <= ctrlRegs_writeData[29];
          end
          if(ctrlRegs_doWrite) begin
            tokenPidDatax <= ctrlRegs_writeData[28];
          end
          if(ctrlRegs_doWrite) begin
            tokenPidBits <= ctrlRegs_writeData[23 : 16];
          end
          if(ctrlRegs_doWrite) begin
            tokenDevAddr <= ctrlRegs_writeData[15 : 9];
          end
          if(ctrlRegs_doWrite) begin
            tokenEpAddr <= ctrlRegs_writeData[8 : 5];
          end
        end
        8'h20 : begin
          if(ctrlRegs_doWrite) begin
            regRWDataWr <= 1'b1;
          end
        end
        8'h24 : begin
          if(ctrlRegs_doWrite) begin
            phyReset <= ctrlRegs_writeData[0];
          end
        end
        default : begin
        end
      endcase
      fsm_stateReg <= fsm_stateNext;
      case(fsm_stateReg)
        fsm_enumDef_RX_DATA : begin
          rxDone <= (! utmi_rxactive);
          if(dataReady) begin
            crcSum <= crc16_1_io_crcOut;
            if(when_USBHost_l599) begin
              byteCount <= (byteCount + 16'h0001);
            end
          end else begin
            if(when_USBHost_l603) begin
              crcErr <= crcError;
            end
          end
        end
        fsm_enumDef_TX_PID : begin
          crcSum <= 16'hffff;
          if(utmi_txready) begin
            if(when_USBHost_l523) begin
              byteCount <= (byteCount - 16'h0001);
            end
          end
        end
        fsm_enumDef_TX_DATA : begin
          if(utmi_txready) begin
            crcSum <= crc16_1_io_crcOut;
            if(when_USBHost_l541) begin
              byteCount <= (byteCount - 16'h0001);
            end
          end
        end
        fsm_enumDef_TX_CRC1 : begin
        end
        fsm_enumDef_TX_CRC2 : begin
          if(utmi_txready) begin
            if(!waitResp) begin
              txDone <= 1'b1;
            end
          end
        end
        fsm_enumDef_TX_TOKEN1 : begin
          if(utmi_txready) begin
            startAck <= 1'b1;
            txToken[4 : 0] <= crc5Next;
          end
        end
        fsm_enumDef_TX_TOKEN2 : begin
        end
        fsm_enumDef_TX_TOKEN3 : begin
        end
        fsm_enumDef_TX_ACKNAK : begin
        end
        fsm_enumDef_TX_WAIT : begin
        end
        fsm_enumDef_RX_WAIT : begin
          crcSum <= 16'hffff;
          byteCount <= 16'h0;
          txDone <= 1'b0;
          if(dataReady) begin
            waitResp <= 1'b0;
            response <= rxData;
          end
          if(rxRespTimeout) begin
            timeout <= 1'b1;
          end
        end
        fsm_enumDef_TX_IFS : begin
        end
        default : begin
          txToken <= {{tokenDev,tokenEp},5'h0};
          rxDone <= 1'b0;
          txDone <= 1'b0;
          if(transferStart) begin
            sieInTransfer <= inTransfer;
            sendAck <= (inTransfer && respExpected);
            sendData1 <= tokenPidDatax;
            sieSendSof <= sofTransfer;
            waitResp <= respExpected;
            if(when_USBHost_l463) begin
              byteCount <= txLen;
              response <= 8'h0;
              timeout <= 1'b0;
              crcErr <= 1'b0;
            end
          end
        end
      endcase
      if(when_StateMachine_l219) begin
        waitEop <= 1'b1;
      end
      if(when_StateMachine_l219_1) begin
        waitEop <= 1'b1;
      end
      if(when_StateMachine_l219_2) begin
        waitEop <= 1'b1;
      end
    end
  end


endmodule

module CRC16 (
  input      [15:0]   io_crcIn,
  input      [7:0]    io_data,
  output reg [15:0]   io_crcOut
);

  wire                _zz_io_crcOut;
  wire                _zz_io_crcOut_1;

  assign _zz_io_crcOut = io_data[0];
  assign _zz_io_crcOut_1 = io_data[1];
  always @(*) begin
    io_crcOut[15] = (((((((((((((((io_data[0] ^ io_data[1]) ^ io_data[2]) ^ io_data[3]) ^ io_data[4]) ^ io_data[5]) ^ io_data[6]) ^ io_data[7]) ^ io_crcIn[7]) ^ io_crcIn[6]) ^ io_crcIn[5]) ^ io_crcIn[4]) ^ io_crcIn[3]) ^ io_crcIn[2]) ^ io_crcIn[1]) ^ io_crcIn[0]);
    io_crcOut[14] = (((((((((((((io_data[0] ^ io_data[1]) ^ io_data[2]) ^ io_data[3]) ^ io_data[4]) ^ io_data[5]) ^ io_data[6]) ^ io_crcIn[6]) ^ io_crcIn[5]) ^ io_crcIn[4]) ^ io_crcIn[3]) ^ io_crcIn[2]) ^ io_crcIn[1]) ^ io_crcIn[0]);
    io_crcOut[13] = (((io_data[6] ^ io_data[7]) ^ io_crcIn[7]) ^ io_crcIn[6]);
    io_crcOut[12] = (((io_data[5] ^ io_data[6]) ^ io_crcIn[6]) ^ io_crcIn[5]);
    io_crcOut[11] = (((io_data[4] ^ io_data[5]) ^ io_crcIn[5]) ^ io_crcIn[4]);
    io_crcOut[10] = (((io_data[3] ^ io_data[4]) ^ io_crcIn[4]) ^ io_crcIn[3]);
    io_crcOut[9] = (((io_data[2] ^ io_data[3]) ^ io_crcIn[3]) ^ io_crcIn[2]);
    io_crcOut[8] = (((io_data[1] ^ io_data[2]) ^ io_crcIn[2]) ^ io_crcIn[1]);
    io_crcOut[7] = ((((io_data[0] ^ io_data[1]) ^ io_crcIn[15]) ^ io_crcIn[1]) ^ io_crcIn[0]);
    io_crcOut[6] = ((io_data[0] ^ io_crcIn[14]) ^ io_crcIn[0]);
    io_crcOut[5] = io_crcIn[13];
    io_crcOut[4] = io_crcIn[12];
    io_crcOut[3] = io_crcIn[11];
    io_crcOut[2] = io_crcIn[10];
    io_crcOut[1] = io_crcIn[9];
    io_crcOut[0] = ((((((((((((((((_zz_io_crcOut ^ _zz_io_crcOut_1) ^ io_data[2]) ^ io_data[3]) ^ io_data[4]) ^ io_data[5]) ^ io_data[6]) ^ io_data[7]) ^ io_crcIn[8]) ^ io_crcIn[7]) ^ io_crcIn[6]) ^ io_crcIn[5]) ^ io_crcIn[4]) ^ io_crcIn[3]) ^ io_crcIn[2]) ^ io_crcIn[1]) ^ io_crcIn[0]);
  end


endmodule

module CRC5 (
  input      [4:0]    io_crcIn,
  input      [10:0]   io_data,
  output reg [4:0]    io_crcOut
);


  always @(*) begin
    io_crcOut[0] = ((((((((io_data[10] ^ io_data[9]) ^ io_data[6]) ^ io_data[5]) ^ io_data[3]) ^ io_data[0]) ^ io_crcIn[0]) ^ io_crcIn[3]) ^ io_crcIn[4]);
    io_crcOut[1] = (((((((io_data[10] ^ io_data[7]) ^ io_data[6]) ^ io_data[4]) ^ io_data[1]) ^ io_crcIn[0]) ^ io_crcIn[1]) ^ io_crcIn[4]);
    io_crcOut[2] = ((((((((((((io_data[10] ^ io_data[9]) ^ io_data[8]) ^ io_data[7]) ^ io_data[6]) ^ io_data[3]) ^ io_data[2]) ^ io_data[0]) ^ io_crcIn[0]) ^ io_crcIn[1]) ^ io_crcIn[2]) ^ io_crcIn[3]) ^ io_crcIn[4]);
    io_crcOut[3] = ((((((((((io_data[10] ^ io_data[9]) ^ io_data[8]) ^ io_data[7]) ^ io_data[4]) ^ io_data[3]) ^ io_data[1]) ^ io_crcIn[1]) ^ io_crcIn[2]) ^ io_crcIn[3]) ^ io_crcIn[4]);
    io_crcOut[4] = ((((((((io_data[10] ^ io_data[9]) ^ io_data[8]) ^ io_data[5]) ^ io_data[4]) ^ io_data[2]) ^ io_crcIn[2]) ^ io_crcIn[3]) ^ io_crcIn[4]);
  end


endmodule

//StreamFifo replaced by StreamFifo

module StreamFifo (
  input               io_push_valid,
  output              io_push_ready,
  input      [7:0]    io_push_payload,
  output              io_pop_valid,
  input               io_pop_ready,
  output     [7:0]    io_pop_payload,
  input               io_flush,
  output     [6:0]    io_occupancy,
  output     [6:0]    io_availability,
  input               clk,
  input               resetn
);

  reg        [7:0]    _zz_logic_ram_port0;
  wire       [5:0]    _zz_logic_pushPtr_valueNext;
  wire       [0:0]    _zz_logic_pushPtr_valueNext_1;
  wire       [5:0]    _zz_logic_popPtr_valueNext;
  wire       [0:0]    _zz_logic_popPtr_valueNext_1;
  wire                _zz_logic_ram_port;
  wire                _zz_io_pop_payload;
  wire       [5:0]    _zz_io_availability;
  reg                 _zz_1;
  reg                 logic_pushPtr_willIncrement;
  reg                 logic_pushPtr_willClear;
  reg        [5:0]    logic_pushPtr_valueNext;
  reg        [5:0]    logic_pushPtr_value;
  wire                logic_pushPtr_willOverflowIfInc;
  wire                logic_pushPtr_willOverflow;
  reg                 logic_popPtr_willIncrement;
  reg                 logic_popPtr_willClear;
  reg        [5:0]    logic_popPtr_valueNext;
  reg        [5:0]    logic_popPtr_value;
  wire                logic_popPtr_willOverflowIfInc;
  wire                logic_popPtr_willOverflow;
  wire                logic_ptrMatch;
  reg                 logic_risingOccupancy;
  wire                logic_pushing;
  wire                logic_popping;
  wire                logic_empty;
  wire                logic_full;
  reg                 _zz_io_pop_valid;
  wire                when_Stream_l946;
  wire       [5:0]    logic_ptrDif;
  reg [7:0] logic_ram [0:63];

  assign _zz_logic_pushPtr_valueNext_1 = logic_pushPtr_willIncrement;
  assign _zz_logic_pushPtr_valueNext = {5'd0, _zz_logic_pushPtr_valueNext_1};
  assign _zz_logic_popPtr_valueNext_1 = logic_popPtr_willIncrement;
  assign _zz_logic_popPtr_valueNext = {5'd0, _zz_logic_popPtr_valueNext_1};
  assign _zz_io_availability = (logic_popPtr_value - logic_pushPtr_value);
  assign _zz_io_pop_payload = 1'b1;
  always @(posedge clk) begin
    if(_zz_io_pop_payload) begin
      _zz_logic_ram_port0 <= logic_ram[logic_popPtr_valueNext];
    end
  end

  always @(posedge clk) begin
    if(_zz_1) begin
      logic_ram[logic_pushPtr_value] <= io_push_payload;
    end
  end

  always @(*) begin
    _zz_1 = 1'b0;
    if(logic_pushing) begin
      _zz_1 = 1'b1;
    end
  end

  always @(*) begin
    logic_pushPtr_willIncrement = 1'b0;
    if(logic_pushing) begin
      logic_pushPtr_willIncrement = 1'b1;
    end
  end

  always @(*) begin
    logic_pushPtr_willClear = 1'b0;
    if(io_flush) begin
      logic_pushPtr_willClear = 1'b1;
    end
  end

  assign logic_pushPtr_willOverflowIfInc = (logic_pushPtr_value == 6'h3f);
  assign logic_pushPtr_willOverflow = (logic_pushPtr_willOverflowIfInc && logic_pushPtr_willIncrement);
  always @(*) begin
    logic_pushPtr_valueNext = (logic_pushPtr_value + _zz_logic_pushPtr_valueNext);
    if(logic_pushPtr_willClear) begin
      logic_pushPtr_valueNext = 6'h0;
    end
  end

  always @(*) begin
    logic_popPtr_willIncrement = 1'b0;
    if(logic_popping) begin
      logic_popPtr_willIncrement = 1'b1;
    end
  end

  always @(*) begin
    logic_popPtr_willClear = 1'b0;
    if(io_flush) begin
      logic_popPtr_willClear = 1'b1;
    end
  end

  assign logic_popPtr_willOverflowIfInc = (logic_popPtr_value == 6'h3f);
  assign logic_popPtr_willOverflow = (logic_popPtr_willOverflowIfInc && logic_popPtr_willIncrement);
  always @(*) begin
    logic_popPtr_valueNext = (logic_popPtr_value + _zz_logic_popPtr_valueNext);
    if(logic_popPtr_willClear) begin
      logic_popPtr_valueNext = 6'h0;
    end
  end

  assign logic_ptrMatch = (logic_pushPtr_value == logic_popPtr_value);
  assign logic_pushing = (io_push_valid && io_push_ready);
  assign logic_popping = (io_pop_valid && io_pop_ready);
  assign logic_empty = (logic_ptrMatch && (! logic_risingOccupancy));
  assign logic_full = (logic_ptrMatch && logic_risingOccupancy);
  assign io_push_ready = (! logic_full);
  assign io_pop_valid = ((! logic_empty) && (! (_zz_io_pop_valid && (! logic_full))));
  assign io_pop_payload = _zz_logic_ram_port0;
  assign when_Stream_l946 = (logic_pushing != logic_popping);
  assign logic_ptrDif = (logic_pushPtr_value - logic_popPtr_value);
  assign io_occupancy = {(logic_risingOccupancy && logic_ptrMatch),logic_ptrDif};
  assign io_availability = {((! logic_risingOccupancy) && logic_ptrMatch),_zz_io_availability};
  always @(posedge clk or negedge resetn) begin
    if(!resetn) begin
      logic_pushPtr_value <= 6'h0;
      logic_popPtr_value <= 6'h0;
      logic_risingOccupancy <= 1'b0;
      _zz_io_pop_valid <= 1'b0;
    end else begin
      logic_pushPtr_value <= logic_pushPtr_valueNext;
      logic_popPtr_value <= logic_popPtr_valueNext;
      _zz_io_pop_valid <= (logic_popPtr_valueNext == logic_pushPtr_value);
      if(when_Stream_l946) begin
        logic_risingOccupancy <= logic_pushing;
      end
      if(io_flush) begin
        logic_risingOccupancy <= 1'b0;
      end
    end
  end


endmodule
