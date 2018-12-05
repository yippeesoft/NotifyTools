<template >
  <div>
    <!-- <Swiper
      ref="swiper"
      v-if="list.length > 0"
      :autoPlay="true"
      :showIndicator="true"
      interval="2500"
      duration="500"
    >
      <Slide @click="clickMe" v-for="(tag,key) in list" :key="key">
        <img :src="tag.img" mode="aspectFill">
      </Slide>
    </Swiper>
     
    <div>
      <button @click="preve">上一张</button>
    </div>-->
    <swiper :autoPlay="true" :showIndicator="true" interval="2500" duration="500">
      <swiper-item
        class="md-splash__item"
        v-for="(item, index) in list"
        :for-index="index"
        :key="index"
      >
        <image :src="item.img" class="md-splash__image" mode="aspectFill"/>
        <button class="md-splash__start" @click="handleStart" v-if="index === list.length - 1">立即体验</button>
      </swiper-item>
    </swiper>

    <div>
      <button @click="gotoShow">点击选择照片</button>
    </div>
    <div>
      <image :src="src" class="show-image" mode="aspectFitf" />
    </div>
    <div>
      <button @click="gotoSend">发送照片</button>
    </div>
  </div>
</template>

<script>
export default {
  data() {
    return {
      list: [
        {
          img:
            "https://qiniu.epipe.cn/5456575529551388672?imageslim&imageView2/1/w/750/h/360"
        },
        {
          img:
            "https://qiniu.epipe.cn/5430983074181545984?imageslim&imageView2/1/w/750/h/360"
        },
        {
          img:
            "https://qiniu.epipe.cn/5464226412548325376?imageslim&imageView2/1/w/750/h/360"
        }
      ],
      src: "../../static/profile.png"
    };
  },

  methods: {
    clickMe(index) {
      console.log(index);
    },
    preve() {
      this.$refs.swiper.prevSlide();
    },
    next() {
      this.$refs.swiper.nextSlide();
    },
    gotoSend: function() {

          console.log('gotoSend');
          var path = this.src;
          wx.uploadFile({
            url: "http://192.168.1.125:8081/file_upload",
            filePath: path,
            name: "file",
            header: { "Content-Type": "multipart/form-data" },
            formData: {
              data1: "w"
            },
            success: function(res) {
              console.log("ok "+res);
              wx.showToast({title:"ok "+res});
            },
            fail: function(res) {
              console.log("fail "+res);
              wx.showToast({title:"fail "+res});
            }
          });
        
     
    },

    gotoShow: function() {
      let _this = this;
      wx.chooseImage({
        count: 1, // 最多可以选择的图片张数，默认9
        sizeType: ["original", "compressed"], // original 原图，compressed 压缩图，默认二者都有
        sourceType: ["album", "camera"], // album 从相册选图，camera 使用相机，默认二者都有
        success: function(res) {
          // success
          //                 _this.setData({
          //                     src:res.tempFilePaths
          //                 })
          res.tempFilePaths.forEach(v => {
            console.log(v);
            _this.src = v;
          });
        },
        fail: function() {
          // fail
        },
        complete: function() {
          // complete
        }
      });
    }
  }
};
</script>

<style lang="scss">
page {
  height: 100%;
}

@include c("splash") {
  height: 100%;

  @include e("swiper") {
    height: 100%;
  }

  @include e("item") {
    flex: 1;
  }

  @include e("image") {
    position: absolute;
    height: 100%;
    width: 100%;
    opacity: 0.9;
  }

  @include e("start") {
    position: absolute;
    bottom: 200rpx;
    left: 50%;
    width: 300rpx;
    margin-left: -150rpx;
    background-color: rgba(64, 88, 109, 0.4);
    color: #fff;
    border: 1rpx solid rgba(64, 88, 109, 0.8);
    border-radius: 200rpx;
    font-size: 40rpx;
  }
}
</style>
