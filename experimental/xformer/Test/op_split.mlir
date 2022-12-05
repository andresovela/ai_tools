// RUN: xcore-opt --mlir-io --xcore-op-split %s

// CHECK-LABEL: conv2d_1x1_stride_1
func.func @conv2d_1x1_stride_1(%arg0: tensor<?x6x6x4x!quant.uniform<i8:f32, 0.0039214449934661388:-128>> {tf_saved_model.index_path = ["input_2"]}) -> (tensor<?x144x!quant.uniform<i8:f32, 0.0032160764094442129:-128>> {tf_saved_model.index_path = ["flatten_1"]}) attributes {tf.entry_function = {inputs = "serving_default_input_2:0", outputs = "StatefulPartitionedCall:0"}, tf_saved_model.exported_names = ["serving_default"]} {
  // CHECK: tfl.strided_slice
  // CHECK: tfl.strided_slice
  // CHECK: tfl.conv_2d
  // CHECK: tfl.conv_2d
  // CHECK: tfl.concatenation
  %0 = "tfl.pseudo_qconst"() {qtype = tensor<4x1x1x4x!quant.uniform<i8<-127:127>:f32:0, {0.0057157878763973713,0.0063750739209353924,0.0039762118831276894,0.0061128144152462482}>>, value = dense<[[[[-17, 25, -70, -127]]], [[[24, 51, 11, -127]]], [[[-127, 22, -2, -44]]], [[[127, -84, 14, -67]]]]> : tensor<4x1x1x4xi8>} : () -> tensor<4x1x1x4x!quant.uniform<i8<-127:127>:f32:0, {0.0057157878763973713,0.0063750739209353924,0.0039762118831276894,0.0061128144152462482}>>
  %1 = "tfl.pseudo_qconst"() {qtype = tensor<4x!quant.uniform<i32:f32:0, {2.2414147679228336E-5,2.4999500965350308E-5,1.5592495401506312E-5,2.3971066184458323E-5}>>, value = dense<0> : tensor<4xi32>} : () -> tensor<4x!quant.uniform<i32:f32:0, {2.2414147679228336E-5,2.4999500965350308E-5,1.5592495401506312E-5,2.3971066184458323E-5}>>
  %2 = "tfl.conv_2d"(%arg0, %0, %1) {dilation_h_factor = 1 : i32, dilation_w_factor = 1 : i32, fused_activation_function = "RELU", padding = "VALID", stride_h = 1 : i32, stride_w = 1 : i32} : (tensor<?x6x6x4x!quant.uniform<i8:f32, 0.0039214449934661388:-128>>, tensor<4x1x1x4x!quant.uniform<i8<-127:127>:f32:0, {0.0057157878763973713,0.0063750739209353924,0.0039762118831276894,0.0061128144152462482}>>, tensor<4x!quant.uniform<i32:f32:0, {2.2414147679228336E-5,2.4999500965350308E-5,1.5592495401506312E-5,2.3971066184458323E-5}>>) -> tensor<?x6x6x4x!quant.uniform<i8:f32, 0.0032160764094442129:-128>>
  %3 = "tfl.pseudo_const"() {value = dense<[-1, 144]> : tensor<2xi32>} : () -> tensor<2xi32>
  %4 = "tfl.reshape"(%2, %3) : (tensor<?x6x6x4x!quant.uniform<i8:f32, 0.0032160764094442129:-128>>, tensor<2xi32>) -> tensor<?x144x!quant.uniform<i8:f32, 0.0032160764094442129:-128>>
  return %4 : tensor<?x144x!quant.uniform<i8:f32, 0.0032160764094442129:-128>>
}

