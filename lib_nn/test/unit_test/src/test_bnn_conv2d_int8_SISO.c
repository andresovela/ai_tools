
#include <stdlib.h>
#include <string.h>
#include <assert.h>

#include "tst_common.h"
#include "unity.h"

#include "helpers.h"

static const char undef_sentinal = 0x55;

//These are used for collecting int8 output stats
static int output_error_g[256] = {0};
static unsigned abs_output_error_g[256] = {0};
static unsigned error_counter_g[256] = {0};

/*
X_ref and K_ref must be initialised before running this.
This function test whole images, i.e. it wont work on a sub image.
*/
static void run_int8_config(int8_t* Y_p, int8_t* Y_ref_p, bnn_b32_t* X_ref,
               bnn_b32_t* K_p, bnn_b32_t* K_ref_p, 
               float* post_activation_multiplier,
               float* post_activation_bias, 

               int16_t * post_activation_multiplier_q,
               int16_t* post_activation_bias_q, 

               int * chan_overlaps,
               bnn_b32_t * data_scratch,
               
               unsigned x_height, unsigned x_width,
               unsigned k_height, unsigned k_width, unsigned chans_in,
               unsigned chans_out, unsigned h_stride, unsigned v_stride, int seed) {
                  
  assert(Y_p != Y_ref_p);
  assert(K_p != K_ref_p);

  unsigned y_height = CONV2D_OUTPUT_LENGTH(x_height, k_height, 1, v_stride);
  unsigned y_width = CONV2D_OUTPUT_LENGTH(x_width, k_width, 1, h_stride);

  unsigned X_bytes = (x_height * x_width * chans_in) / 8;
  unsigned K_bytes = (k_width * k_height * chans_in * chans_out) / 8;
  unsigned Y_bytes = (y_width * y_height * chans_out);

  unsigned receptive_volume = k_width * k_height * chans_in;

  //Pick some random test values
  make_thresholds(post_activation_multiplier, post_activation_bias, chans_out, receptive_volume, seed);


  int32_t clamp_low = 0;
  int32_t clamp_high = receptive_volume*2;

  nn_image_params_t x;
  x.height = x_height;
  x.width = x_width;
  x.channels = chans_in;
  nn_image_params_t y;
  y.height = y_height;
  y.width = y_width;
  y.channels = chans_out;
  nn_window_params_t k;
  k.shape.height = k_height;
  k.shape.width = k_width;
  k.stride.horizontal = h_stride;
  k.stride.vertical = v_stride;
  k.dilation.horizontal = 1;
  k.dilation.vertical = 1;

  larq_ref_bconv2d_int8_out(&x, &y, &k, (int32_t*)X_ref, (int32_t*)K_ref_p,
                   (int8_t*)Y_ref_p, post_activation_multiplier, post_activation_bias);

  bnn_reorder_int8_kernel_tensor(K_p, K_ref_p, k_height, k_width, chans_in,
                            chans_out, chan_overlaps);

  int16_t bias_multipler;
  int accu_shr, final_shr;

  bnn_quantise_activation(
      post_activation_multiplier_q,
      post_activation_bias_q,

      post_activation_multiplier,
      post_activation_bias, 

      chans_out,

      clamp_low, clamp_high,
      &accu_shr, &bias_multipler, &final_shr, receptive_volume, chan_overlaps
  );

  bnn_conv2d_int8_out_SISO((int8_t*)Y_p, (const bnn_b32_t*)X_ref,
    (const bnn_b32_t*)K_p, post_activation_multiplier_q, 
    post_activation_bias_q, accu_shr, bias_multipler, final_shr,
    data_scratch,
    &x, &y, &k,
    0, 0, y_width, y_height,
    0, 0, 
    0, 0, k_width, k_height);


int8_t(*Y)[y_width][chans_out] =
      (int8_t(*)[y_width][chans_out])Y_p;

  int8_t(*Y_ref)[y_width][chans_out] =
      (int8_t(*)[y_width][chans_out])Y_ref_p;

  int broken = 0;
  for (unsigned h = 0; h < y_height; h++) {
    for (unsigned w = 0; w < y_width; w++) {
      //If the result should have been computed then check it against the reference
      for (unsigned c = 0; c < chans_out; c++) {
        if((Y_ref[h][w][c] - Y[h][w][c]) * (Y_ref[h][w][c] - Y[h][w][c]) > 1){
          broken = 1;
        }
      }
    }
  }
  if (broken)
  for (unsigned h = 0; h < y_height; h++) {
    for (unsigned w = 0; w < y_width; w++) {
      //If the result should have been computed then check it against the reference
      for (unsigned c = 0; c < chans_out; c++) {
        printf("%2u e% d a% d", c,  Y_ref[h][w][c], Y[h][w][c]);
        if((Y_ref[h][w][c] - Y[h][w][c]) * (Y_ref[h][w][c] - Y[h][w][c]) > 1){
          printf(" *******");
        }
        printf("\n");
      }
      printf("\n");
    }
    printf("\n");
  }


  for (unsigned e=0;e<y_height * y_width * chans_out;++e)
    TEST_ASSERT_INT8_WITHIN(1, Y_ref_p[e], Y_p[e]);

  //FIXME - why wont this link? The above is a workaround
  // TEST_ASSERT_INT8_ARRAY_WITHIN(1, Y_ref_p, Y_p, y_height * y_width * chans_out);
}

