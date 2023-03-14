// RUN: xcore-opt --mlir-io --xcore-op-split --xcore-op-split-start-op=1 --xcore-op-split-end-op=0 --xcore-op-split-num-splits=4 %s | FileCheck %s

  // CHECK-LABEL: conv2d_depthwise 
  func.func @conv2d_depthwise(%arg0: tensor<?x192x256x3x!quant.uniform<i8:f32, 0.0039215679280459881:-128>> {tf_saved_model.index_path = ["input_3"]}) -> (tensor<?x49152x!quant.uniform<i8:f32, 0.001226827735081315:-128>> {tf_saved_model.index_path = ["flatten_2"]}) attributes {tf.entry_function = {inputs = "serving_default_input_3:0", outputs = "StatefulPartitionedCall:0"}, tf_saved_model.exported_names = ["serving_default"]} {
  // CHECK: tfl.strided_slice
  // CHECK: tfl.pad
  // CHECK: tfl.conv_2d
  // CHECK: tfl.pad
  // CHECK: tfl.depthwise_conv_2d
  // CHECK: tfl.strided_slice
  // CHECK: tfl.pad
  // CHECK: tfl.conv_2d
  // CHECK: tfl.pad
  // CHECK: tfl.depthwise_conv_2d
  // CHECK: tfl.strided_slice
  // CHECK: tfl.pad
  // CHECK: tfl.conv_2d
  // CHECK: tfl.pad
  // CHECK: tfl.depthwise_conv_2d
  // CHECK: tfl.strided_slice
  // CHECK: tfl.pad
  // CHECK: tfl.conv_2d
  // CHECK: tfl.pad
  // CHECK: tfl.depthwise_conv_2d 
  // CHECK: tfl.concatenation
  // CHECK-NOT: tfl.strided_slice
  // CHECK-NOT: tfl.concatenation
  %0 = "tfl.pseudo_qconst"() {qtype = tensor<16x3x3x3x!quant.uniform<i8<-127:127>:f32:0, {0.0013223476707935333,0.0013782919850200415,0.0012090797536075115,0.0013927071122452617,0.0014158322010189295,0.0013977244962006807,0.0013787330826744437,0.0014684946509078145,0.0014414374018087983,0.0013986328849568963,0.001444036141037941,0.0014677828876301646,0.0014395674224942923,0.0014684781199321151,0.0014254916459321976,0.0014261894393712282}>>, value = dense<"0x37EFEEBF8132A1D77CFCF3661A05FA197CC026E1D706FBB01C6001EAC0CE0D40C7185F25D5E6A2207FBA0D2E30A8A7A9F3BE65A51247E87F8A45948604EFB0BB7F8E73B90E4AA01543D958E5F97C150BE0CCAD916D305D559C07865AA481E8903E2C6EEAE8CDAB3568FBFBBBE795D834C1AADA0F1F74812988D71FC344422C0804AB36400529C48CA906109452C59F891D2B4C94869DF5947C7F9D167738D8DC94D81A0B81828FB738EF61CAB37F83CA82FCB3D1CAEBBCC91EE2EB713DA61FBEF49984B37F265F1F269787339B2C642BCCD51FCFBFAA66EB847C4E32D3871087C57D936C97A46DF2C00ED4F696BCC07F69974123E1DA480DE17F5CD6ED4C2D3B542329E065ABA439B1FEF34C7DD0E629CF887E01DEFB4892342B22447F21FE3CFB09A47F93C6E64D2DB6DD909D4564339A81922024B049C92EF8E95516F5C82C5B58F738E0FDF448967FC2FC0AC835EEF38B9FB8F31C663500426CC2719E1B263E612B2FBCA173BA6144B1576BBDBBDB04818E7CD7D11E469431510112D9A40D54BD073B653EE802F2106E6C535D97524E288119BA39959E5D34ED21FD52306E528C1FA8EB7F6247517FF4BB2444CB90"> : tensor<16x3x3x3xi8>} : () -> tensor<16x3x3x3x!quant.uniform<i8<-127:127>:f32:0, {0.0013223476707935333,0.0013782919850200415,0.0012090797536075115,0.0013927071122452617,0.0014158322010189295,0.0013977244962006807,0.0013787330826744437,0.0014684946509078145,0.0014414374018087983,0.0013986328849568963,0.001444036141037941,0.0014677828876301646,0.0014395674224942923,0.0014684781199321151,0.0014254916459321976,0.0014261894393712282}>>
  %1 = "tfl.pseudo_qconst"() {qtype = tensor<16x!quant.uniform<i32:f32:0, {5.1856764002877753E-6,5.4050656217441428E-6,4.7414882828888949E-6,5.4615957196801901E-6,5.5522823458886705E-6,5.4812717280583456E-6,5.406795480666915E-6,5.7588013078202493E-6,5.6526946536905598E-6,5.4848337640578393E-6,5.6628859965712763E-6,5.7560105233278591E-6,5.6453613979101647E-6,5.7587367336964235E-6,5.5901623454701621E-6,5.592898560280446E-6}>>, value = dense<0> : tensor<16xi32>} : () -> tensor<16x!quant.uniform<i32:f32:0, {5.1856764002877753E-6,5.4050656217441428E-6,4.7414882828888949E-6,5.4615957196801901E-6,5.5522823458886705E-6,5.4812717280583456E-6,5.406795480666915E-6,5.7588013078202493E-6,5.6526946536905598E-6,5.4848337640578393E-6,5.6628859965712763E-6,5.7560105233278591E-6,5.6453613979101647E-6,5.7587367336964235E-6,5.5901623454701621E-6,5.592898560280446E-6}>>
  %2 = "tfl.conv_2d"(%arg0, %0, %1) {dilation_h_factor = 1 : i32, dilation_w_factor = 1 : i32, fused_activation_function = "RELU", padding = "SAME", stride_h = 2 : i32, stride_w = 2 : i32} : (tensor<?x192x256x3x!quant.uniform<i8:f32, 0.0039215679280459881:-128>>, tensor<16x3x3x3x!quant.uniform<i8<-127:127>:f32:0, {0.0013223476707935333,0.0013782919850200415,0.0012090797536075115,0.0013927071122452617,0.0014158322010189295,0.0013977244962006807,0.0013787330826744437,0.0014684946509078145,0.0014414374018087983,0.0013986328849568963,0.001444036141037941,0.0014677828876301646,0.0014395674224942923,0.0014684781199321151,0.0014254916459321976,0.0014261894393712282}>>, tensor<16x!quant.uniform<i32:f32:0, {5.1856764002877753E-6,5.4050656217441428E-6,4.7414882828888949E-6,5.4615957196801901E-6,5.5522823458886705E-6,5.4812717280583456E-6,5.406795480666915E-6,5.7588013078202493E-6,5.6526946536905598E-6,5.4848337640578393E-6,5.6628859965712763E-6,5.7560105233278591E-6,5.6453613979101647E-6,5.7587367336964235E-6,5.5901623454701621E-6,5.592898560280446E-6}>>) -> tensor<?x96x128x16x!quant.uniform<i8:f32, 0.0042878598906099796:-128>>
  %3 = "tfl.pseudo_qconst"() {qtype = tensor<1x5x5x16x!quant.uniform<i8<-127:127>:f32:3, {9.0307911159470677E-4,9.0185547014698386E-4,9.0475002070888877E-4,8.9984521036967635E-4,9.1002165572717786E-4,8.8369252625852823E-4,9.2316285008564591E-4,8.6251541506499052E-4,9.3441049102693796E-4,8.4356177831068635E-4,9.306154097430408E-4,8.7729789083823562E-4,9.350875043310225E-4,9.1074523515999317E-4,9.1593258548527956E-4,9.3496619956567883E-4}>>, value = dense<"0x149303E48431C9CBA6A92DC0554E46637E3D54E0BF88C64DA2FAF0C978B0C5C27FB027CB3916585C7C2CD1863E1762AE7F7F032A677B3587E4123B343739CA871B1BFFC6A2E8DE9BA46F03A933C60290CA8DEF0ABC7581227F5FBFDAAC57E0A520BE9228FB519F100C22117F6055EC7FBF94B56210333E6A526F4BE3838CF9465E212DC947A50470A37EFC3F4DC90256541D5FD4B1D45D6699070F7B42E190C0CA56AA173BDF009A9937D45611EC87CB9CB37437B4D4DA66FFFA5233CD3CA6CF30F7FB7B362DD6A48611AF9481815E79DDD1C89D7D8B34FD56C7030B2603DE7F403EAC8BAA570915517F4A08B5AF613F1697C26786E5788DF598FB7260FB4C3583C6BBA6F608927156CA623A744EBCD2386DDCBAE4D3E7815B037F3EBEE7FC468FFA2C9E4A81156AD095F24C52E87F982101B1327F2FF9D663B29E510578FB0A6FB75D1854285B97E4B79984C08D669ACBE0FD337FE3AAF9514AC3D7B1071BC90BAD7F8F9BF987BCDB2B3997FC6EBB519E6A397FA99CAE86EB1E6688B884C0E81C1CFB2B28F8BF6A0E94394D62F4D560"> : tensor<1x5x5x16xi8>} : () -> tensor<1x5x5x16x!quant.uniform<i8<-127:127>:f32:3, {9.0307911159470677E-4,9.0185547014698386E-4,9.0475002070888877E-4,8.9984521036967635E-4,9.1002165572717786E-4,8.8369252625852823E-4,9.2316285008564591E-4,8.6251541506499052E-4,9.3441049102693796E-4,8.4356177831068635E-4,9.306154097430408E-4,8.7729789083823562E-4,9.350875043310225E-4,9.1074523515999317E-4,9.1593258548527956E-4,9.3496619956567883E-4}>>
  %4 = "tfl.pseudo_qconst"() {qtype = tensor<16x!quant.uniform<i32:f32:0, {3.8722769204468932E-6,3.8670300455123652E-6,3.8794414649601094E-6,3.8584103094763122E-6,3.902045136783272E-6,3.7891497868258739E-6,3.9583928810316138E-6,3.6983451536798384E-6,4.0066211113298777E-6,3.6170747534924885E-6,3.9903484321257565E-6,3.7617303405568236E-6,4.0095242184179369E-6,3.9051478779583704E-6,3.9273904803849291E-6,4.0090039874485228E-6}>>, value = dense<0> : tensor<16xi32>} : () -> tensor<16x!quant.uniform<i32:f32:0, {3.8722769204468932E-6,3.8670300455123652E-6,3.8794414649601094E-6,3.8584103094763122E-6,3.902045136783272E-6,3.7891497868258739E-6,3.9583928810316138E-6,3.6983451536798384E-6,4.0066211113298777E-6,3.6170747534924885E-6,3.9903484321257565E-6,3.7617303405568236E-6,4.0095242184179369E-6,3.9051478779583704E-6,3.9273904803849291E-6,4.0090039874485228E-6}>>
  %5 = "tfl.depthwise_conv_2d"(%2, %3, %4) {depth_multiplier = 1 : i32, dilation_h_factor = 1 : i32, dilation_w_factor = 1 : i32, fused_activation_function = "RELU", padding = "SAME", stride_h = 2 : i32, stride_w = 2 : i32} : (tensor<?x96x128x16x!quant.uniform<i8:f32, 0.0042878598906099796:-128>>, tensor<1x5x5x16x!quant.uniform<i8<-127:127>:f32:3, {9.0307911159470677E-4,9.0185547014698386E-4,9.0475002070888877E-4,8.9984521036967635E-4,9.1002165572717786E-4,8.8369252625852823E-4,9.2316285008564591E-4,8.6251541506499052E-4,9.3441049102693796E-4,8.4356177831068635E-4,9.306154097430408E-4,8.7729789083823562E-4,9.350875043310225E-4,9.1074523515999317E-4,9.1593258548527956E-4,9.3496619956567883E-4}>>, tensor<16x!quant.uniform<i32:f32:0, {3.8722769204468932E-6,3.8670300455123652E-6,3.8794414649601094E-6,3.8584103094763122E-6,3.902045136783272E-6,3.7891497868258739E-6,3.9583928810316138E-6,3.6983451536798384E-6,4.0066211113298777E-6,3.6170747534924885E-6,3.9903484321257565E-6,3.7617303405568236E-6,4.0095242184179369E-6,3.9051478779583704E-6,3.9273904803849291E-6,4.0090039874485228E-6}>>) -> tensor<?x48x64x16x!quant.uniform<i8:f32, 0.001226827735081315:-128>>
  %6 = "tfl.pseudo_const"() {value = dense<[-1, 49152]> : tensor<2xi32>} : () -> tensor<2xi32>
  %7 = "tfl.reshape"(%5, %6) : (tensor<?x48x64x16x!quant.uniform<i8:f32, 0.001226827735081315:-128>>, tensor<2xi32>) -> tensor<?x49152x!quant.uniform<i8:f32, 0.001226827735081315:-128>>
  return %7 : tensor<?x49152x!quant.uniform<i8:f32, 0.001226827735081315:-128>>
}