// CHECK-LABEL: conv2d_2x2_stride_1
func.func @conv2d_2x2_stride_1(%arg0: tensor<?x96x129x16x!quant.uniform<i8:f32, 0.0039215688593685627:-128>> {tf_saved_model.index_path = ["input_1"]}) -> (tensor<?x778240x!quant.uniform<i8:f32, 0.0060480642132461071:-128>> {tf_saved_model.index_path = ["flatten"]}) attributes {tf.entry_function = {inputs = "serving_default_input_1:0", outputs = "StatefulPartitionedCall:0"}, tf_saved_model.exported_names = ["serving_default"]} {
  // CHECK: tfl.strided_slice
  // CHECK: tfl.strided_slice
  // CHECK: tfl.conv_2d
  // CHECK: tfl.conv_2d
  // CHECK: tfl.concatenation
  %0 = "tfl.pseudo_qconst"() {qtype = tensor<64x2x2x16x!quant.uniform<i8<-127:127>:f32:0, {0.001065905555151403,0.0010670513147488236,0.0010477815521880984,0.0010631313780322671,0.0010703536681830883,0.0010570036247372627,0.0010382768232375383,0.0010491423308849335,0.0010686175664886832,0.0010751225054264069,0.0010760604636743665,0.0010638592066243291,0.0010743640596047044,0.00101856654509902,0.0010732602095231414,0.0010267243487760425,0.0010232188506051898,0.0010596285574138165,0.0010755019029602408,0.0010781297460198402,0.0010735997930169106,0.0010376893915235996,0.0010667981114238501,0.0010738812852650881,0.0010665202280506492,0.0010666919406503439,0.0010603619739413261,0.0010683576110750437,0.0010770333465188742,0.00107717199716717,0.0010766783962026238,0.0010747029446065426,0.001076066866517067,0.001075996900908649,0.0010360238375142217,0.0010342702735215425,0.0010674947407096624,0.0010778474388644099,0.0010523672681301832,0.0010767990024760365,0.0010739784920588136,0.001045805518515408,0.0010710640344768763,0.0010564984986558557,0.0010416595032438636,0.0010776311391964555,0.0010717884870246053,0.0010707515757530928,0.0010499937925487757,0.001066987169906497,0.0010618156520649791,0.0010680798441171646,0.0010375389829277992,0.0010658849496394396,0.00105603679548949,0.0010576631175354123,0.0010566713754087687,0.0010707643814384937,0.0010719463462010026,0.0010744355386123061,0.0010771187953650951,0.0010688217589631677,0.0010752691887319088,0.0010739229619503021}>>, value = dense<"0xDAD0CD6289A7C8AEE1EEE6E7681DE7AFE3628AD581707AB07E654DD20F9068FCF38C7BD48843E9B23D2BCB073C70CB334367BE8C918D7759FA0882C88EB09B409134C40CBAFCD535919C0F390ECBAAEA43589C346836585E8F51D3B31EBFC57A3F4D98B9179773AC856A722CB5E114C9AF06E4DA597053A4FA8597B4D3707FC309C1F091786CA0F02BF5287D4451EED471942077774088FD4C5CC99181D81E4A7BD2583F1A3F0770E53152D1245FF5CBD8C12EC12D0548857571F69A89379DBC28D61E76A8A712667B999C48F138727BA9CA14C87949348128FFA59456394935C22F784C00375254F8E2D3D7F13CFEA1FCCD186CB60792A69A31B74BC4B900520EEEC50F386001B3D6DFDC2854190CFAC07F238BD86C09D83169B4C42A05904AB5DF6E0C3EAF50ED2025A9CDCFB47A9BD28A511A1736B79566D83C8CFC1A14F60D92D56AB66AC20293DB27E36F8E0FCD69EBCA657BF371B2DF7F17EA5D451736EFBAE7F466D9F6AB96A1E408247F37D7E2FC340948A09A9B20083DF999D40BB8FBB63238034E9162B0CE9385A73167AB4FE4BB3B9F9726C81429F6F7B7864FAF7350B3D79EBCDDD3BFC70AD2A5986FBF8C396F5ED7FB8142311F19C047FF9457ACBED6EA86DE1228B3D574757EB169C7A84856CFFC6A8681B475ADFB705FFB78F04A27B102CB21C7FF63244BD9C28BFBB00B8B3E07109A05B290C2DD87FA438C95409F4137D24E3000E89ACD8EE054B687615535248C86F5A5C647FEE32F815B10D34647CCFC584898ED9BBCD427626417CF19F7DA478E980467A031B938DB7186A717AF8A0651718F2777CB42C84BB3E2C0281BAA9D445D86AAF6F0C5EE1FB2707F415AE33DEBBD34601B38A96715C4FAC4B441C416DF360BDBA145630A77510E73570DA717B9434B3AA0EBF0B15B06031856C7C69036947FB64FE5D28445D56200931EE469D760561C2D873859901F209D3D0E402E7B425D318A6B72B1689ABB1F6F0090131481DD899FF3580951EDCCE778B662C8B6D15976870E5EA5B52A5DDD1CE0EEF12DEE19CF7E04726CEE26387629F046502D2C403F58F8F127AD84A9132B7F4D094FD9546C8DDA7EFFCBBC0D7D3C5A46429671E4B8338A30508A366D20AA5E6F5EC6CD1F06A2F07A6AB62DC9BEB5F65862D29D653C4BD756DE66ABFDE9D9506EB90C95C4489FAE47034D2B07020CD22FA53274D7AFE7BBDD289475140F06BA47D9BFE10A07CA17213E74D342BBBD8198D2DDBED0ECC6DA710EC7A4FB2C26CC28F13ECD1F0E0962630F4BA6485A5CE2FA811305B6C7C758AAC730E7AFE9F1FA0508625F6DD17AF00EAA6FF3CC5BED1DD724963F693521EA5F5922B446E53FF38B3878C545B13CCD2579352E9FEE5FCD4FD9B0489499C61F070055A47B9B2223BE69B70092E76023B0E12AF9AC75055AE49F3AC38155E109423FC5D479A88AC597776AE556FD7860E56133110CA9A6FB828A984FFE5F046CEF325F54DB6187D4ABB787FD706727FAF4DFB8E9DA863F0C0A323BBF303B6F4A7B7F750A7B1A0C22CC6D1AF814F1DDFAC3E54094DB2828ED894FCDEE61472EA76D253B142CDC3016DF2B84D0D05B482063838EEAC5FF5A4B2693810A03001F82F2B348051F551D8250B2BB4D35B41DA311C185D3F9F9D8154581655779DB7C668751F527EF07AFF54EA7BF6A53293F157EB33916239551BCA01FE6F43A1A5D17989A17238F02F948409DEA280469F3B767F4216A183EC6A72BB51E0A6B0F22FECB093FC9609F045ED6F6575C038FF5E34CF106B06594E98403A488B840D7144281272AE910D4B3BA600402655E278A784869B5271894C3BBD30E3A2BEECF38689FC70EAE1EB1611ADD1970C2A4F20C7FBC42283E85E563D22702699EFCA292DF401BBF7706C3E6472CBFF606F8E97486FCD03CA03873F5B28D1F5786529DA71A66218343CB18E9B978921A36588B0C436816E37949507A060943F18170E461FDE6B6A418AADC10AEB00A5464EE724F1F50983B867F5E3D3467DBCFEAD3FC1782B1DEB4484C783BA78AF7DEFD3C4D3323ED5FB56A4878158590D1DAF2147BD6C3D2D71EA6462602908779AC70954CE5B7FC5B60EB458A265886568C8DFB2E83F4A0817E875E8E3622EBFA9F1637019093403E5D010F6FE82D44F4B7C4A50BCC9F5C2ECC864501DA17F9D14B62F138B9A2DFC11F441B4C49580EA25317AAEBAF6D747F293ED3216A1DDEC1DA06F7338A82AC11AB12FF279FAF1B9A1CC88EF01DC9577A626ECED0399FC2A612BC18B4A16B13824C9F5640B4603AF5CDB9CC9BD7EBB45E33A7F9C626183EADC27AE586CDDF133CE42592217FE913091814F4CD024383BB47642A283DB2AF9A67EDCED8C4FBD835D65081BC0D74189C1FF8C151582DDE049255574516A6959C8B40B06398E76673C5865EC6E8CF93CBC3B851500627AD1CFEAFDC50E4ED81A52AEDB7F38C00DCD184EFA0565D9C4E2948FF7FF683BEEBA1A9DEB1D77A155445359743CF12C46DC9F55E3D7A50C24C6EA56809592AA9758D5DC6F90B3E8BCAAC741D2986480EB63D710836DEFC6F136D98959F8719A526B3AE7621116240ED816B0D414ADBF7088DBE50E05DDFB7B64C9E05AF36C5024E422D2D0F683845A48C0BB55E07B1B4C35AFC90130EC3666A814BD3B2393923DE5C3A828BB35A1DB41CB4BC75CD14CA3726A86622BF2150ADB9A8952433A7E5AEEEDFA8F6AEA34D29FA9126A817F7B1764C17B3F747D02E13B636EF5AF300A25236336B2623F08AA23FCA28B5C7D58F34CC898A38338B0CAF953A15AE7F5477F4422E6EDC6A25E43E33ECA10093CA765C6693CE8A486CD703128691A91F347EFE330D1C96CE6D0CB6EA7951F6B19EA05751C8C6C7049E44BB2A8196B5E10C20940771CFA45B03913FD36E847B49687013326F9C3A667F140CB4D5ED0A5C641E53565E6120DC9F4DD87F0D3281BBA11E8AF49B99054F4379D7CC6E287FD7DBB04470EE1DEA82B295BA4C60D6FF1D5FEEEBC5D065969B9608A9C2197B50714E54A902E13A0A4A70B442AC4417F2A15363331B7F1F460495E8B241A2CE5BFF864C75BC6235BC694CD7D7812BA6ED47667842AFE8E643E70A11708861DD5AF11DAB0A5507A974D3B8FC9619DFE3047A8E256898B77C1B3135D1A641289E726140425A1EEF1FA8ADF7AE246DB6C474661000A15DCA6447EDA56E5BE41F5D18C9BE39CF6A043B0D9590099B9AD6EE399C3E2A68A0503D0B6EBB814FEFD489B46AAD47068FA34802A1BAB2CE8DF53CA522953758D72E757463FE24BB4BE2DE41AC8B292A85DC6A2FFA1240B82599C6AD5D4D2E75437F5B29C561A3DE004AD6A10A12A968F848DD951A8E2108EBE13EBC1C7F5DE5921B6CD41BFFC5E246F2910519D62F69E5AE7A63AA85C7FD55FE8FC75E6045DCF37EAB385A7A933F1CF49AAC6E74CB8240175CD86D447BE3C0177393D6FA21F36819F8D064EBC2280B0B252AA1D8D5E5D3B56DC63416B1109481CFF4CBA193529968C3C3C9A4861D8FAF75B93551CB053C50A592E0967BB10C4416B30C4790A66A7CAD6E6A7B323D687B43300E4748096FE0D0D9BD96218613AB445A152910054CBB6D4A70A80959CB2239BECC812349E3A1769A6643119B0B51C7A7982356D8867FDE58C93EF0868AEF617C2234F1D7501156F663F0085A63F8E4C3B314A095347731D16859DAD389C4917A98F7DEC75B44ADC10490442245CC913865B2949DD78777E2075205237D4EF2A245905FC3CA04620E301858FD21B9A07FA6A01A502627AF701E6FB68BAE17ECF2C16A919845A5B0031452A35273F69F3AC5CB582E6164D39F0F52CBDC4E0CDC69DFFC270C15ED7989BF4AEAE2DC4AE2B806B8FEB7637C0164D8130E42F1B5187F9540130AF4DE648C3EC64BB39C8187A76B663EEB8ADFFC2EA1102ADAB3342E8932BFCD0D9031C8B82C029274BF741C86D7CB8742D5FE5D59B05B743008A3B674943714999C4FAF7FE9BA869437930770201FDCFE7285722A977373CB245ADA9D5E8F07286F4A8B01A78C27A21562896466BBC3DBB9719FE3A10F28B991F0D9D9975658A57CE9BB22BCFE854729A80D8E52E2A2351E02DB55365A5A18646F952A1982E81758B8A45A1AA6F2ACC6D49319396445BF244477DE62A09A47F5819B85C4624279457151474B9BAA11437164B37C2EE1FB4AD6C8F7F42CA1967F8C6D74ADAC4873EDFFD42BF118BFE4913552F51A08043E1D7AA84A47305FD88665BA61F64A5E4F8F572599CB8CA0AD835FAE815007A11F8375D3A9459973D5E36477015312ABBF596B6D680E71DAEF3EFB22F20A765987F505969AC19C9EFFE4B56CE54B21DA5CA130FB63B71432B2126E260D19E8E9216104392CBD8EBAB6C523CF34BC799C5A8430CF7AA02563068F286B6092B20E76EF91A667AF152540C5BD29DA317F516E9D7BFF1D9786DEFAFE5D7AD8D2979ABD5F2BD637097BE6FB4423442C03317B0E2420A8E3E525FB4DB5107AC210518C4B90374901337FA1F4A90103F8811A638C24563E5ED439A699A18E255E5FDDDC4F852039750D02E1BDCEE77498314A4ABB863CA644214C65F7A613FDB5F4B4FB8BDD813DBAA451FEC5FAD0E8FBCB75ABD227627D8CC29531D6CFBF3F77B5F6CA636E54F6CDB09B0D57AB31891E3C3C72D939B8CA676C67B87C7F3595B233975F0AF1DC7F98A1296BA501F70232C8DF55037E873F44FA240117A72AF211B901BF447CCDFC8B150E3AFEEC474E76E5A1C17FD7B069FDC84A59B10FC8F09DD58E2A1B524B4DE819D038787C11DC5E1806FA285A1C5131CAF628C14AC0B7438D8FEFF46B5C088BAA21EB058FB3652626490F2BAD9D7688B689DFEBDA1B13F242C5A994747B028C50218BBDBE9D17DDC4A295D0927F163430AE1F50493BF0F0DDF9BC4C8645E68D688106FC8A66FE394316474FDDC31C957C566E2CA7594EB92DDE636C42E6403B095730BFB0EF6AB881720138B9CB60B706B247D85E61BAD540FC6E5C5D1A3557B4D3F61AF4D19300B51642DB518987112D0EEE472ED8F165D19A57AD6D0A11018F92352DDF51033E386E6A097F2907E543108FEFB02541FA89688B16A109E7BAD4F86C40F95AABF958CC66603D33173359566B5C996D7F625F00AD34726BB12D103003BFB796904932C33F0E8E030F14FB1346B69785E0FE6DE73AA61A65A5C5F3D353C717A166FB7EF0DD62282E7F840B68C2068798C8D1E1181D7D9272CEF0406D0D129E7FFF9BF107DAD765E3E0D053DD1203B67FF846B32AEE88F9E907243077028471E6EDE0D71CD9BEA26FF1B83EA250B8DA6F7C28070F83CCE26323F7AAC457A662CCD08BAC65B4913ADC4D42447A23864A56F7BB29EEB4D83EFA08A160A30E928C72AE405796DA1E38210681D48B6944FF1874227399EA54D8360BA851FFF342B0915157C47DB738B0F107D5D0A50D1B34E80B527315EB34B6A50B73BD48969735B27F00D5783E7EDB0B04C35DD4F8C2C088BA3F4991E6EB3ED0C5115477E83665A655E9ADE579E29C85AC2B838BAF8F25EE56FFA8333E93853516C242B06B448C55D72E3EC361A7C1EAE9B7CA95B5159235CF5FAA1330E1027F0572698708CF15D815BBCF101CDB0536C88DD34773DF0FDC6C7171E1A5C3D07CB15E9DF4EF463EBF81948CDCFD5273490F3E60B4E9BC714F798DFF662B90C033C39764D438AB5E1F721617C5D19A444D5D29EF849BCE6A67FC6FFEBB9227F6B7817F4FA60521EC3A8A538E36C3DEE3ADEFBEAFA91CCCF6E79409D756D0CE2B436BA7CBF95ACB8AF807A13B16A3D3BB6230"> : tensor<64x2x2x16xi8>} : () -> tensor<64x2x2x16x!quant.uniform<i8<-127:127>:f32:0, {0.001065905555151403,0.0010670513147488236,0.0010477815521880984,0.0010631313780322671,0.0010703536681830883,0.0010570036247372627,0.0010382768232375383,0.0010491423308849335,0.0010686175664886832,0.0010751225054264069,0.0010760604636743665,0.0010638592066243291,0.0010743640596047044,0.00101856654509902,0.0010732602095231414,0.0010267243487760425,0.0010232188506051898,0.0010596285574138165,0.0010755019029602408,0.0010781297460198402,0.0010735997930169106,0.0010376893915235996,0.0010667981114238501,0.0010738812852650881,0.0010665202280506492,0.0010666919406503439,0.0010603619739413261,0.0010683576110750437,0.0010770333465188742,0.00107717199716717,0.0010766783962026238,0.0010747029446065426,0.001076066866517067,0.001075996900908649,0.0010360238375142217,0.0010342702735215425,0.0010674947407096624,0.0010778474388644099,0.0010523672681301832,0.0010767990024760365,0.0010739784920588136,0.001045805518515408,0.0010710640344768763,0.0010564984986558557,0.0010416595032438636,0.0010776311391964555,0.0010717884870246053,0.0010707515757530928,0.0010499937925487757,0.001066987169906497,0.0010618156520649791,0.0010680798441171646,0.0010375389829277992,0.0010658849496394396,0.00105603679548949,0.0010576631175354123,0.0010566713754087687,0.0010707643814384937,0.0010719463462010026,0.0010744355386123061,0.0010771187953650951,0.0010688217589631677,0.0010752691887319088,0.0010739229619503021}>>
  %1 = "tfl.pseudo_qconst"() {qtype = tensor<64x!quant.uniform<i32:f32:0, {4.180022187938448E-6,4.1845150917652063E-6,4.1089474507316481E-6,4.1691428123158403E-6,4.197465386823751E-6,4.1451125980529469E-6,4.0716740841162391E-6,4.1142839108943008E-6,4.1906573642336298E-6,4.2161668716289569E-6,4.2198453229502775E-6,4.1719972614373546E-6,4.2131928239541594E-6,3.9943788578966632E-6,4.2088636291737203E-6,4.026370334031526E-6,4.0126233216142282E-6,4.1554062590876129E-6,4.2176548049610574E-6,4.2279598346794955E-6,4.2101955841644667E-6,4.0693703340366483E-6,4.1835223782982212E-6,4.2112992559850682E-6,4.1824323488981463E-6,4.1831058297248092E-6,4.1582825360819697E-6,4.1896378206729423E-6,4.2236606532242149E-6,4.2242040763085242E-6,4.2222686715831514E-6,4.2145215957134496E-6,4.2198703340545762E-6,4.2195961214019917E-6,4.062838797835866E-6,4.0559621083957609E-6,4.1862540456349961E-6,4.2268529796274379E-6,4.1269308894698042E-6,4.2227416088280734E-6,4.2116807890124619E-6,4.1011985558725428E-6,4.2002511690952815E-6,4.1431317185924854E-6,4.0849395190889481E-6,4.2260048758180346E-6,4.2030924305436201E-6,4.1990260797319934E-6,4.1176231206918601E-6,4.1842636164801661E-6,4.1639832488726825E-6,4.1885487007675692E-6,4.0687805267225485E-6,4.1799412429099903E-6,4.1413209146412555E-6,4.1476987462374382E-6,4.1438097468926571E-6,4.1990761019405909E-6,4.2037113416881766E-6,4.2134729483223055E-6,4.2239953472744673E-6,4.1914581743185408E-6,4.2167421270278282E-6,4.2114629650313873E-6}>>, value = dense<0> : tensor<64xi32>} : () -> tensor<64x!quant.uniform<i32:f32:0, {4.180022187938448E-6,4.1845150917652063E-6,4.1089474507316481E-6,4.1691428123158403E-6,4.197465386823751E-6,4.1451125980529469E-6,4.0716740841162391E-6,4.1142839108943008E-6,4.1906573642336298E-6,4.2161668716289569E-6,4.2198453229502775E-6,4.1719972614373546E-6,4.2131928239541594E-6,3.9943788578966632E-6,4.2088636291737203E-6,4.026370334031526E-6,4.0126233216142282E-6,4.1554062590876129E-6,4.2176548049610574E-6,4.2279598346794955E-6,4.2101955841644667E-6,4.0693703340366483E-6,4.1835223782982212E-6,4.2112992559850682E-6,4.1824323488981463E-6,4.1831058297248092E-6,4.1582825360819697E-6,4.1896378206729423E-6,4.2236606532242149E-6,4.2242040763085242E-6,4.2222686715831514E-6,4.2145215957134496E-6,4.2198703340545762E-6,4.2195961214019917E-6,4.062838797835866E-6,4.0559621083957609E-6,4.1862540456349961E-6,4.2268529796274379E-6,4.1269308894698042E-6,4.2227416088280734E-6,4.2116807890124619E-6,4.1011985558725428E-6,4.2002511690952815E-6,4.1431317185924854E-6,4.0849395190889481E-6,4.2260048758180346E-6,4.2030924305436201E-6,4.1990260797319934E-6,4.1176231206918601E-6,4.1842636164801661E-6,4.1639832488726825E-6,4.1885487007675692E-6,4.0687805267225485E-6,4.1799412429099903E-6,4.1413209146412555E-6,4.1476987462374382E-6,4.1438097468926571E-6,4.1990761019405909E-6,4.2037113416881766E-6,4.2134729483223055E-6,4.2239953472744673E-6,4.1914581743185408E-6,4.2167421270278282E-6,4.2114629650313873E-6}>>
  %2 = "tfl.conv_2d"(%arg0, %0, %1) {dilation_h_factor = 1 : i32, dilation_w_factor = 1 : i32, fused_activation_function = "RELU", padding = "VALID", stride_h = 1 : i32, stride_w = 1 : i32} : (tensor<?x96x129x16x!quant.uniform<i8:f32, 0.0039215688593685627:-128>>, tensor<64x2x2x16x!quant.uniform<i8<-127:127>:f32:0, {0.001065905555151403,0.0010670513147488236,0.0010477815521880984,0.0010631313780322671,0.0010703536681830883,0.0010570036247372627,0.0010382768232375383,0.0010491423308849335,0.0010686175664886832,0.0010751225054264069,0.0010760604636743665,0.0010638592066243291,0.0010743640596047044,0.00101856654509902,0.0010732602095231414,0.0010267243487760425,0.0010232188506051898,0.0010596285574138165,0.0010755019029602408,0.0010781297460198402,0.0010735997930169106,0.0010376893915235996,0.0010667981114238501,0.0010738812852650881,0.0010665202280506492,0.0010666919406503439,0.0010603619739413261,0.0010683576110750437,0.0010770333465188742,0.00107717199716717,0.0010766783962026238,0.0010747029446065426,0.001076066866517067,0.001075996900908649,0.0010360238375142217,0.0010342702735215425,0.0010674947407096624,0.0010778474388644099,0.0010523672681301832,0.0010767990024760365,0.0010739784920588136,0.001045805518515408,0.0010710640344768763,0.0010564984986558557,0.0010416595032438636,0.0010776311391964555,0.0010717884870246053,0.0010707515757530928,0.0010499937925487757,0.001066987169906497,0.0010618156520649791,0.0010680798441171646,0.0010375389829277992,0.0010658849496394396,0.00105603679548949,0.0010576631175354123,0.0010566713754087687,0.0010707643814384937,0.0010719463462010026,0.0010744355386123061,0.0010771187953650951,0.0010688217589631677,0.0010752691887319088,0.0010739229619503021}>>, tensor<64x!quant.uniform<i32:f32:0, {4.180022187938448E-6,4.1845150917652063E-6,4.1089474507316481E-6,4.1691428123158403E-6,4.197465386823751E-6,4.1451125980529469E-6,4.0716740841162391E-6,4.1142839108943008E-6,4.1906573642336298E-6,4.2161668716289569E-6,4.2198453229502775E-6,4.1719972614373546E-6,4.2131928239541594E-6,3.9943788578966632E-6,4.2088636291737203E-6,4.026370334031526E-6,4.0126233216142282E-6,4.1554062590876129E-6,4.2176548049610574E-6,4.2279598346794955E-6,4.2101955841644667E-6,4.0693703340366483E-6,4.1835223782982212E-6,4.2112992559850682E-6,4.1824323488981463E-6,4.1831058297248092E-6,4.1582825360819697E-6,4.1896378206729423E-6,4.2236606532242149E-6,4.2242040763085242E-6,4.2222686715831514E-6,4.2145215957134496E-6,4.2198703340545762E-6,4.2195961214019917E-6,4.062838797835866E-6,4.0559621083957609E-6,4.1862540456349961E-6,4.2268529796274379E-6,4.1269308894698042E-6,4.2227416088280734E-6,4.2116807890124619E-6,4.1011985558725428E-6,4.2002511690952815E-6,4.1431317185924854E-6,4.0849395190889481E-6,4.2260048758180346E-6,4.2030924305436201E-6,4.1990260797319934E-6,4.1176231206918601E-6,4.1842636164801661E-6,4.1639832488726825E-6,4.1885487007675692E-6,4.0687805267225485E-6,4.1799412429099903E-6,4.1413209146412555E-6,4.1476987462374382E-6,4.1438097468926571E-6,4.1990761019405909E-6,4.2037113416881766E-6,4.2134729483223055E-6,4.2239953472744673E-6,4.1914581743185408E-6,4.2167421270278282E-6,4.2114629650313873E-6}>>) -> tensor<?x95x128x64x!quant.uniform<i8:f32, 0.0060480642132461071:-128>>
  %3 = "tfl.pseudo_const"() {value = dense<[-1, 778240]> : tensor<2xi32>} : () -> tensor<2xi32>
  %4 = "tfl.reshape"(%2, %3) : (tensor<?x95x128x64x!quant.uniform<i8:f32, 0.0060480642132461071:-128>>, tensor<2xi32>) -> tensor<?x778240x!quant.uniform<i8:f32, 0.0060480642132461071:-128>>
  return %4 : tensor<?x778240x!quant.uniform<i8:f32, 0.0060480642132461071:-128>>
}