void test_bnn_conv2d_int8_out_SISO_pseudo_directed() {
#define X_V_DILATION 1
#define X_H_DILATION 1
#define X_HEIGHT 2
#define X_WIDTH 2
#define K_HEIGHT 2
#define K_WIDTH 2
#define CHANS_IN (256)
#define CHANS_OUT 4
#define H_STRIDE 1
#define V_STRIDE 1

#define Y_HEIGHT \
  CONV2D_OUTPUT_LENGTH(X_HEIGHT, K_HEIGHT, X_V_DILATION, V_STRIDE)
#define Y_WIDTH CONV2D_OUTPUT_LENGTH(X_WIDTH, K_WIDTH, X_H_DILATION, H_STRIDE)

#define CHAN_WORDS_IN DIV_BY_AND_ROUND_UP(CHANS_IN, 32)

  //arrys not used by the asm
  bnn_b32_t WORD_ALIGNED K_ref[CHANS_OUT][K_HEIGHT][K_WIDTH][CHAN_WORDS_IN];
  int8_t WORD_ALIGNED Y_ref[Y_HEIGHT][Y_WIDTH][CHANS_OUT];
  float WORD_ALIGNED post_activation_multiplier[CHANS_OUT];
  float WORD_ALIGNED post_activation_bias[CHANS_OUT];
  int chan_overlaps[CHANS_OUT]; 

  bnn_b32_t WORD_ALIGNED K[CHANS_OUT*K_HEIGHT*K_WIDTH*CHAN_WORDS_IN + 32*12];
  bnn_b32_t WORD_ALIGNED X_ref[X_HEIGHT*X_WIDTH*CHAN_WORDS_IN+8];
  int8_t WORD_ALIGNED Y[Y_HEIGHT][Y_WIDTH][CHANS_OUT];
  int16_t WORD_ALIGNED post_activation_multiplier_q[CHANS_OUT+32];
  int16_t WORD_ALIGNED post_activation_bias_q[CHANS_OUT+32];
  bnn_b32_t WORD_ALIGNED data_scratch[K_HEIGHT * K_WIDTH * CHAN_WORDS_IN + 
    NN_BCONV2D_KERNEL_OVERRUN_WORDS]; 

  for(unsigned i=0;i<1<<12;i++){
    int seed = i;
    // printf("%d\n", i);
    srand(i);
    pseudo_rand_bytes((char*)X_ref, sizeof(X_ref));
    pseudo_rand_bytes((char*)K_ref, sizeof(K_ref));

    // printf("size %u\n", sizeof(X_ref));
    // for(unsigned c=0;c<sizeof(X_ref);c++){
    //   ((char*)X_ref )[c] = c;
    // }
    memset(K, 0, sizeof(K));
    memset(Y, 0, sizeof(Y));
    memset(Y_ref, 0, sizeof(Y_ref));

    // printf("%p %p\n",post_activation_multiplier_q, post_activation_bias_q );
    run_int8_config((int8_t *)Y, (int8_t*)Y_ref, (bnn_b32_t*)X_ref,
                (bnn_b32_t*)K, (bnn_b32_t*)K_ref, (float*)post_activation_multiplier,
                (float*)post_activation_bias, (int16_t*)post_activation_multiplier_q,
                (int16_t*)post_activation_bias_q, 
                (int*)chan_overlaps, 
                (bnn_b32_t*)data_scratch, 
                X_HEIGHT, X_WIDTH, K_HEIGHT, K_WIDTH,
                CHANS_IN, CHANS_OUT, H_STRIDE, V_STRIDE, seed);
  }
#undef X_V_DILATION 
#undef X_H_DILATION
#undef X_HEIGHT 
#undef X_WIDTH 
#undef K_HEIGHT
#undef K_WIDTH
#undef CHANS_IN 
#undef CHANS_OUT 
#undef H_STRIDE
#undef V_STRIDE
#undef Y_HEIGHT
#undef Y_WIDTH 
#undef CHAN_WORDS_IN
}

