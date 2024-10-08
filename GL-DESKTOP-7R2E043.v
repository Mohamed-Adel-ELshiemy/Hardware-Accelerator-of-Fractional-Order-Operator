`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    12:13:19 09/20/2021 
// Design Name: 
// Module Name:    RL_Int 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module GL_Block(
	input clk, rst,
	input signed [31:0] Signal,
	output reg signed [31:0] Output,
	output reg OutInd
    );
integer f1;

parameter WLength = 64;
reg signed [31:0] Reg [0:WLength-1];
reg signed [31:0]  sum;
reg signed [63:0] temp1;
reg signed[31:0] Coff [0:WLength-1];
reg signed [31:0] DReg [0:WLength-1];

integer i =0;


initial begin

for (i=0; i<WLength;i=i+1)
begin
	Reg[i] =0;
end
OutInd = 0;
///////////////////////////////////////////////////////////////////////
// Derivative
//Coff[0]<=167772160;
//Coff[1]<=-83886080;
//Coff[2]<=-20971520;
//Coff[3]<=-10485760;
//Coff[4]<=-6553600;
//Coff[5]<=-4587520;
//Coff[6]<=-3440640;
//Coff[7]<=-2703360;
//Coff[8]<=-2196480;
//Coff[9]<=-1830400;
//Coff[10]<=-1555840;
//Coff[11]<=-1343680;
//Coff[12]<=-1175720;
//Coff[13]<=-1040060;
//Coff[14]<=-928625;
//Coff[15]<=-835762;
//Coff[16]<=-757409;
//Coff[17]<=-690579;
//Coff[18]<=-633031;
//Coff[19]<=-583055;
//Coff[20]<=-539325;
//Coff[21]<=-500802;
//Coff[22]<=-466657;
//Coff[23]<=-436222;
//Coff[24]<=-408958;
//Coff[25]<=-384421;
//Coff[26]<=-362243;
//Coff[27]<=-342118;
//Coff[28]<=-323790;
//Coff[29]<=-307043;
//Coff[30]<=-291690;
//Coff[31]<=-277576;
//Coff[32]<=-264565;
//Coff[33]<=-252539;
//Coff[34]<=-241398;
//Coff[35]<=-231052;
//Coff[36]<=-221425;
//Coff[37]<=-212448;
//Coff[38]<=-204062;
//Coff[39]<=-196214;
//Coff[40]<=-188855;
//Coff[41]<=-181946;
//Coff[42]<=-175448;
//Coff[43]<=-169328;
//Coff[44]<=-163555;
//Coff[45]<=-158103;
//Coff[46]<=-152948;
//Coff[47]<=-148066;
//Coff[48]<=-143439;
//Coff[49]<=-139048;
//Coff[50]<=-134877;
//Coff[51]<=-130910;
//Coff[52]<=-127134;
//Coff[53]<=-123535;
//Coff[54]<=-120104;
//Coff[55]<=-116828;
//Coff[56]<=-113699;
//Coff[57]<=-110707;
//Coff[58]<=-107844;
//Coff[59]<=-105102;
//Coff[60]<=-102474;
//Coff[61]<=-99955;
//Coff[62]<=-97536;
//Coff[63]<=-95214;
//Coff[64]<=-92982;
//Coff[65]<=-90837;
//Coff[66]<=-88772;
//Coff[67]<=-86785;
//Coff[68]<=-84870;
//Coff[69]<=-83025;
//Coff[70]<=-81246;
//Coff[71]<=-79530;
//Coff[72]<=-77873;
//Coff[73]<=-76273;
//Coff[74]<=-74727;
//Coff[75]<=-73232;
//Coff[76]<=-71787;
//Coff[77]<=-70388;
//Coff[78]<=-69035;
//Coff[79]<=-67724;
//Coff[80]<=-66454;
//Coff[81]<=-65223;
//Coff[82]<=-64030;
//Coff[83]<=-62873;
//Coff[84]<=-61750;
//Coff[85]<=-60661;
//Coff[86]<=-59603;
//Coff[87]<=-58575;
//Coff[88]<=-57576;
//Coff[89]<=-56606;
//Coff[90]<=-55663;
//Coff[91]<=-54745;
//Coff[92]<=-53852;
//Coff[93]<=-52984;
//Coff[94]<=-52138;
//Coff[95]<=-51315;
//Coff[96]<=-50513;
//Coff[97]<=-49732;
//Coff[98]<=-48971;
//Coff[99]<=-48229;
//Coff[100]<=-47506;
//Coff[101]<=-46800;
//Coff[102]<=-46112;
//Coff[103]<=-45440;
//Coff[104]<=-44785;
//Coff[105]<=-44145;
//Coff[106]<=-43520;
//Coff[107]<=-42910;
//Coff[108]<=-42314;
//Coff[109]<=-41732;
//Coff[110]<=-41163;
//Coff[111]<=-40607;
//Coff[112]<=-40063;
//Coff[113]<=-39531;
//Coff[114]<=-39011;
//Coff[115]<=-38502;
//Coff[116]<=-38004;
//Coff[117]<=-37517;
//Coff[118]<=-37040;
//Coff[119]<=-36573;
//Coff[120]<=-36116;
//Coff[121]<=-35668;
//Coff[122]<=-35230;
//Coff[123]<=-34800;
//Coff[124]<=-34379;
//Coff[125]<=-33966;
//Coff[126]<=-33562;
//Coff[127]<=-33166;



	//////////////////////////////////////////////////////////////////////////////////
	// Integral
	
	Coff[0]=1677721.6;
    Coff[1]=838860.8;  
    Coff[2]=629145.6;
    Coff[3]=524288;
    Coff[4]=458752;
    Coff[5]=412876.8;
    Coff[6]=378470.4;
    Coff[7]=351436.8;
    Coff[8]=329472;
    Coff[9]=311168;
    Coff[10]=295609.6;
    Coff[11]=282172.8;
    Coff[12]=270415.6;
    Coff[13]=260015;
    Coff[14]=250728.75;
    Coff[15]=242371.125;
    Coff[16]=234797.02734375;
    Coff[17]=227891.232421875;
    Coff[18]=221560.920410156;
    Coff[19]=215730.369873047;
    Coff[20]=210337.110626221;
    Coff[21]=205329.084182739;
    Coff[22]=200662.514087677;
    Coff[23]=196300.285520554;
    Coff[24]=192210.696238875;
    Coff[25]=188366.482314098;
    Coff[26]=184744.049961904;
    Coff[27]=181322.863851498;
    Coff[28]=178084.955568436;
    Coff[29]=175014.525300014;
    Coff[30]=172097.616545014;
    Coff[31]=169321.848536224;
    Coff[32]=166676.194652845;
    Coff[33]=164150.797764166;
    Coff[34]=161736.815444104;
    Coff[35]=159426.289509189;
    Coff[36]=157212.035488228;
    Coff[37]=155087.54852217;
    Coff[38]=153046.922883721;
    Coff[39]=151084.78284675;
    Coff[40]=149196.223061166;
    Coff[41]=147376.756926273;
    Coff[42]=145622.27172477;
    Coff[43]=143928.989495412;
    Coff[44]=142293.432796601;
    Coff[45]=140712.394654416;
    Coff[46]=139182.912103825;
    Coff[47]=137702.242826125;
    Coff[48]=136267.844463353;
    Coff[49]=134877.356254543;
    Coff[50]=133528.582691997;
    Coff[51]=132219.478940115;
    Coff[52]=130948.13779646;
    Coff[53]=129712.778005928;
    Coff[54]=128511.733765132;
    Coff[55]=127343.445276358;
    Coff[56]=126206.450229248;
    Coff[57]=125099.37610443;
    Coff[58]=124020.933206978;
    Coff[59]=122969.908349291;
    Coff[60]=121945.159113047;
    Coff[61]=120945.608628514;
    Coff[62]=119970.240816994;
    Coff[63]=119018.096048605;
//    Coff[64]=118088.267173225;
//    Coff[65]=117179.895887277;
//    Coff[66]=116292.169403283;
//    Coff[67]=115424.317392811;
//    Coff[68]=114575.609176687;
//    Coff[69]=113745.351139175;
//    Coff[70]=112932.884345324;
//    Coff[71]=112137.582342892;
//    Coff[72]=111358.849132177;
//    Coff[73]=110596.117288806;
//    Coff[74]=109848.846226044;
//    Coff[75]=109116.520584537;
//    Coff[76]=108398.648738586;
//    Coff[77]=107694.761409115;
//    Coff[78]=107004.410374441;
//    Coff[79]=106327.167270805;
//    Coff[80]=105662.622475363;
//    Coff[81]=105010.384065021;
//    Coff[82]=104370.076845112;
//    Coff[83]=103741.341442431;
//    Coff[84]=103123.833457654;
//    Coff[85]=102517.222672609;
//    Coff[86]=101921.192308234;
//    Coff[87]=101335.438329451;
//    Coff[88]=100759.668793488;
//    Coff[89]=100193.603238468;
//    Coff[90]=99636.9721093659;
//    Coff[91]=99089.5162186551;
//    Coff[92]=98550.9862392058;
//    Coff[93]=98021.1422271671;
//    Coff[94]=97499.7531727673;
//    Coff[95]=96986.5965771211;
//    Coff[96]=96481.458053282;
//    Coff[97]=95984.1309499145;
//    Coff[98]=95494.4159960884;
//    Coff[99]=95012.1209658052;
//    Coff[100]=94537.0603609761;
//    Coff[101]=94069.0551116644;
//    Coff[102]=93607.9322924895;
//    Coff[103]=93153.5248541765;
//    Coff[104]=92705.6713693006;
//    Coff[105]=92264.2157913516;
//    Coff[106]=91829.007226298;
//    Coff[107]=91399.8997158948;
//    Coff[108]=90976.7520320249;
//    Coff[109]=90559.4274814193;
//    Coff[110]=90147.7937201401;
//    Coff[111]=89741.7225772566;
//    Coff[112]=89341.0898871796;
//    Coff[113]=88945.7753301566;
//    Coff[114]=88555.662280463;
//    Coff[115]=88170.6376618523;
//    Coff[116]=87790.5918098615;
//    Coff[117]=87415.4183405886;
//    Coff[118]=87045.0140255861;
//    Coff[119]=86679.2786725374;
//    Coff[120]=86318.1150114019;
//    Coff[121]=85961.4285857349;
//    Coff[122]=85609.1276489081;
//    Coff[123]=85261.1230649695;
//    Coff[124]=84917.3282139011;
//    Coff[125]=84577.6589010455;
//    Coff[126]=84242.0332704857;
//    Coff[127]=83910.3717221768;


for (i=0; i<WLength; i=i+1)
begin
    DReg[i] = 0;
end

end

always @(posedge clk)
begin
	if (rst ==0)
	begin
	
//		for (i=1; i<32; i=i+1)
//		begin
//			Reg[i] = Reg[i-1];
//			$monitor("Reg[%d]= %d \n" , i,$signed(Reg[i]) ) ;
//		end
//		// New Input at last position (31)
//		Reg[0]= Signal;
//		$monitor("Reg[%d]= %d \n" , i,$signed(Reg[i]) ) ;
		
		sum =0;
//		// Add every two adjasent signals to each other and average them 
		for (i=0; i<WLength; i=i+1)
		begin
		// reg[31]  
			temp1 = Signal*Coff[i]; 
			
			sum = DReg[i] + temp1[55:24];
			
			if (i ==0)
			 begin
			     Output = sum;
             end
			else
                begin
                
                     DReg[i-1] =  DReg[i] + temp1[55:24];
                end
		end

		OutInd = !OutInd;
		
		
	end

end

endmodule