void test_bnn_conv2d_int8_out_SISO_pseudo_random() {
#define MIN_H_STRIDE 1
#define MIN_V_STRIDE 1
#define MAX_H_STRIDE 4
#define MAX_V_STRIDE 4

#define MIN_K_HEIGHT 1
#define MIN_K_WIDTH 1
#define MAX_K_HEIGHT 6
#define MAX_K_WIDTH 6

#define MIN_CHANS_IN 32
#define MAX_CHANS_IN (32*5)

#define MIN_CHANS_OUT (4*1)
#define MAX_CHANS_OUT (4*7)

#define MIN_X_HEIGHT MIN_K_HEIGHT
#define MIN_X_WIDTH MIN_K_WIDTH
#define MAX_X_HEIGHT MAX_K_HEIGHT
#define MAX_X_WIDTH MAX_K_WIDTH

#define MAX_CHAN_WORDS_IN DIV_BY_AND_ROUND_UP(MAX_CHANS_IN, 32)

#define MAX_Y_HEIGHT CONV2D_OUTPUT_LENGTH(MAX_X_HEIGHT, MIN_K_HEIGHT,1,  MIN_V_STRIDE)
#define MAX_Y_WIDTH CONV2D_OUTPUT_LENGTH(MAX_X_WIDTH, MIN_K_WIDTH, 1, MIN_H_STRIDE)

  //data not used by the implementation
  bnn_b32_t WORD_ALIGNED
      K_ref[MAX_CHANS_OUT][MAX_K_HEIGHT][MAX_K_WIDTH][MAX_CHAN_WORDS_IN];
  int8_t WORD_ALIGNED Y_ref[MAX_Y_HEIGHT][MAX_Y_WIDTH][MAX_CHANS_OUT];
  float WORD_ALIGNED post_activation_multiplier[MAX_CHANS_OUT];
  float WORD_ALIGNED post_activation_bias[MAX_CHANS_OUT];
  int chan_overlaps[MAX_CHANS_OUT];

  for (unsigned h_stride = MIN_H_STRIDE; h_stride <= MAX_H_STRIDE; ++h_stride) {
    for (unsigned v_stride = MIN_V_STRIDE; v_stride <= MAX_V_STRIDE;
         ++v_stride) {
      for (unsigned k_height = MIN_K_HEIGHT; k_height <= MAX_K_HEIGHT;
           ++k_height) {
        for (unsigned k_width = MIN_K_WIDTH; k_width <= MAX_K_WIDTH;
             ++k_width) {
          for (unsigned x_height = k_height; x_height <= MAX_X_HEIGHT;
               ++x_height) {
            for (unsigned x_width = k_width; x_width <= MAX_X_WIDTH;
                 ++x_width) {
              unsigned y_height =  CONV2D_OUTPUT_LENGTH(x_height, k_height, 1, v_stride);
              unsigned y_width = CONV2D_OUTPUT_LENGTH(x_width, k_width, 1, h_stride);
              
              for (unsigned chans_in = MIN_CHANS_IN; chans_in <= MAX_CHANS_IN;
                   chans_in += 32) {
                for (unsigned chans_out = MIN_CHANS_OUT;
                     chans_out <= MAX_CHANS_OUT; chans_out += 4) {

                  unsigned chan_words_in = chans_in/32;

                  bnn_b32_t *X_ref =(bnn_b32_t *)malloc(sizeof(bnn_b32_t)*(x_height*x_width*chan_words_in+80000));
                  int16_t *post_activation_multiplier_q = (int16_t *)malloc(sizeof(int16_t)*(chans_out+(16 - chans_out%16)));
                  int16_t *post_activation_bias_q = (int16_t *)malloc(sizeof(int16_t)*(chans_out+(16 - chans_out%16)));
                  bnn_b32_t *data_scratch = (bnn_b32_t *)malloc(sizeof(bnn_b32_t)*(k_height * k_width * chan_words_in + 8)); 
                  int8_t *Y = (int8_t *) malloc(sizeof(int8_t) * y_height*y_width*chans_out);
                  
                  bnn_b32_t * K= (bnn_b32_t *)malloc(sizeof(bnn_b32_t)*( chans_out*k_height*k_width*chan_words_in +92));
      
                  // printf("h_stride:%u v_stride:%u k_height:%u k_width:%u x_height:%u x_width:%u chans_in:%u chans_out:%u\n", 
                  //   h_stride, v_stride, k_height, k_width, x_height, x_width, chans_in, chans_out);
                    for(unsigned c=0;c<1<<0;c++){
                      int seed =c;
                      srand(seed);
                      pseudo_rand_bytes((char*)X_ref, sizeof(X_ref));
                      pseudo_rand_bytes((char*)K_ref, sizeof(K_ref));
                      run_int8_config(
                          (int8_t*)Y, (int8_t*)Y_ref, (bnn_b32_t*)X_ref,
                          (bnn_b32_t*)K, (bnn_b32_t*)K_ref,
                          (float*)post_activation_multiplier,
                          (float*)post_activation_bias, 
                          (int16_t*)post_activation_multiplier_q,
                          (int16_t*)post_activation_bias_q,  
                          (int*) chan_overlaps,
                          (bnn_b32_t * ) data_scratch,
                          x_height,
                          x_width, k_height, k_width, chans_in, chans_out, h_stride,
                          v_stride, seed);
                    }

                    free(X_ref);
                    free(Y);
                    free(post_activation_multiplier_q);
                    free(post_activation_bias_q);
                    free(data_scratch);
                    free(K);
                }
              }
            }
          }
        }
      }
    }
  }
#undef MIN_H_STRIDE 
#undef MIN_V_STRIDE 
#undef MAX_H_STRIDE 
#undef MAX_V_STRIDE 
#undef MIN_K_HEIGHT 
#undef MIN_K_WIDTH 
#undef MAX_K_HEIGHT 
#undef MAX_K_WIDTH 
#undef MIN_CHANS_IN 
#undef MAX_CHANS_IN 
#undef MIN_CHANS_OUT 
#undef MAX_CHANS_OUT 
#undef MIN_X_HEIGHT 
#undef MIN_X_WIDTH 
#undef MAX_X_HEIGHT 
#undef MAX_X_WIDTH 
#undef MAX_CHAN_WORDS_IN 
#undef MAX_CHAN_WORDS_OUT 
#undef MAX_Y_HEIGHT
#undef MAX_Y_WIDTH
}

static int run_int8_sub_image(
              int8_t* Y_p, 
              const int8_t* Y_ref_p, 
              const bnn_b32_t* X_p,
              const bnn_b32_t* K_p, 

              int16_t * post_activation_multiplier_q,
              int16_t * post_activation_bias_q,
              const int accu_shr,
              const int16_t bias_multiplier,
              const int final_shr,
              
              bnn_b32_t * data_scratch,

              const nn_image_params_t* x,
              const nn_image_params_t* y,
              const nn_window_params_t* k,
              unsigned y_loc_x, unsigned y_loc_y, 
              unsigned y_sub_width, unsigned y_sub_height){

  bnn_conv2d_int8_out_SISO_valid(Y_p, X_p,
                      K_p, post_activation_multiplier_q,
                      post_activation_bias_q, accu_shr, bias_multiplier, final_shr, 
                      data_scratch, x, y, k,
                      y_loc_x, y_loc_y, y_sub_width, y_sub_height);

  int8_t(*Y)[y->width][y->channels] =
      (int8_t(*)[y->width][y->channels])Y_p;

  int8_t(*Y_ref)[y->width][y->channels] =
      (int8_t(*)[y->width][y->channels])Y_ref_p;

  int broken =0;
  for (unsigned h = 0; h < y->height; h++) {
    for (unsigned w = 0; w < y->width; w++) {
      if((h >= y_loc_y) && (h < (y_loc_y + y_sub_height)) && (w >= y_loc_x) && (w < (y_loc_x + y_sub_width))){
        //If the result should have been computed then check it against the reference
        for (unsigned c = 0; c < y->channels; c++) {
          if((Y_ref[h][w][c] - Y[h][w][c]) * (Y_ref[h][w][c] - Y[h][w][c]) > 1)
            broken = 1;
        }
      } else {
        //Otherwise check thet is hasn't been written to
        for (unsigned c = 0; c < y->channels; c++) {
          if((undef_sentinal - Y[h][w][c]) * (undef_sentinal - Y[h][w][c]) > 1)
            broken = 1;
        }
      }
    }
  }

  if (broken)
    return 1;
  return 0;
    for (unsigned h = 0; h < y->height; h++) {
      for (unsigned w = 0; w < y->width; w++) {
        if((h >= y_loc_y) && (h < (y_loc_y + y_sub_height)) && (w >= y_loc_x) && (w < (y_loc_x + y_sub_width))){
          //If the result should have been computed then check it against the reference
          for (unsigned c = 0; c < y->channels; c++) {
            printf("%d %d\t", Y_ref[h][w][c], Y[h][w][c]);
          }
        } else {
          //Otherwise check thet is hasn't been written to
          for (unsigned c = 0; c < y->channels; c++) {
            printf("0x%x\t", Y[h][w][c]);
          }
        }
        printf("\n");
      }
      printf("\n");
    }

  for (unsigned h = 0; h < y->height; h++) {
    for (unsigned w = 0; w < y->width; w++) {
      if((h >= y_loc_y) && (h < (y_loc_y + y_sub_height)) && (w >= y_loc_x) && (w < (y_loc_x + y_sub_width))){
        //If the result should have been computed then check it against the reference
        for (unsigned c = 0; c < y->channels; c++) {
          TEST_ASSERT_INT8_WITHIN(1, Y_ref[h][w][c], Y[h][w][c]);
        }
      } else {
        //Otherwise check thet is hasn't been written to
        for (unsigned c = 0; c < y->channels; c++) {
          TEST_ASSERT_EQUAL_INT8(undef_sentinal, Y[h][w][c]);
        }
      }
    }
  }
}


/*
This test check for a fixed x_height, x_width, k_height and k_width a sub-region of the output
is correctly computed. It check this for MIN_CHANS_IN and MAX_CHANS_IN input channels and 
MIN_CHANS_OUT to MAX_CHANS_OUT output channels. Stride are tested, dilations are untested currently.
*/
void test_bnn_conv2d_int8_out_SISO_sub_image(){

  #define FULL_X_HEIGHT 7
  #define FULL_X_WIDTH 7
  #define FULL_K_HEIGHT 4
  #define FULL_K_WIDTH 4

  #define MIN_CHANS_IN (32*1)
  #define MAX_CHANS_IN (32*16)
  #define MIN_CHANS_OUT (4)
  #define MAX_CHANS_OUT (12)
  
  #define X_V_DILATION 1
  #define X_H_DILATION 1

  srand(42);

  unsigned c=0;

  for(unsigned chans_out = MIN_CHANS_OUT; chans_out <= MAX_CHANS_OUT; chans_out += 4){
    for(unsigned chans_in = MIN_CHANS_IN; chans_in <= MAX_CHANS_IN; chans_in += 32){

      unsigned chan_words_in = chans_in/32;

      size_t K_ref_bytes = sizeof(bnn_b32_t) * (chans_out*FULL_K_HEIGHT*FULL_K_WIDTH*chan_words_in);
      bnn_b32_t * K_ref = (bnn_b32_t * ) malloc(K_ref_bytes);
      bnn_b32_t * X_ref = (bnn_b32_t *) malloc(sizeof(bnn_b32_t)*(FULL_X_HEIGHT*FULL_X_WIDTH*chan_words_in+7));
      int16_t * post_activation_multiplier_q = (int16_t *) malloc(sizeof(int16_t)*(chans_out+(16 - chans_out%16)));
      int16_t * post_activation_bias_q = (int16_t *) malloc(sizeof(int16_t)*(chans_out+(16 - chans_out%16)));
      bnn_b32_t *data_scratch = (bnn_b32_t *) malloc(sizeof(bnn_b32_t)*(FULL_K_HEIGHT * FULL_K_WIDTH * chan_words_in + 8)); 
      bnn_b32_t * K = (bnn_b32_t *) malloc(sizeof(bnn_b32_t)*(chans_out*FULL_K_HEIGHT*FULL_K_WIDTH*chan_words_in + 8*12));

      float * post_activation_multiplier = (float *)malloc(sizeof(float)*(chans_out + (16 - chans_out%16)));
      float * post_activation_bias = (float *)malloc(sizeof(float)*(chans_out + (16 - chans_out%16)));
      int * chan_overlaps = (int *)malloc(sizeof(int)*(chans_out));

      for (unsigned h_stride = 1; h_stride < 2; h_stride++){
        for (unsigned v_stride=1; v_stride < 2; v_stride++){
            
          nn_image_params_t x;
          x.height = FULL_X_HEIGHT;
          x.width = FULL_X_WIDTH;
          x.channels = chans_in;
          nn_image_params_t y;
          y.height = CONV2D_OUTPUT_LENGTH(FULL_X_HEIGHT, FULL_K_HEIGHT, X_V_DILATION, v_stride);
          y.width = CONV2D_OUTPUT_LENGTH(FULL_X_WIDTH, FULL_K_WIDTH, X_H_DILATION, h_stride);
          y.channels = chans_out;
          nn_window_params_t k;
          k.shape.height = FULL_K_HEIGHT;
          k.shape.width = FULL_K_WIDTH;
          k.stride.horizontal = h_stride;
          k.stride.vertical = v_stride;
          k.dilation.horizontal = X_H_DILATION;
          k.dilation.vertical = X_V_DILATION;

          int8_t * Y_ref = (int8_t *) malloc(sizeof(int8_t) * y.height * y.width * y.channels);
          int8_t * Y     = (int8_t *) malloc(sizeof(int8_t) * y.height * y.width * y.channels);    

          // printf("y.height:%u y.width:%u h_stride:%u v_stride:%u chans_in:%u chans_out:%u\n", y.height,y.width, h_stride, v_stride, chans_in, chans_out);

          for(unsigned i=0;i<1<<6;i++){

            pseudo_rand_bytes((char*)K_ref, K_ref_bytes);
            pseudo_rand_bytes((char*)X_ref, sizeof(bnn_b32_t)*(FULL_X_HEIGHT*FULL_X_WIDTH*chan_words_in+7));

            unsigned receptive_volume = k.shape.width * k.shape.height * x.channels;

            make_thresholds(post_activation_multiplier, post_activation_bias, chans_out, receptive_volume, rand());

            // for(unsigned i=1;i<chans_out;i++){
            //   post_activation_multiplier[i] = post_activation_multiplier[0];
            //   post_activation_bias[i] = post_activation_bias[0];
            // }

            //Calculate the entire reference image
            larq_ref_bconv2d_int8_out(&x, &y, &k, (const int32_t*)X_ref, (const int32_t*)K_ref,
                        (int8_t*)Y_ref, post_activation_multiplier, post_activation_bias);

            int32_t clamp_low = 0;      //FIXME
            int32_t clamp_high = receptive_volume*2;

            bnn_reorder_int8_kernel_tensor((bnn_b32_t *)K, (const bnn_b32_t *)K_ref, k.shape.height, 
              k.shape.width, x.channels, y.channels, chan_overlaps);


            unsigned total_bytes_copied_to_scratch = (x.channels * k.shape.height * k.shape.width)/8;
              if((total_bytes_copied_to_scratch%32) == 0){
                  for(unsigned ch=0;ch<chans_out;ch++){
                    assert( chan_overlaps[ch] == 0);
                  }
              }


            int accu_shr, final_shr;
            int16_t bias_multiplier;
            bnn_quantise_activation(
                post_activation_multiplier_q,
                post_activation_bias_q,

                post_activation_multiplier,
                post_activation_bias, 

                chans_out,

                clamp_low, clamp_high,
                &accu_shr, &bias_multiplier, &final_shr, receptive_volume, chan_overlaps
            );

            // printf("%u\n", c++);

            // for (unsigned y_loc_x = 0; y_loc_x<1; ++y_loc_x){
            //   for (unsigned y_loc_y = 0; y_loc_y<1; ++y_loc_y){
            //     for (unsigned y_sub_width = 1; y_sub_width<2; ++y_sub_width){
            //       for (unsigned y_sub_height = 1; y_sub_height<2; ++y_sub_height){

            for (unsigned y_loc_x = 0; y_loc_x<y.width; ++y_loc_x){
              for (unsigned y_loc_y = 0; y_loc_y<y.height; ++y_loc_y){
                for (unsigned y_sub_width = 1; y_sub_width<y.width-y_loc_x; ++y_sub_width){
                  for (unsigned y_sub_height = 1; y_sub_height<y.height-y_loc_y; ++y_sub_height){

                      // printf("y_loc_x:%u y_loc_y:%u y_sub_width:%u y_sub_height:%u\n", y_loc_x, y_loc_y, y_sub_width, y_sub_height);
                      
                      size_t addressable_Y_bytes = y.height * y.width * y.channels;
                      memset(Y, undef_sentinal, addressable_Y_bytes);

                      int r = run_int8_sub_image(
                        (int8_t*)Y, 
                        (const int8_t*)Y_ref,
                        (const bnn_b32_t*) X_ref,
                        (const bnn_b32_t*) K, 

                        (int16_t * )post_activation_multiplier_q,
                        (int16_t *) post_activation_bias_q,
                        (const int )accu_shr,
                        (const int16_t) bias_multiplier,
                        (const int )final_shr,
                        
                        (bnn_b32_t *) data_scratch,

                        &x, &y, &k,
                        y_loc_x, y_loc_y, y_sub_width, y_sub_height);

                        if (r) printf("lllllllllllllllll\n");
                    }
                  }
                } 
              }
            }
            free(Y_ref);
            free(Y);
        }
      }
      free(K_ref);
      free(X_ref);
      free(post_activation_multiplier);
      free(post_activation_bias);
      free(chan_overlaps);
      free(post_activation_multiplier_q);
      free(post_activation_bias_q);
      free(data_scratch);

    }
  }

  #undef FULL_X_HEIGHT
  #undef FULL_X_WIDTH 
  #undef FULL_K_HEIGHT 
  #undef FULL_K_WIDTH 
  #undef CHANS_IN 
  #undef CHANS_OUT 
  #undef X_V_DILATION 
  #undef V_STRIDE 
  #undef X_H_DILATION 
  #undef H_STRIDE 
  #undef CHAN_WORDS_IN 
  #undef FULL_Y_HEIGHT
  #undef FULL_Y_WIDTH 

}

void test_bnn_conv2d_int8_SISO() {
  UNITY_SET_FILE();
  RUN_TEST(test_bnn_conv2d_int8_out_SISO_pseudo_directed);
  RUN_TEST(test_bnn_conv2d_int8_out_SISO_pseudo_random);
  RUN_TEST(test_bnn_conv2d_int8_out_SISO_sub_image);

}